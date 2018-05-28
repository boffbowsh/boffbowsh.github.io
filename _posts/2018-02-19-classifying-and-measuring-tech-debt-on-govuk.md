---
layout: post
title: Classifying and measuring tech debt in GOV.UK
---

GOV.UK was built rapidly to meet a tight deadline. The push to get GOV.UK out of beta into live, transitioning 326 government websites onto the single domain, and closing down Directgov and BusinessLink resulted in a significant amount of [technical debt](https://en.wikipedia.org/wiki/Technical_debt).

Creating technical debt in this way is fine, it’s an expected result of building at pace. We took a strategic decision to prioritise delivery in order to give the best immediate value to the taxpayer, knowing we would incur tech debt. Our recent programme of work to migrate much of GOV.UK to a [new Publishing Platform](https://insidegovuk.blog.gov.uk/2015/10/27/rebuilding-gov-uks-publishing-tools/) was a proactive repayment of this technical debt. This migration programme enabled the build work in our [roadmap for 2017 to 2018](https://insidegovuk.blog.gov.uk/2017/02/13/the-2017-to-2018-gov-uk-roadmap/).

We’ve learnt from the ways we have generated and paid down similar debt previously. As a result, we now try to pay down tech debt alongside regular mission work. All teams share the overarching aims of constantly improving our platform and paying down debt where it builds up.

We’re experimenting across the GOV.UK programme to discover the right balance of support and mission work. Finding and following a [more sustainable cadence](https://insidegovuk.blog.gov.uk/2017/07/24/what-do-we-mean-by-responsible-building/) improves team health and improves the overall quality of the product – features are delivered quicker and the platform is more stable. We’re encouraging all mission teams to think about how best to strike this balance.

## What’s the problem with technical debt?

Technical debt in isolation is fine. Some poorly factored code can be sat in an application doing its job perfectly well and not cause any issues. It only becomes a problem when it gets in the way of delivering improvements to a service. It may increase the support burden on development staff, meaning they spend less time working on improvements for users. It might be too tightly coupled to an existing but loosely related process, making it harder to iterate that process. It might cost too much money to host, perhaps it needs a unique type of server or it uses too much memory.

The point at which technical debt becomes a problem is, like many types of debt, when the cost of servicing that debt becomes too great. When the weekly support work caused by a piece of technical debt costs more than the development time needed to remove it, the decision about when to pay it down becomes quite easy.

The model of servicing financial debt also helps when prioritising the removal of debt. Once a household has fully paid off their expensive credit card bills, only then should they work on getting themselves out of the much cheaper overdraft.

## How can we manage technical debt strategically?

Mission teams on GOV.UK need to have the flexibility to create technical debt in order to deliver the most value. An example might be that we decide not to automate machinery of government changes such as renaming a department, and instead document this as a developer task. This trade-off is fine for processes that happen very infrequently.

When we create debt in this way, we need to understand and track the consequences and costs. In doing so, product managers and technical leads can agree to accept the consequences for a while until a more convenient time.  
In order to have these conversations, we need a common and agreed language to discuss technical debt. We need to rate the consequences and costs, and the programme as a whole needs to know how concerned to be about each piece of debt.

## The process

[The GOV.UK technology team agreed](https://github.com/alphagov/govuk-rfcs/blob/master/rfc-069-classifying-and-measuring-tech-debt.md) on example causes and consequences of technical debt using our [RFC process](https://github.com/alphagov/govuk-rfcs/). We also agreed on some examples of items that we would count as technical debt, and examples of items we wouldn’t count. Some things are too large to be considered as a single piece of debt, while others are too small. In some cases, we make a product decision even when we know it’s not the most efficient option - for example, because it’s better for security. We wouldn’t count something like this as technical debt.

Members of the GOV.UK team can track an item of technical debt by adding a card to a Trello board. This can be either an old piece of debt they’ve just discovered, or something they’re having to leave behind as part of mission work. They write up the cause and consequences of the debt, and assign a high, medium or low rating to the impact of the debt and the effort required to pay it down. Senior technical leads then meet regularly to review these proposed cards. They agree on an overall high, medium or low rating for each card based on the impact and effort ratings, and the current and near-future needs of the programme. This overall rating indicates how concerned the programme should be about the debt.

For example, a piece of debt with a medium-level impact in 6 months time with a low required effort is less of a concern than one that’s causing a support problem right now. Items that have a high rating are assigned to a technical lead to own. They work to either pay it down or reduce the level of concern. This process is similar to that for managing a risk register, so is familiar to less technical people.

## How we’re using the board

As part of GOV.UK’s move to working on [quarterly missions](https://insidegovuk.blog.gov.uk/2017/07/19/new-roadmap-new-ways-of-working/), we have a renewed focus on sustainable delivery. We hope this will ensure we don’t end up with a large backlog of technical debt in the future.

We have a centralised team that supports the entire platform, with developers rotating into on a weekly basis. This team doesn’t just work on support tickets from users. The team prioritises support work something like this:

1.  Keep GOV.UK running
2.  Reduce the support burden
3.  Pay down technical debt

Investing time in points 2 and 3 should maintain or even increase the amount of time available to build things for users in the future.

Feedback about our approach to technical debt has so far been positive. Technical leads especially find it useful when discussing the relative priorities of work with their product managers. It allows teams to more effectively reason about the consequences of their product decisions. Teams report that tracking this way is less stressful - they can simply log tech debt and be confident it will eventually be taken care of.

_This post originally appeared on the [Inside GOV.UK blog](https://insidegovuk.blog.gov.uk/2018/02/19/classifying-and-measuring-tech-debt-in-gov-uk/)_