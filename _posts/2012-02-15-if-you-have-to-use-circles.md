---
id: 842
title: 'If you have to use circles&#8230;'
date: '2012-02-15T20:25:55+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=842'
permalink: /2012/02/15/if-you-have-to-use-circles/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - stats
---

Stats Chat is an interesting kiwi site—managed by the Department of Statistics of the University of Auckland—that centers around the use and presentation of statistics in the media. This week there was an interesting discussion on one of those infographics that make you cringe:

![](/assets/images/bubble-charts-sunday-star-times.jpg)

I understand the newspaper’s need to grab our attention, as well as the designer’s esthetical considerations, but they have to follow avoiding misleading the reader and providing at least a ball-park idea of the importance of whatever issue is under discussion. Clearly, as pointed out in the discussion, a line chart would convey the message with a minimum of ink; however, the designer may still want to use circles, and here we could go back to a faceted version of the always maligned pie chart.

![Faceted pie charts using ggplot2.](/assets/images/faceted-pie-charts.png)

This code reads [the data](/assets/uploads/bubble-data.csv), reshapes it and plots it using pretty much the explanation for pie charts in the ggplot2 documentation.

```r
# Location and libraries
library(reshape)
library(ggplot2)
setwd('~/Dropbox/quantumforest')


# Reading data and melting into long shape
bub <- read.csv('bubble-data.csv', header = TRUE)
bub2 <- melt(bub, id = 'year')
names(bub2)[2] = 'worry'
```

Again, please remember my typical disclaimer about lack of design and color flair. Colors and scales need work, but I think it is an improvement over the original.