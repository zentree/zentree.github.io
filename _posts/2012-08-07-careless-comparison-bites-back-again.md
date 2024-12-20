---
id: 1214
title: 'Careless comparison bites back (again)'
date: '2012-08-07T12:41:05+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1214'
permalink: /2012/08/07/careless-comparison-bites-back-again/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/08/treesinsquare2.jpg
tags:
    - programming
    - stats
---

When running stats labs I like to allocate a slightly different subset of data to each student, which acts as an incentive for people to do their own work (rather than copying the same results from a fellow student). We also need to be able to replicate the results when marking, so we need a record of exactly which observations were dropped to create a particular data set. I have done this in a variety of ways, but this time I opted for code that looked like:

```r
setwd('~/Dropbox/teaching/stat202-2012')

biom <- read.csv('biom2012.csv', header = TRUE)
drops <- read.csv('lab4-dels.csv', header = TRUE)

# Use here your OWN student code
my.drop <- subset(drops, student.code == 'mjl159')
my.data <- subset(biom, !(id %in% my.drop))
```

Thus, we were reading a full data set and assigning it to `biom`, reading a table that contained student codes in the first column and 5 columns with observations to be dropped (assigned to `drops`) and choosing one row of `drops` depending on the student code (assigned to `my.drop`). As an example, for student 'mjl159' `my.drop` looked like:

```
my.drop
#   student.code X1 X2 X3 X4 X5
#40       mjl159 21 18 30 15 43
```

The problem with the code is the comparison `!(id %in% my.drop)`, as it includes the factor `student.code`, so when R makes the comparison checking if a record is in my.drop it converts the text, e.g. ‘mjl159’, to the number of level, e.g. 41, which makes the code to delete ONE MORE observation (in this #41) on top of the ones the student was allocated. This happens only for some students, where the number of level is not included in the list of observations to drop.

This is another version of [R pitfall #3: friggin’ factors](/2011/12/r-pitfall-3-friggin-factors/). A simple workaround is to change the comparison to `!(id %in% my.drop[2:6])`. I should know better than this.

![Gratuitous image: Tree spread on metal frame to provide shade in a plaza, Lisbon, Portugal. Some days I would love to have a coffee there without computer, just watching the world pass by.](/assets/images/treesinsquare2.jpg)
