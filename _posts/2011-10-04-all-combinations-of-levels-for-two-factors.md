---
id: 3600
title: 'All combinations of levels for two factors'
date: '2011-10-04T21:33:45+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=9'
permalink: /2011/10/04/all-combinations-of-levels-for-two-factors/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
---

There are circumstances when one wants to generate all possible combinations of levels for two factors. For example, factor one with levels ‘A’, ‘B’ and ‘C’, and factor two with levels ‘D’, ‘E’, ‘F’. The function `expand.grid()` comes very handy here:

```r
combo <- expand.grid(factor1 = LETTERS[1:3], 
                     factor2 = LETTERS[4:6])
combo

factor1 factor2
1       A       D
2       B       D
3       C       D
4       A       E
5       B       E
6       C       E
7       A       F
8       B       F
9       C       F
```

Omitting the variable names (factor1 and factor 2) will automatically name the variables as `Var1` and `Var2`. Of course we do not have to use letters for the factor levels; if you have defined a couple of factors (say Fertilizer and Irrigation) you can use `levels(Fertilizer)` and `levels(Irrigation)` instead of LETTERS&hellip;