---
id: 30
title: 'On R versus SAS'
date: '2011-10-07T07:00:24+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=30'
permalink: /2011/10/07/on-r-versus-sas/
classic-editor-remember:
    - classic-editor
    - classic-editor
tags:
    - programming
    - stats
---

A short while ago there was a discussion on [linkedin](http://www.linkedin.com/groups/SAS-versus-R-35222.S.65098787) about the use of `SAS` versus `R` for the enterprise. I have thought a bit about the issue but, as I do not use Linkedin, I did not make any comments there.

**Disclaimer:** I did use `SAS` a lot between 1992 and 1997, mostly for genetic evaluation, heavily relying on `BASE`, `STAT`, `IML` and `GRAPH`. From that point on, I was a light `SAS` user (mostly `STAT` and `IML`) until 2009. The main reason I left `SAS` was that I started using `ASReml` in 1997 and, around two years ago `asreml-R`, the R package version of `ASReml`. Through my job I can access any statistical software; if the university does not have a license, I can buy an academic one without any issues.

I think it is important to make a distinction between enterprise use and huge datasets. Some companies have large datasets, but there probably are many companies that need to analyze large numbers of small to medium size datasets. If we accept this premise, there is room to use a diversity of statistical packages, including both `SAS` and `R`.

Another topic that often appears in the `R` vs. `SAS` discussion is cost. `SAS` licenses are not cheap, but for many large companies the cost of having expensive researchers with lower productivity while they learn another “free” system can be really high. Same issue applies if there are legacy programs: converting software to a new system can be expensive and time consuming. Of course this situation is changing: new graduates are being exposed much more to R than to SAS in many departments. We now [use R in many courses](/2011/10/22/teaching-with-r-the-switch/) and students may end up working in a small company that will be happy not to spend any money to pay for a `SAS` license.

The problem of openness versus closed source is, in my opinion, a bit of a red herring. Most users of statistical software will never have a look at statistical code (think of people driving software with menus). Most users will not be tempted about reading the source code. Most users will not need to recompile the software to make it work in some strange supercomputer. Besides the merits of “feeling good about oneself” for using open software, most users will not worry about losing access to `SAS` software, as the company has been on business for several decades (typical scenario put forward by open source advocates). After making clear the previous few points I should highlight why I choose `R` over `SAS` for both academic and commercial use:

- There is good integration between the programming language and the statistical functions. Both `SAS` macros and `IML` are poorly integrated with the data step and procs.
- `R` is highly conducive to exploratory data analysis; visualization functions (either the `lattice` or the `ggplot2` packages) produce high quality plots that really help developing ideas to build models.
- Statistics is not defined by the software. If someone develops a new methodology or algorithm chances are that there will be an `R` implementation almost immediately. If I want to test a new idea I can scramble to write some code that connects packages developed by other researchers.
- It is relatively easy to integrate `R` with other languages, for example `Python`, to glue a variety of systems.
- `asreml-r`!
- I can exchange ideas with a huge number of people, because slowly `R` is becoming the de facto standard for many disciplines that make use of statistics.

Of course `R` has many drawbacks when compared to `SAS`; for example:

- The default editor in the Windows version is pathetic, while the one in OS X is pasable (code folding and proper refreshing would be great additions).
- `R` syntax can be horribly inconsistent across packages, making the learning process more difficult.
- There are many, too many, ways of doing the same thing, which can be confusing, particularly for newbies. For example, summarizing data by combinations of factors could be done using aggregate, summarize (from `Hmisc`), functions of the apply family, `doBy`, etc. Compare this situation to `proc means`.

No, I did not mention technical support (which I find a non-issue), access to large data sets (it is possible to integrate R with databases and ongoing work to process data that can’t fit in memory) or documentation. Concerning the latter, it would be helpful to have better `R` documentation, but `SAS` would also benefit from better manuals. There has been a huge number of books using `R` published recently and the documentation gap is closing. `R` would benefit of having good **canonical** documentation, something that all users could see first as the default documentation. The documentation included with the system is, how to call it, Spartan, and sometimes plain useless and confusing. A gigantic link to a searchable version of the `R` users email list from the main R project page would be great.