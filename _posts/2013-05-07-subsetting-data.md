---
id: 1778
title: 'Subsetting data'
date: '2013-05-07T17:12:47+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1778'
permalink: /2013/05/07/subsetting-data/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

At [School](http://www.forestry.ac.nz/) we use R across many courses, because students are supposed to use statistics under a variety of contexts. Imagine their disappointment when they pass stats and discovered that R and statistics haven’t gone away!

When students start working with real data sets one of their first stumbling blocks is subsetting data. We have data sets and either they are required to deal with different subsets or there is data cleaning to do. For some reason, many students struggle with what should be a simple task.

If one thinks of data as as a matrix/2-dimensional array, subsetting boils down to extracting the needed rows (cases) and columns (variables). In the R world one can do this in a variety of ways, ranging from the cryptic to the explicit and clear. For example, let’s assume that we have a dataset called `alltrials` with heights and stem diameters for a number of trees in different trials (We may have a bunch of additional covariates and experimental design features that we’ll ignore for the moment). How do we extract all trees located in Christchurch?

Two common approaches are:

```r
mytrial <- alltrials[alltrials$location == "Christchurch", ]

mytrial <- subset(alltrials, location == "Christchurch")
```

While both expressions are equivalent, the former reads like <a href="http://en.wikipedia.org/wiki/Klingon_language">Klingon</a> to students, while the latter makes explicit that we are obtaining a subset of the original data set. This can easily be expanded to more complex conditions; for example to include all trees from Christchurch that are taller than 10 m:

```r
mytrial <- alltrials[alltrials$location == "Christchurch" & 
                     alltrials$height > 10, ]

mytrial <- subset(alltrials, 
                  location == "Christchurch" & height > 10)
```

I think the complication with the Klingonian notation comes mostly from two sources:

- Variable names for subsetting the data set are not directly accessible, so we have to prefix them with the NameOfDataset$, making the code more difficult to read, particularly if we join several conditions with `&` and `|`.
- Hanging commas: if we are only working with rows or columns we have to acknowledge it by suffixing or prefixing with a comma, which are often forgotten.

Both points result on frustrating error messages like

- `Error in [.data.frame(alltrials, location == "Christchurch", ) : object 'location' not found` for the first point or
- `Error in [.data.frame(alltrials, alltrials$location == "Christchurch") undefined columns selected` for the second point.

The generic forms of these two notations are:

```r
dataset[what to do with rows, what to do with columns]

subset(dataset, what to do with rows, what to do with columns)
```

We often want to keep a subset of the observed cases **and** keep (or drop) specific variables. For example, we want to keep trees in 'Christchurch' and we want to ignore diameter, because the assessor was 'high' that day:

```r
# With this notation things get a bit trickier
# The easiest way is to provide the number of the variable
# Here diameter is the 5th variable in the dataset
mytrial <- alltrials[all.trials$location == "Christchurch" & 
                     all.trials$height > 10, -5]

# This notation is still straightforward
mytrial <- subset(alltrials, 
                  location == "Christchurch" & height > 10, 
                  select = -diameter)
```

There are, however, situations where Klingon is easier or more efficient. For example, to take a random sample of 100 trees from the full dataset:

```r
mytrial <- alltrials[sample(1:nrow(alltrials), 100, replace = FALSE),]
```

If you are interested in this issue <a href="http://www.statmethods.net/management/subset.html">Quick-R</a> has a good description of subsetting. I'm sure this basic topic must has been covered many times, although I doubt anyone used Klingon in the process.

![Gratuitous picture: building blocks for R.](/assets/images/mega-blocks.jpg)