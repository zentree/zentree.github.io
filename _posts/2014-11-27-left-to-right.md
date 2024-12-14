---
id: 2535
title: Left-to-right
date: '2014-11-27T21:15:16+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=2535'
permalink: /2014/11/27/left-to-right/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
---

When I write code I’m often amazed by the direction of the statements. I mean, we read and write left-to-right except when we assign statements to a variable. So here we are, doing our business, slowly working in a sentence and, puff!, we get this insight from the future and we assign it to our past, on the left. I commented this on Twitter and [@fadesingh](https://twitter.com/fadesingh/status/537880758795661312) pointed me to [this](http://animalnewyork.com/2014/artists-notebook-ramsey-nasser/) artistic creation of right-to-left programming language, except that the assign was left-to-right.

![Right to left Arabic code.](/assets/images/script_eddin.png)

R has a right-assign operator (`->`) and I was thinking, how would it look if I wrote all the assigns to the left, using an adaptation of [my previous post](/2014/11/back-of-the-envelope-look-at-school-decile-changes/).

```R
options(stringsAsFactors = FALSE)
library(ggplot2)

# School directory
read.csv('directory-school-current.csv', skip = 3) -> direc

# Decile changes
read.csv('DecileChanges_20142015.csv', skip = 2) -> dc

subset(dc,
       select = c(Inst.., X2014.Decile, X2015.Decile, X2014.Step,
       X2015..Step, Decile.Change, Step.Change)) -> dc

c('School.ID', 'deci2014', 'deci2015', 'step2014', 'step2015',
  'decile.change', 'step.change') -> names(dc)

c(LETTERS[1:17], 'Z') -> steps

c(905.81, 842.11, 731.3, 617.8, 507.01, 420.54, 350.25,
  277.32, 220.59, 182.74, 149.99, 135.12, 115.76, 93.71,
  71.64, 46.86, 28.93, 0) -> money

within(dc, {
  ifelse(step2014 == '', NA, step2014) -> step2014
  ifelse(step2015 == '', NA, step2015) -> step2015
  sapply(step2014, function(x) money[match(x, steps)]) -> sm2014
  sapply(step2015, function(x) money[match(x, steps)]) -> sm2015
  sm2015 - sm2014 -> funding.change
}) -> dc

merge(dc,
      direc[, c('School.ID', 'Total.School.Roll', 'Urban.Area', 'Regional.Council')],
      by = 'School.ID', all.x = TRUE) -> dc

within(dc, {
  factor(Urban.Area) -> Urban.Area
  factor(Urban.Area, levels(Urban.Area)[c(3, 2, 4, 1)]) -> Urban.Area
  funding.change*Total.School.Roll/1000 -> school.level.change
}) -> dc


with(dc, {
  summary(funding.change)
  summary(school.level.change)

  sum(sm2014*Total.School.Roll/1000000, na.rm = NA)
  sum(sm2015*Total.School.Roll/1000000, na.rm = NA)
})

#### By Urban area
# Funding change per student on school size
qplot(Total.School.Roll, funding.change, 
      data = dc[!is.na(dc$Urban.Area),], alpha = 0.8,
      xlab = 'Total School Roll', ylab = 'Funding change per student (NZ$)') +
theme_bw() + theme(legend.position = 'none') + 
facet_grid(~Urban.Area)
```

Not too alien; now using the `magrittr` package with right assign would make a lot more sense.

![Funding change per student (NZ$) on total school roll.](/assets/images/change_per_student_rural_non_rural.png)