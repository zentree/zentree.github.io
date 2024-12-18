---
id: 1539
title: 'When R, or any other language, is not enough'
date: '2012-12-15T01:10:03+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1539'
permalink: /2012/12/15/when-r-or-any-other-language-is-not-enough/
classic-editor-remember:
    - block-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/12/harewood.jpg
tags:
    - research
    - stats
---

This post is tangential to R, although R has a fair share of the issues I mention here, which include research reproducibility, open source, paying for software, multiple languages, salt and pepper.

There is an increasing interest in the reproducibility of research. In many topics we face multiple, often conflicting claims and as researchers we value the ability to evaluate those claims, including repeating/reproducing research results. While I share the interest in reproducibility, some times I feel we are obsessing too much on only part of the research process: statistical analysis. Even here, many people focus not on the models per se, but only on the code for the analysis, which should only use tools that are free of charge.

There has been enormous progress in the R world on [literate programming](http://en.wikipedia.org/wiki/Literate_programming), where the combination of RStudio + Markdown + knitr has made analyzing data and documenting the process almost enjoyable. Nevertheless, and here is the BUT coming, there is a large difference between making the *code* repeatable and making *research* reproducible.

As an example, currently I am working in a project that relies on two trials, which have taken a decade to grow. We took a few hundred increment cores from a sample of trees and processed them using a densitometer, an X-Ray diffractometer and a few other lab toys. By now you get the idea, actually *replicating* the research may take you quite a few resources before you even start to play with free software. At that point, of course, I want to be able to get the most of my data, which means that I won’t settle for a half-assed model because the software is not able to fit it. If you think about it, spending a couple of grands in software (say ASReml and Mathematica licenses) doesn’t sound outrageous at all. Furthermore, reproducing this piece of research would require: a decade, access to genetic material and lab toys. I’ll give you the code for free, but I can’t give you ten years or $0.25 million…

In addition, the research process may require linking disparate sources of data for which other languages (e.g. Python) may be more appropriate. Some times R is the perfect tool for the job, while other times I feel like we have reached peak VBS (Visual Basic Syndrome) in R: people want to use it for everything, even when it’s a bad idea.

In summary,

- research is much more than a few lines of R (although they are very important),
- even when considering data collection and analysis it is a good idea to know more than a single language/software, because it broadens analytical options
- I prefer free (freedom + beer) software for research; however, I rely on non-free, commercial software for part of my work because it happens to be the best option for specific analyses.

**Disclaimer:** my primary analysis language is R and I often use lme4, MCMCglmm and INLA (all free). However, many (if not most) of my analyses that use genetic information rely on ASReml (paid, not open source). I’ve used Mathematica, Matlab, Stata and SAS for specific applications with reasonably priced academic licenses.

![Gratuitous picture: 3000 trees leaning in a foggy Christchurch day.](/assets/images/harewood.jpg)

