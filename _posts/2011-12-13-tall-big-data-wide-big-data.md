---
id: 531
title: 'Tall big data, wide big data'
date: '2011-12-13T02:00:36+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=531'
permalink: /2011/12/13/tall-big-data-wide-big-data/
classic-editor-remember:
    - block-editor
    - block-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2011/12/LaurelAndHardy.jpg
tags:
    - bayesian
    - stats
---

After attending two one-day workshops last week I spent most days paying attention to (well, at least listening to) presentations in [this biostatistics conference](https://web.archive.org/web/20111117102415/http://www.biometrics.org.au/conferences/kiama2011/index.html). Most presenters were R users—although Genstat, Matlab and SAS fans were also present and not once I heard “I can’t deal with the current size of my data sets”. However, there were some complaints about the speed of R, particularly when dealing with simulations or some genomic analyses.

Some people worried about the size of coming datasets; nevertheless that worry was **across** statistical packages or, more precisely, it went beyond statistical software. How will we able to even store the data from something like the [Square Kilometer Array](http://en.wikipedia.org/wiki/Square_Kilometre_Array), let alone analyze it?

![Laurel and Hardy.](/assets/images/laurel-and-hardy.jpg)

In a [previous post](/2011/11/22/do-we-need-to-deal-with-big-data-in-r/) I was asking if we needed to actually deal with ‘big data’ in R, and my answer was probably not or, better, at least not directly. I still think that it is a valid, although incomplete opinion. In many statistical analyses we can think of n (the number of observations) and p (the number of variables per observation). In most cases, particularly when people refer to big data, n &gt;&gt; p. Thus, we may have 100 million people but we have only 10 potential predictors: tall data. In contrast, we may have only 1,000 individuals but with 50,000 points each coming from a near infrared spectrometry or information from 250,000 SNPs (a type of molecular marker): wide data. Both types of data will keep on growing but are challenging in a different way.

In a totally generalizing, unfair and simplistic way I will state that dealing with wide is more difficult (and potentially interesting) than dealing with tall. This from a modeling perspective. As the t-shirt says: *"sampling is not a crime"*, and it should work quite well with simpler models and large datasets. In contrast, sampling to fitting wide data may not work at all.

Algorithms. Clever algorithms is what we need in a first stage. For example, we can fit linear mixed models to a tall dataset with ten millions records or a multivariate mixed model with 60 responses using ASReml-R. Wide datasets are often approached using Bayesian inference, but MCMC gets slooow when dealing with thousands of predictors, we need other **fast** approximations to the posterior distributions.

This post may not be totally coherent, but it keeps the conversation going. My excuse? I was watching [Be kind rewind](http://www.imdb.com/title/tt0799934/) while writing it.