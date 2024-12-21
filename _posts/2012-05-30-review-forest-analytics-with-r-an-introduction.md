---
id: 1114
title: 'Review: &#8220;Forest Analytics with R: an introduction&#8221;'
date: '2012-05-30T15:24:59+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1114'
permalink: /2012/05/30/review-forest-analytics-with-r-an-introduction/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/05/harvesting-eucs.jpg
tags:
    - books
    - stats
---

Forestry is the province of variability. From a spatial point of view this variability ranges from within-tree variation (e.g. modeling wood properties) to billions of trees growing in millions of hectares (e.g. forest inventory). From a temporal point of view we can deal with daily variation in a physiological model to many decades in an empirical growth and yield model. Therefore, it is not surprising that there is a rich tradition of statistical applications to forestry problems.

At the same time, the scope of statistical problems is very diverse. As the saying goes forestry deals with “an ocean of knowledge, but only one centimeter deep”, which is perhaps an elegant way of saying a jack of all trades, master of none. [Forest Analytics with R: an introduction](https://www.librarything.com/work/11378298) by Andrew Robinson and Jeff Hamann (FAWR hereafter) attempts to provide a consistent overview of typical statistical techniques in forestry as they are implemented using the R statistical system.

Following the compulsory introduction to the R language and forest data management concepts, FAWR deals mostly with three themes: sampling and mapping (forest inventory), allometry and model fitting (e.g. diameter distributions, height-diameter equations and growth models), and simulation and optimization (implementing a growth and yield model, and forest estate planning). For each area the book provides a brief overview of the problem, a general description of the statistical issues, and then it uses R to deal with one or more example data sets. Because of this structure, chapters tend to stand on their own and guide the reader towards a standard analysis of the problem, with liberal use of graphics (very useful) and plenty of interspersing code with explanations (which can be visually confusing for some readers).

While the authors bill the book as using “state-of-the-art statistical and data-handling functionality”, the most modern applications are probably the use of non-linear mixed-effects models using a residual maximum likelihood approach. There is no coverage of, for example, Bayesian methodologies increasingly present in the forest biometrics literature.

![Harvesting Eucalyptus urophylla x E. grandis hybrid clones in Brazil.](/assets/images/harvesting-eucs.jpg)

FAWR reminds me of a great but infuriating book by Italo Calvino (1993): “[If on a Winter’s Night a Traveler](https://www.librarything.com/work/4091153)“. Calvino starts many good stories and, once the reader is hooked in them, keeps on moving to a new one. The authors of FAWR acknowledge that they will only introduce the techniques, but a more comprehensive coverage of some topics would be appreciated.

Readers with some experience in the topic may choose to skip the book altogether and move directly to, for example, Pinheiro and Bates (2000) book on [Mixed-Effect Models in S and S-Plus](https://www.librarything.com/work/123713) and Lumley’s (2010) [Complex Surveys: A Guide to Analysis Using R](https://www.librarything.com/work/9710291). FAWR is part of the growing number of “do *X* using R” books that, although useful in the short term, are so highly tied to specific software that one suspects they should come with a best-before date. A relevant question is how much content is left once we drop the software specific parts… perhaps not enough.

The book certainly has redeeming features. For example, Part IV introduces the reader to calling an external function written in C (a growth model), to then combining the results with R functions to create a credible growth and yield forecasting system. Later the authors tackle harvest scheduling through linear programming models, task often addressed using domain-specific (both proprietary and expensive) software. The authors use this part to provide a good case study of model implementation.

At the end of the day I am ambivalent about FAWR. On the one hand, it is possible to find better coverage of most topics in other books or R documentation. On the other, it provides a convenient point of entry if one is lost on how to start working in forest biometrics with R. An additional positive aspect is that the book increases R credibility as an alternative for forest analytics, which makes me wish this book had been around 3 years ago, when I needed to convince colleagues to move our statistics teaching to R.

**P.S.** This review was published with minor changes as “Apiolaza, L.A. 2012. Andrew P. Robinson, Jeff D. Hamann: Forest Analytics With R: An Introduction. Springer, 2011. ISBN 978-1-4419-7761-8. xv+339 pp. Journal of Agricultural, Biological and Environmental Statistics 17(2): 306-307” (DOI: [10.1007/s13253-012-0093-y](http://www.springerlink.com/content/c48633604v8k1r26/)).

P.S.2. 2012-05-31. After publishing this text I discovered that I already used the sentence “\[f\]orestry deals with variability and variability is the province of statistics” in a [blog post](https://luis.apiolaza.net/2011/10/22/teaching-with-r-the-switch/) in 2009.

P.S.3. 2012-05-31. I first heard the saying “forestry deals with an ocean of knowledge, but only one centimeter deep” around 1994 in a presentation by [Oscar García](https://www.researchgate.net/profile/Oscar-Garcia-71) in Valdivia, Chile.
