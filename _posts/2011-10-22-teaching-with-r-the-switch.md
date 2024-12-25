---
id: 291
title: 'Teaching with R: the switch'
date: '2011-10-22T07:00:50+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=291'
permalink: /2011/10/22/teaching-with-r-the-switch/
classic-editor-remember:
    - block-editor
    - block-editor
tags:
    - stats
---

There are several blog posts, websites (and even books) explaining the transition from using another statistical system (e.g. `SAS`, `SPSS`, `Stata`, etc) to relying on `R`. Most of that material treats the topic from the point of view of i- an individual user and ii- a researcher. This post explains some of the issues involved in, first, moving several users and, second, with an emphasis in teaching.

I have made part of this information available before, but I wanted to update it and keep it together with all the other posts in Quantum Forest. The process started in March 2009.

## March 2009

I started explaining to colleagues my position on using `R` (and `R commander`) for teaching purposes. Some background first: forestry deals with variability and variability is the province of statistics. The use of statistics permeates forestry: we use sampling for inventory purposes, we use all sort of complex linear and non-linear regression models to predict growth, linear mixed models are the bread and butter of the analysis of experiments, etc.

I think it is fair to expect foresters to be at least acquainted with basic statistical tools, and we have two courses covering ANOVA and regression. In addition, we are supposed to introduce/reinforce statistical concepts in several other courses. So far so good, until we reached the issue of software.

During the first year of study, it is common to use `MS Excel`. I am not a big fan of `Excel`, but I can tolerate its use: people do not require much training to (ab)use it and it has a role to introduce students to some of the ’serious/useful’ functions of a computer; that is, beyond gaming. However, one can hit `Excel` limits fairly quickly which–together with the lack of audit trail for the analyses and the need to repeat all the pointing and clicking every time we need an analysis–makes looking for more robust tools very important.

Until the end of 2009 `SAS` (mostly `BASE` and `STAT`, with some sprinkles of `GRAPH`) was our robust tool. `SAS` was introduced in second year during the ANOVA and regression courses. `SAS` is a fine product, however:

- We spent a very long time explaining how to write simple `SAS` scripts. Students forgot the syntax very quickly.
- `SAS’s` graphical capabilities are fairly ordinary and not at all conducive to exploratory data analysis.
- `SAS` is extremely expensive.
- `SAS` tends to define the subject; I mean, it adopts new techniques very slowly, so there is the tendency to do only what `SAS` can do. This is unimportant for undergrads, but it is relevant for postgrads.
- Users sometimes store data in `SAS`’s own format, which introduces another source of lock-in.

At the time, in my research work I used mostly `ASReml` (for specialized genetic analyses) and R (for general work); since thenI have moved towards using `asreml-R` (an R library that interfaces `ASReml`) to have a consistent work environment. For teaching I was using `SAS` to be consistent with second-year material.

Considering the previously mentioned barriers for students I started playing with [R-commander](https://cran.r-project.org/web/packages/Rcmdr/index.html) (Rcmdr), a cross-platform GUI for R created by John Fox (the writer of some very nice [statistics books](https://www.librarything.com/work/17039923), by the way. As I see it:

- `R` in command mode **is not more difficult** (but not simpler either) for students than `SAS`. I think that `SAS` is more consistent and they have worked hard at keeping a very similar structure between PROCs.
- We can get `R-commander` to start working right away with simple(r) methods, while maintaining the possibility of moving to more complex methods later by typing commands or programming.
- It is free, so our students can load it into their laptops and keep on using it when they are gone. This is particularly true with international students: many of them will never see `SAS` again in their home countries.
- It allows an easy path to data exploration (pre-requisite for building decent models) and high quality graphs.
- `R` is open source (nice, but not a deal breaker for me) and easily extensible (this one is really important for me).

At the time I thought that `R` would be an excellent fit for teaching; nevertheless, there could be a few drawbacks, mostly when dealing with postgrads:

- There are restrictions to the size of datasets (they have to fit in memory), although there are ways to deal with some of the restrictions. On the other hand, I have hit the limits of `PROC GLM` and `PROC MIXED` before and that is where `ASReml` shines. **In two years this has never been a problem.**
- Some people have an investment in `SAS` and may not like the idea of using a different software. This was a problem the first few months.

As someone put it many years ago–there is always resistance to change:

> It must be remembered that there is nothing more difficult to plan, more doubtful of success, nor more dangerous to manage, than the creation of a new system. For the initiator has the enmity of all who would profit by the preservation of the old institutions and merely lukewarm defenders in those who would gain by the new ones.—Niccolò Machiavelli, [The Prince, Chapter 6](http://it.wikisource.org/wiki/Il_Principe/Capitolo_VI)

## Five months later: August 2009

At the department level, I had to spend substantial time compiling information to prove that R could satisfy my colleagues’ statistical needs. Good selling points were `nlme/lme4`, `lattice/ggplot2` and pointing my most statistically inclined colleagues to `CRAN`. Another important issue was the ability to have a GUI (`Rcmdr`) that could be adapted to our specific needs. At that time the School of Forestry adopted `R` as the default software for teaching any statistical content during the four years of the curriculum.

At the university level, my questions to the department of Mathematics and Statistics sparkled a lot of internal discussion, which resulted in `R` being adopted as the standard software for the ANOVA and regression second year courses (it was already the standard for many courses in 3rd and 4th year). The decision was not unanimous, particularly because for statisticians `SAS` is one of those ‘must be in the CV’ skills, but they went for change. The second year courses are offered across colleges, which makes the change very far reaching. These changes implied that many computers in the university labs now come with R pre-installed.

## A year later: April 2010

R and R-commander were installed in our computer labs and we started using them in our Research Methods course. It is still too early to see what will be the effect of R versus SAS, but we expect to see an increase on the application of statistics within our curriculum.

> One thing that I did not properly consider in the process were the annoying side-effects of the university’s computer policies. Students are not allowed to install software in the university computers and R packages fall within that category. We can either stay with the defaults + R commander (our current position) or introduce an additional complication for students, pushing them to define their own library location. I’d rather teach `ggplot2` than lattice, but `ggplot2` is an extra installation. Choices, choices… On the positive side, the default installation for **some** of the computer labs install all the packages by default.

## Two years later: March 2011

Comments after teaching a regression modeling course using `R-commander`:

- Some students really appreciate the possibility of using `R-commander` as their ‘total analysis system’. Most students that have never used a command line environment prefer it.
- Students that have some experience with command-line work do not like much `R-commander` as they find it confusing, particularly when it is possible to access the R console through two points: `Rcmdr` and the default console. Some of them could not see the point of using an environment with a limited subset of functionality.
- Data transformation facilities in `R-commander` are somewhat limited to the simplest cases.
- Why is that the linear regression item does not accept categorical predictors? That works under ‘linear models’, but it is such an arbitrary separation.
- The OS X version of `R-commander` (under X Windows) is butt ugly. This is not John Fox’s fault, but just a fact of life.

In general, R would benefit of having a first-class Excel import system that worked across platforms. Yes, I know that [some people](http://cran.r-project.org/doc/manuals/R-data.html#Reading-Excel-spreadsheets) say that researchers should not use Excel; however, there is a distinction between normative and positive approaches to research. People do use Excel and insisting that they should not is not helpful.

**I would love to hear anyone else’s experiences teaching basic statistics with R. Any comments?**