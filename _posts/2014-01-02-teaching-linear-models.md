---
id: 1831
title: 'Teaching linear models'
date: '2014-01-02T21:58:13+13:00'
mathjax: true
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1831'
permalink: /2014/01/02/teaching-linear-models/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2014/01/20131026103715-scaled.jpg
tags:
    - stats
---

I teach several courses every year and the most difficult to pull off is FORE224/STAT202: regression modeling.

The academic promotion application form in my university includes a section on one’s ‘teaching philosophy’. I struggle with that part because I suspect I lack anything as grandiose as a philosophy when teaching: as most university lecturers I never studied teaching, although I try to do my best. If anything, I can say that I enjoy teaching and helping students to ‘get it’ and that I want to instill a sense of ‘statistics is fun’ in them. I spend quite a bit of time looking for memorable examples, linking to stats in the news ([statschat](http://www.statschat.org.nz/) and [listening the news](http://www.radionz.co.nz/national) while walking my dog are very helpful here) and collecting data. But a philosophy? Don’t think so.

One of the hardest parts of the course is the diversity of student backgrounds. Hitting the right level, the right tone is very hard. Make it too easy and the 1/5 to 1/4 of students with a good mathematical background will hate it; they may even decide to abandon any intention of continuing doing stats if ‘that’s all there is about the topic’. Make it too complicated and half the class will fail and/or hate the content.

Part of the problem is based around what we mean by teaching ‘statistics’. In some cases it seems limited to what specific software does; for example, teaching with Excel means restriction to whatever models are covered in Excel’s Data Analysis Toolpak (DAT). The next choice when teaching is using menu-driven software (e.g. SPSS), which provides much more statistical functionality than Excel + DAT, at the expense of being further removed from common usability conventions. At the other extreme of simplicity is software that requires coding to control the analyses (e.g. R or SAS). In general, the more control we want, the more we have to learn to achieve it<sup>†</sup>.

A while ago [I made a distinction](/2011/11/teaching-with-r-the-tools/) between the different levels of learning (user cases) when teaching statistics. In summary, we had i- very few students getting in to statistics and heavy duty coding, ii- a slightly larger group that will use stats while in a while and iii- the majority that will mostly consume statistics. I feel a duty towards the three groups, while admitting that I have predilection for the first one. Nevertheless, the third group provides most of the challenges and need for thinking about how to teach the subject.

When teaching linear models (general form $$y = X \beta + \epsilon$$) we tend to compartmentalize content: we have an ANOVA course if the design matrix $$X$$ represents categorical predictors (contains only 1s and 0s), a regression course if $$X$$ is full of continuous predictors and we talk about ANCOVA or regression on dummy variables if $$X$$ is a combination of both. The use of different functions for different contents of $$X$$ (for example `aov()` versus `lm()` in R or `proc reg` versus `proc glm` in SAS) further consolidates the distinction. Even when using menus, software tends to guide students through different submenus depending on the type of $$X$$.

![Gliding in a hierarchy of models.](/assets/images/glide.jpeg)

At the beginning of the course we restrict ourselves to $$X$$ full of continuous predictors, but we introduce the notion of matrices with small examples. This permits showing the connection between all the linear model courses (because [a rose by any other name…](https://en.wikipedia.org/wiki/A_rose_by_any_other_name_would_smell_as_sweet)) and it also allows deriving a general expression of the formulas for the regression coefficients (essential for the most advanced students). Slower students may struggle with some of this material; however, working with small examples they can replicate the results from R (or Excel or SAS or whatever one uses to teach). Some times they even think it is cool.

Here is where the `model.matrix()` [R function](http://stat.ethz.ch/R-manual/R-devel/library/stats/html/model.matrix.html) becomes handy; rather than building incidence matrices by hand—which is easy for tiny examples—we can get the matrices used by the `lm()` function to then calculate regression parameters (and any other output) for more complex models.

Once students get the idea that on matrix terms our teaching compartments are pretty much the same, we can reinforce the idea by using a single function (or `proc`) to show that we can obtain all the bits and pieces that make up what we call ‘fitting the model’. This highlights the idea that ANOVA, ANCOVA &amp; regression are subsets of linear models, which are subsets of linear mixed models, which are subsets of generalized linear mixed models. A statistical Russian doll.

We want students to understand, some times so badly that we lower the bar to a point where there is no much to understand. Here is the tricky part, finding the right level of detail so all types of students learn to enjoy the topic, although at different levels of understanding.

<sup>†</sup>There is software that generates code from menus too, like Stata or Genstat.

P.S. This is part of my thinking aloud with hesitation about teaching, as in [Statistics unplugged](/2013/12/statistics-unplugged/), [Excel, fanaticism and R](/2013/12/excel-fanaticism-and-r/), [Split-plot 1: How does a linear mixed model look like?](/2012/06/split-plot-1-how-does-a-linear-mixed-model-look-like/), [R, academia and the democratization of statistics](/2011/12/r-academia-and-the-democratization-of-statistics/), [Mid-January flotsam: teaching edition](/2012/01/mid-january-flotsam-teaching-edition/) &amp; [Teaching with R: the switch](/2011/10/teaching-with-r-the-switch/). I am always looking for better ways of transferring knowledge.