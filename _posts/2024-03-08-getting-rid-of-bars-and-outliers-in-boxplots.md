---
id: 41
title: 'Getting rid of bars and outliers in boxplots'
date: '2024-03-08T14:57:20+13:00'
author: Luis
layout: post
guid: 'https://aleph.apiolaza.net/?p=41'
permalink: /2024/03/08/getting-rid-of-bars-and-outliers-in-boxplots/
tags:
    - aleph
    - programming
---

Sometimes I am testing graphs and I want to get rid of the lines (`coef = 0`) and outliers (`outlier.shape = NA`), particularly if I’m overlapping points.

```r
 geom_boxplot(coef = 0, outlier.shape = NA)
 ```