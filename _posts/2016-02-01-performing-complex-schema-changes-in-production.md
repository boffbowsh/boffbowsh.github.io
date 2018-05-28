---
layout: post
title: Performing complex schema changes in production
---

Changing a database schema on a production application can be a complicated and risky process. Due to the nature of some of these schema changes and the underlying database engine, the physical change may take many minutes and can block clients from performing operations on affected tables. Even a change that completes in seconds with no blocking can result in applications getting confused when the layout of the database changes underneath them.

Our own Michael Brunton-Spall explains [the conventional wisdom](http://www.brunton-spall.co.uk/post/2014/05/06/database-migrations-done-right) which is to perform these changes in small, backwards-compatible steps, thus reducing if not completely removing downtime. Part of the advice is to uncouple the instructions for changing the schema from the application code.

However, as GOV.UK primarily uses Ruby on Rails and tries to optimise for developer familiarity and productivity, we continue to use Rails' [Database Migrations](http://guides.rubyonrails.org/active_record_migrations.html) model. This works for 99% of our schema changes where we don't have large tables, we use a database engine that handles changes more efficiently, or simply where the change isn't that complex. The running of migrations is automated and rehearsed in our integration and staging environments before hitting production.

## The awkward 1%

Recently we hit an edge case schema change that the Migration model didn't suit. We needed to refactor a large table in our Signon app, which provides single sign-on to our suite of Publisher applications. Signon uses MySQL which is notoriously bad at handling schema changes without locking the entire table. We needed to end up with a net change of having a new integer foreign key column that replaced a string column, which throughout 5 million records had only 30 distinct values.

This table is our event log for users of Signon. It stores when people log in (or fail to), change their password, get locked out and many other situations. The information is vital to our User Support team when helping Government users who are having problems logging in to a publishing application. If the table were to be locked for an extended period of time, users wouldn't be able to log in to their publishing applications for the most embarrassing reason of the debug logging failing to write.

## Adding the new column

Any `ALTER TABLE` statement in MySQL will exclusively lock the whole table for writing, meaning any requests that need to log an event would stall until the operation is complete. In the case of this 5 million row table, this turned out to take around a minute which would hit our user timeout limit of 15 seconds.

Luckily there's a utility called `pt-online-schema-change`, part of the free [Percona Toolkit](https://www.percona.com/software/mysql-tools/percona-toolkit), which makes `ALTER TABLE` non-blocking. It creates a new table based on the table's current schema, runs the change on it, copies the data to the new table and then renames the tables so that the new changed table has the name of the old table. It also creates triggers on the old table to ensure that any data changes while this process is happening is replicated in the new table. For DBAs used to the pain of schema changes, it embodies Clarke's Third Law, "Any sufficiently advanced technology is indistinguishable from magic."

Armed with this, we created the new column and faked the running of the Rails migration in the `schema_migrations` table, so that subsequent deploys wouldn't try to run the migration manually. We still wanted a Rails migration to cover the schema change, partly for record keeping but also for development environments where the full table lock wasn't an issue. We could then deploy the code change that wrote to both the integer and text columns at the same time, and populate the new column from the old text column for older records. We also changed our support interface to read only from the new column and ignore the old column.

## Removing the old column

Once all the code was referring to the new column, in theory we should have been able to remove the old column using `pt-online-schema-change` again. However if we had done this, Rails would still have included it in the `INSERT` statements even if no values were being written to it. This would have caused MySQL to throw an error saying the column doesn't exist. To work around this, we needed to perform a couple of additional deployments that gradually move towards the column removal, but retain backwards-compatibility between releases.

The first was another schema change to add a default value to the text column. As this was just a metadata change to the column definition, MySQL didn't need to lock the table in order to make any physical changes. We needed to add this default as the column was defined as `NOT NULL`, so trying to insert a row without supplying a value would result in a MySQL error.

Once this change had been applied, we needed to make Rails ignore the column completely. We had some functionality in our Inside Government application for this purpose, so we extracted it into a gem called [deprecated_columns](https://rubygems.org/gems/deprecated_columns). It simply allows you to mark certain columns as removable, and forces Rails to exclude it from its internal representation of a table's layout. We added and configured the gem, deployed the application again and were finally able to remove the column using `pt-online-schema-change` with no user impact or downtime.

## Understand your abstractions

Abstractions like Rails' Database Migrations model are very useful for the most part and are a huge win for developer productivity, however their internal behaviours need to be well understood when used in production. On GOV.UK, all developers assist running the site in production by taking shifts in our [2nd Line Technical Support](https://gds.blog.gov.uk/2015/11/18/how-we-improved-technical-support-at-gov-uk/) rota. This makes us conscious of the operational impact of changes we make in development and helps us judge the consequences of abstractions we use.

_This post originally appeared on the [GDS Technology blog](https://gdstechnology.blog.gov.uk/2016/02/01/performing-complex-schema-changes-in-production/)_