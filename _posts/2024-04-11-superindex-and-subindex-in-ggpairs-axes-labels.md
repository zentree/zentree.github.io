---
id: 80
title: 'Superindex and subindex in ggpairs axes labels'
date: '2024-04-11T21:49:21+13:00'
author: Luis
layout: post
guid: 'https://aleph.apiolaza.net/?p=80'
permalink: /2024/04/11/superindex-and-subindex-in-ggpairs-axes-labels/
tags:
    - aleph
    - programming
    - stats
---

I was having problems on the syntax to get the axis labels with subindices and superindices, as it didn’t work as in ggplot2. The trick was to use a single `expression()` and specifying `labeller  = label_parsed)`

Example:

```r
resin_bv |> 
  ggpairs(columns = c("canal_size_bv", "canal_area_bv", "canal_density_bv"),
          columnLabels = c("Canal~size~(mm^2)", "Canal~area~('%')", "Canal~density~(n~cm^{-2})"),
          upper = "blank",
          labeller  = label_parsed) +
  theme_bw(base_size = 14)
```