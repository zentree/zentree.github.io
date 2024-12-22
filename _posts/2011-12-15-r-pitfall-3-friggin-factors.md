---
id: 579
title: 'R pitfall #3: friggin&#8217; factors'
date: '2011-12-15T22:11:09+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=579'
permalink: /2011/12/15/r-pitfall-3-friggin-factors/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - stats
---

I received an email from one of my students expressing deep frustration with a seemingly simple problem. He had a factor containing names of potato lines and wanted to set some levels to `NA`. Using simple letters as example names he was baffled by the result of the following code:

```r
lines <- factor(LETTERS)
lines
# [1] A B C D E F G H...
# Levels: A B C D E F G H...

linesNA <- ifelse(lines %in% c('C', 'G', 'P'), NA, lines)
linesNA
#  [1]  1  2 NA  4  5  6 NA  8...
```

The factor has been converted to numeric and there was no trace of the level names. Even forcing the conversion to be a factor loses the level names. Newbie frustration guaranteed!

```r
linesNA <- factor(ifelse(lines %in% c('C', 'G', 'P'), NA, lines))
linesNA
# [1] 1    2    <na> 4    5    6    <na> 8...
# Levels: 1 2 4 5 6 8...
```

Under the hood factors are numerical vectors (of class factor) that have associated character vectors to describe the levels (see Patrick Burns's [R Inferno](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf) PDF for details). We can deal directly with the levels using this:

```r
linesNA <- lines
levels(linesNA)[levels(linesNA) %in% c('C', 'G', 'P')] <- NA
linesNA
# [1] A    B    <na> D    E    F    <na> H...
#Levels: A B D E F H...
```

We could operate directly on lines (without creating linesNA), which is there to maintain consistency with the previous code. Another way of doing the same would be:

```r
linesNA <- factor(as.character(ifelse(lines %in% c('C', 'G', 'P'), NA, lines)))
linesNA
# [1] A    B    <na> D    E    F    <na> H...
#Levels: A B D E F H...
```

I can believe that there are good reasons for the default behavior of operations on factors, but the results can drive people crazy (at least rhetorically speaking).