---
layout: post
title: Easing the process of pull request reviews
---

On the GOV.UK team, all our changes are peer reviewed using [Github's pull request system](https://help.github.com/articles/about-pull-requests/). If a developer wants to make a change to one of our projects, they need another developer’s approval before the change is accepted into the source repository. A reviewer can comment on parts of the change to offer feedback and suggest improvements. This review process is essential for sharing knowledge and limiting the bugs we introduce into our applications.

When reviewing code, developers can suggest a few different classes of improvements. Someone with a lot of knowledge about the project might spot an unintended side effect of a code change. A team mate with context on the product may spot code inconsistencies with the story being worked on. An expert in the framework or language may suggest a simpler implementation of the suggested code.

Only humans can make these structural and contextual based suggestions. They have the ability to understand the requested change within a wider context. They can make judgement calls on whether an approach is suitable for the desired outcome. They can spot [gotchas](https://en.wikipedia.org/wiki/Gotcha_(programming)) that have caught them out in the past.

Spotting these issues is very important for production systems that are the size, scale and scope of GOV.UK. It’s important to ensure developers spend as much of their time as possible focussed on structural and contextual based recommendations during reviews rather than issues of style.

## Removing style from the review process

We publish [style guides](https://github.com/alphagov/styleguides/blob/master/ruby.md) for all the languages we use. These guides specify rules such as how many spaces to use between characters and when to use multiline blocks.

When reviewing code, developers’ eyes are drawn to common contraventions and comments that are hastily written. Developers tend to be great at spotting style mistakes, just as spelling mistakes are obvious to a well trained writer. The problem is this developer focus on style runs counter to the main intentions of the pull request process for developers to review the intention of a change and share knowledge.

Developers may be so focussed on an errant space that they miss a flaw that could present errors to GOV.UK users. And, even if a reviewer spots the real issue, they still spend time suggesting the style change. For the pull request author, being questioned about a simple mistake by a peer can be embarrassing. If the change is a result of days of work, being told within a few minutes that you used an older syntax is demoralising. If one person is constantly picking up on a particular team mate's errors, it can lead to unnecessary tension.

These problems can be removed if developers don’t have to focus on style during the Pull Request review. We can instead use software to run these style checks.

## Automatic style enforcement

We can codify our style guides to have software check code against our particular preferences. For Ruby code, we use a tool called [Rubocop](https://github.com/bbatsov/rubocop) to achieve this.

We started by turning our style guides into a Rubocop configuration file and checking it into our style guide repository. This tells Rubocop which checks to run, and how strict to be. We then copy this file into our other repositories and run Rubocop as part of our build and test process.

We used this approach in a few places, but maintaining the configuration file this way wasn't sustainable. We often needed to change the Rubocop style rules to fill certain gaps in the style guide or to add rules for newly released language features. Every time we made a change, we’d have to copy the file to every project again, which took some time. This sometimes meant style inconsistencies between projects and developers not always getting the most up to date style feedback on their code.

We created the [govuk-lint](https://rubygems.org/gems/govuk-lint) gem as a way to simplify the process of maintaining, updating and applying Rubocop style rules.

We bundled our Rubocop configuration files with the gem. The gem's own wrapper script ensures our latest Rubocop configuration file (holding our style guide rules) is run in all our projects. When our style guidelines change, we just update the gem version in each project rather than copying the Rubocop file into each of our project repositories.

We can then discuss changes to the Rubocop configuration file every time a pull request is made against the gem, allowing us to version the Rubocop configuration and track changes. Discussing all style changes in a single place rather than per project ensures everyone can be involved, and means style conversations aren’t distracting developers from their project work.

## Applying Rubocop to changes only

Some of our older projects had too many style issues to be able to apply Rubocop to the entire codebase. We knew that some of these projects would be retired soon, and so we didn't spend the effort tidying them. However, we still wanted to use Rubocop to ensure our changes didn't make the code style even worse.

To do this, we added a feature to our gem’s wrapper script to ensure Rubocop only operates on lines we change from the master branch of code. This allows us to only show issues with the current pull request code change, a development inspired by a similar feature in flake8 (the Python version of Rubocop).

## Realising the benefits

When we implemented this automatic style enforcement across our code, we noticed pull request reviews getting easier.

Developers were able to get style feedback before even raising a pull request. This led to less public embarrassment for them as they much prefer being told off by an emotionless robot than by their colleagues. Also, developers no longer have to remember each detail of the style guide since Rubocop has auto correct styling functionality for most checks.

Over time, reviewers have begun to ignore styling issues, focussing more on the substance of their change. Whenever there’s an occasional debate about style within a pull request, we move the conversation to a pull request against the Rubocop configuration file in the govuk-lint gem.

All these benefits add up to happier developers and improved team velocity. We spend less time on a job that software is better at. Developers get much faster feedback on their code. Our projects are also more aligned with our style guides, and new developers see fewer differences between projects.

_This post originally appeared on the [GDS Technology blog](https://gdstechnology.blog.gov.uk/2016/09/30/easing-the-process-of-pull-request-reviews/)_