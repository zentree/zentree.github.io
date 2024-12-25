---
id: 3601
title: 'R pitfall #1: check data structure'
date: '2011-10-05T07:00:04+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=11'
permalink: /2011/10/05/r-pitfall-1-check-data-structure/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

A common problem when running a simple (or not so simple) analysis is forgetting that the levels of a factor has been coded using integers. R doesn’t know that this variable is supposed to be a factor and when fitting, for example, something as simple as a one-way anova (using `lm()`) the variable will be used as a covariate rather than as a factor.

There is a series of steps that I follow to make sure that I am using the right variables (and types) when running a series of analyses. I **always** define the working directory (using `setwd()`), so I know where the files that I am reading from and writing to are.

After reading a dataset I will have a look at the first and last few observations (using `head()` and `tail()`, which by default show 6 observations). This gives you an idea of how the dataset looks like, but it doesn’t confirm the structure (for example, which variables are factors). The function `str()` provides a good overview of variable types and together with `summary()` one gets an idea of ranges, numbers of observations and missing values.

```r
# Define your working directory (folder). This will make
# your life easier. An example in OS X:
setwd('~/Documents/apophenia')

# and one for a Windows machine
setwd('c:/Documents/apophenia')

# Read the data
apo <- read.csv('apophenia-example.csv', 
                header = TRUE)

# Have a look at the first few and last 
# few observations
head(apo)
tail(apo)

# Check the structure of the data (which variables 
# are numeric, which ones are factors, etc)
str(apo)

# Obtain a summary for each of the variables 
# in the dataset
summary(apo)
```

This code should help you avoid the 'fitting factors as covariates' pitfall; anyway, always check the degrees of freedom of the `ANOVA` table just in case.