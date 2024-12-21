---
id: 1032
title: 'Teaching code, production code, benchmarks and new languages'
date: '2012-04-30T21:36:54+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1032'
permalink: /2012/04/30/teaching-code-production-code-benchmarks-and-new-languages/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/04/uppsala-train-station.jpg
tags:
    - programming
    - stats
---

I’m a bit obsessive with words. May be I should have used *learning* in the title, rather than *teaching* code. Or perhaps *remembering* code. You know? Code where one actually has very clear idea of what is going on; for example, let’s say that we are calculating the average of a bunch of n numbers, we can have a loop that will add up each of them and then divide the total by n. Of course we wouldn’t do that in R, but use a simple function: `mean(x)`.

In a [previous post](/2012/04/25/r-julia-and-genome-wide-selection/) I compared R and Julia code and one of the commenters (Andrés) rightly pointed out that the code was inefficient. It was possible to speed up the calculation many times (and he sent me the code to back it up), because we could reuse intermediate results, generate batches of random numbers, etc. However, if you have studied the genomic selection problem, the implementations in my post are a lot closer to the algorithm. It is easier to follow and to compare, but not too flash in the speed department; for the latter we’d move to production code, highly optimized but not very similar to the original explanation.

This reminded me of the controversial Julia benchmarks, which implemented a series of 7 toy problems in a number of languages, following the ‘teaching code’ approach. Forcing ‘teaching code’ makes the comparison simple, as different language implementations look similar to each other. However, one is also throwing away the very thing that makes languages different: they have been designed and optimized using different typical uses in mind. For example, execution time for the [pisum benchmark](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.R) can be reduced sixty times just by replacing the internal loop with `sum(1/c(1:10000)^2)`. Making comparisons easily understandable (so the code looks very similar) is orthogonal to making them realistic.

![Gratuitous picture: looking for the right bicycle in Uppsala.](/assets/images/uppsala-train-station.jpg)

Someone asked, tongue in cheek, ‘The Best Statistical Programming Language is …Javascript?’ Well, if you define best as fastest language running seven benchmarks that may bear some resemblance to what you’d like to do (despite not having any statistical libraries) maybe the answer is yes.

I have to admit that I’m a sucker for languages; I like to understand new ways of expressing problems and, some times, one is lucky and finds languages that even allow tackling new problems. At the same time, most of my tests never progress beyond the ‘ah, cool, but it isn’t really *that* interesting’. So, if you are going to design a new language for statistical analyses you may want to:

- Piggyback on another language. Case in point: R, which is far from an immaculate conception but an implementation of S, which gave it a start with both users and code. It may be that you extend a more general language (e.g. Incanter) rather than a domain specific one.
- However, one needs a clean syntax from the beginning (ah, Python); my theory is that this partly explains why [Incanter](https://github.com/incanter/incanter) got little traction. (((too-many-parentheses-are-annoying)))
- Related to the previous point, make extensibility to other languages very simple. R’s is a pain, while Julia’s seems to be much straightforward (judging by [Douglas Bates’s examples](http://dmbates.blogspot.com/2012/03/julia-functions-for-rmath-library.html)).
- Indices start at 1, not 0. Come on! This is stats and maths, not computer science. It is easier for us, your audience, to count from 1.
- Programming structures are first class citizens, not half-assed constructs that complicate life. A clear counterexample are SAS’s macros and PROC IML, which are not conducive to people writing their own libraries/modules and sharing them with the community: they are poorly integrated with the rest of the SAS system.
- Rely since day one on creating a community; as I pointed out in a previous post [one thing is having a cool base language but a different one is recreating R’s package ecosystem](/2012/04/12/r-julia-and-the-shiny-new-thing/). Good luck recreating R’s ecosystem working on your own.
- However, you have to create a base language with sane basics included: access to both plain text and databases, easy summary functions (`Xapply` doesn’t cut it), glms and cool graphics (ggplot like) or people may not get hooked with the language, so they start contributing.
 
Two interesting resources discussing the adoption of R are [this paper](http://journal.r-project.org/archive/2009-2/RJournal_2009-2_Fox.pdf) (PDF) by John Fox and [this presentation](https://web.archive.org/web/20120630054147/http://channel9.msdn.com/Events/Lang-NEXT/Lang-NEXT-2012/Why-and-How-People-Use-R?format=html5) by John Cook. Incidentally, John Fox is the author of [my favorite book](https://www.librarything.com/work/17039923) on regression and generalized linear models, no R code at all, just explanations and the math behind it all. John Cook writes [The Endeavour](http://www.johndcook.com/blog/), a very interesting blog with mathematical/programming bent.