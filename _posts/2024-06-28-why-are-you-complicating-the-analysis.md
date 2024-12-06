---
id: 5453
title: 'Why are you complicating the analysis?'
date: '2024-06-28T10:25:08+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=5453'
permalink: /2024/06/28/why-are-you-complicating-the-analysis/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2024/06/wood_products.jpeg
tags:
    - breeding
    - linkedin
---

Progeny trials (or progeny testing or genetic tests or whatever you call them) are a real money pit. They are super useful, with many functions(\*) but they are expensive as hell. Their establishment, maintenance and assessment are a constant money sink.

Progeny trials follow an experimental design, through which we try to isolate signal from environmental noise. They also follow a mating design that we keep track of via the pedigree (either through a list of crosses or using marker information). Putting those two designs together starts producing a more complex analysis, which becomes even more complicated as we also include multiple environments, multiple traits, etc.

So, Why am I complicating the analysis? Because I want to squeeze as much value of those bloody expensive trials. Over 25 years ago, 1997 to be precise, I read a very cool article: “Accounting for Natural and Extraneous Variation in the Analysis of Field Experiments” by Arthur Gilmour, Brian Cullis and Arūnas Verbyla (available for free [here](https://www.researchgate.net/publication/280800843_Accounting_for_Natural_and_Extraneous_Variation_in_the_Analysis_of_Field_Experiments)). It is a beautiful example of model building AND value extraction from a single trial. What is the point of leaving money on the table (or genetic signal in the trial)? None.

These days there are multiple options for statistical software for running those “complex” analyses. I use ASReml-R, you may use something else. There are diminishing returns, there are simplifications that are a good idea, but please, keep on polishing those analyses.

(\*) That’s another post, of course.[  ](https://www.linkedin.com/feed/hashtag/?keywords=breeding&highlightedUpdateUrns=urn%3Ali%3Aactivity%3A7212333150008422401)

![Wood panels with different degrees of complexity.](/assets/images/wood_products.jpeg)