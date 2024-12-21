---
id: 937
title: 'R, Julia and the shiny new thing'
date: '2012-04-12T22:51:13+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=937'
permalink: /2012/04/12/r-julia-and-the-shiny-new-thing/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/04/cabbage-trees.jpg
tags:
    - programming
---

My head exploded a while ago. Perhaps not my head but my brain was all mushy after working every day of March and first week of April; an explanation—as good as any—for the post hiatus. Back to the post title.

It is not a mystery that for a while there has been some underlying unhappiness in the R world. [Ross Ihaka](http://www.stat.auckland.ac.nz/~ihaka/) and [Duncan Temple Long](http://www.stat.ucdavis.edu/~duncan/) have [mused on starting over](http://www.stat.auckland.ac.nz/~ihaka/downloads/Compstat-2008.pdf) (PDF, 2008). Similar comments were voiced by Ihaka in [Christian Robert’s](http://xianblog.wordpress.com/2010/09/13/simply-start-over-and-build-something-better/) blog (2010) and were probably at the root of the development of [Incanter](http://incanter.org/) (based on Clojure). Vince Buffalo pointed out the growing pains of R but it was a realist on his [post about Julia](http://vincebuffalo.org/2012/03/07/thoughts-on-julia.html): one thing is having a cool base language but a different one is recreating R’s package ecosystem<sup>†</sup>.

A quick look in R-bloggers will show [several](http://www.johnmyleswhite.com/notebook/2012/04/09/comparing-julia-and-rs-vocabularies/) [posts](http://dmbates.blogspot.com/2012/04/r-programmer-looks-at-julia.html) [mentioning](http://www.johnmyleswhite.com/notebook/2012/04/04/simulated-annealing-in-julia/) [Julia](http://julialang.org/), including A-listers (in the R world, forget Hollywood) like [Douglas Bates](http://dmbates.blogspot.com) (of nlme and lme4 fame). They are not alone, as many of us (myself included) are prone to suffer the ‘oh, new, shiny’ syndrome. We are always looking for that new <span style="text-decoration: line-through;">car</span> language smell, which promises to deliver `c('consistency', 'elegance', 'maintainability', 'speed', ...)`; each of us is looking for a different mix and order of requirements.

Personally, I do not find R particularly slow. Put another way, I tend to struggle with a particular family of problems (multivariate linear mixed models) that require heavy use of external libraries written in C or FORTRAN. Whatever language I use will call these libraries, so I may not stand to gain a lot from using *insert shiny language name here*. I doubt that one would gain much with parallelization in this class of problems (but I stand to be corrected). This does not mean that I would not consider a change.

Give me consistency + elegance and you start getting my attention. What do I mean? I have been reading a book on *‘Doing X with R’* so I can write [a review about it](/2012/05/30/review-forest-analytics-with-r-an-introduction). This involved looking at the book with newbie eyes and, presto!, R can be a real eyesore and the notation can drive you insane sometimes. At about the same time Vince Buffalo was posting his thoughts on Julia (early March) [I wrote](/2012/03/08/early-march-flotsam/):

> The success of some of Hadley Wickham’s packages got me thinking about underlying design issues in R that make functions so hard to master for users. Don’t get me wrong, I still think that R is great, but why are there so many problems to understand part of the core functionality? A quick web search will highlight that there is, for example, an incredible amount of confusion on how to use the apply family of functions. The management of dates and strings is also a sore point. I perfectly understand the need for, and even the desirability of, having new packages that extend the functionality of R. However, this is another kettle of fish; we are talking about making sane design choices so there is no need to repackage basic functionality to make it usable.

May be the question is not as dramatic as Do we need a new, shiny language? but Can we get rid of the cruft that R has accumulated over the years? Can we make the language more consistent, easier to learn, write and maintain?

![Cabbage trees or mushy brain?](/assets/images/cabbage-trees.jpg)

Some may argue that one could get away with implementing the 20% of the functionality that’s used by 80% of the users. Joel Spolsky already [discussed the failure](http://www.joelonsoftware.com/articles/fog0000000020.html) of this approach in 2001.