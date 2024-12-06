---
id: 5486
title: 'When heritability is high but the phenotype is dominated by the environment'
date: '2024-08-23T19:03:59+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=5486'
permalink: /2024/08/23/when-heritability-is-high-but-the-phenotype-is-dominated-by-the-environment/
classic-editor-remember:
    - block-editor
cybocfi_hide_featured_image:
    - 'yes'
footnotes:
    - ''
image: /wp-content/uploads/2024/08/heritability_vs_environment.png
tags:
    - breeding
    - linkedin
---

I was reading a [LinkedIn post](https://lnkd.in/e_9wUAQw) that said “heritability is the extent to which differences in observed phenotypes can be attributed to genetic differences”.

There is this idea floating around assuming that if a trait is highly heritable, therefore genetics explains most differences we observe. I have seen it many times, both when people discuss breeding and even in political discussions. I vividly remember a think tank commentator stating that given IQ was highly heritable it is likely that millionaires make more money because their parents were more intelligent, or something along those lines.

I created the figure below using a dataset with wood basic density measurements (how much solid “stuff” you have in a set volume of wood) for trees growing in 17 different environments. The heritability of wood density is around 0.6; however, the differences between some environments are larger than the differences within environments.

We have to remember that heritabilities apply to specific populations and specific environments. Moreover, if we think of the mixed model analysis, we are fitting both fixed and random effects, so we are “correcting/controlling/putting individuals on the same footing” with our fixed effects, before having a look at the variation that is left over. We are then saying that **out of that left over** genetics explains a proportion of the variation (this is much smaller than the variation before accounting for other sources of variability).

In the case of wood density of radiata pine, the environment (particularly temperature explained by latitude and elevation and soil nutrients like boron) has a larger effect than genetics when looking across multiple trials. The trials with higher density are farther North in New Zealand, which is warmer. Once we are inside one of the trials, genetics explains 60% of the variability. In the same way, once we account for all other social differences, we are left with a **much smaller** level of variability to try explaining income differences with genetics.

![Wood variability for trees in 17 progeny trials in New Zealand.](/assets/images/heritability_vs_environment.png)