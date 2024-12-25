---
id: 39
title: 'All combinations for levelplot'
date: '2011-10-08T07:00:26+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=39'
permalink: /2011/10/08/all-combinations-for-levelplot/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2011/10/stiffness_levelplot.jpg
tags:
    - programming
---

In a [previous post](/2011/10/04/all-combinations-of-levels-for-two-factors/ "All combinations of levels for two factors") I explained how to create all possible combinations of the levels of two factors using `expand.grid()`. Another use for this function is to create a regular grid for two variables to create a levelplot or a contour plot.

For example, let’s say that we have fitted a multiple linear regression to predict wood stiffness (stiff, the response) using basic density (bd) and a measure of microfibril angle (t) as explanatory variables. The regression equation could be something like `stiffness = 3.439 + 0.009 bd - 0.052 t`. In our dataset bd had a range of 300 to 700 kg m<sup>-3</sup>, while t had a range from 50 to 70.

We will use the `levelplot()` function that is part of the `lattice` package of graphical functions, create a grid for both explanatory variables (every 10 for bd and every 1 for t), predict values of stiffness for all combinations of bd and t, and plot the results.

```r
library(lattice)

# Create grid of data
wood <- expand.grid(bd = seq(300, 700, 10), 
                    t = seq(50, 70, 1))

wood <- with(wood, 
             stiffness <- 3.439 + 0.009*bd - 0.052*t)

levelplot(stiffness ~ bd*t, data = wood,
          xlab='Basic density', ylab='T')
```

This code creates a graph like this. Simple.

![Stiffness for combinations of basic density and microfibril angle.](/assets/images/stiffness-levelplot.jpg)

