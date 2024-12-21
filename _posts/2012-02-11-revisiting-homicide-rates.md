---
id: 826
title: 'Revisiting homicide rates'
date: '2012-02-11T11:30:29+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=826'
permalink: /2012/02/11/revisiting-homicide-rates/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/02/homicides-tile.png
tags:
    - stats
---

[A pint of R](http://rpint.wordpress.com/2012/02/09/intentional-homicide-in-south-america-1995-2010/) plotted an interesting dataset: intentional homicides in South America. I thought the graphs were pretty but I was unhappy about the way information was conveyed in the plots; relative risk should be **very** important but number of homicides is very misleading as it also relates to country population (this problem often comes up in our discussions in [Stats Chat](http://www.statschat.org.nz/)).

Instead of just complaining I decided to try a few alternatives (**disclaimer:** I do not have a good eye for colors or design but I am only looking at ways that could better show relative risk). I therefore downloaded the [MS Excel file](http://www.unodc.org/documents/data-and-analysis/statistics/Homicide/Homicide_data_series.xls), which contained a lot of information from other countries and extracted only the information relevant to these plots, which you can obtain here: [homicides.csv](/assets/uploads/2012/02/homicides.csv) (4 KB). Some quick code could display the following graph:

```r
library(ggplot2)

setwd('~/Dropbox/quantumforest')
kill <- read.csv('homicides.csv', header = TRUE)

kp <- ggplot(kill, aes(x = year, y = country, fill = rate))

# Colors coming from
# http://learnr.wordpress.com/2010/01/26/ggplot2-quick-heatmap-plotting/
png('homicides-tile.png', width = 500, height = 500)
kp <- kp + geom_tile() + 
  scale_x_continuous(name = 'Year', expand = c(0, 0)) +
  scale_y_discrete(name = 'Country', expand = c(0, 0)) +
  scale_fill_gradient(low = 'white', 
                      high = 'steelblue', name = 'Homicide rate') +
  theme_bw() +
  opts(panel.grid.major = theme_line(colour = NA),
       panel.grid.minor = theme_line(colour = NA))
dev.off()
```

![Tile graph for homicides.](/assets/images/homicides-tile.png)

It is also possible to use a line graph, but it quickly gets very messy, so I created totally arbitrary violence categories:

```r
# Totally arbitrary classification
kill$type <- ifelse(kill$country %in% c('Brazil', 'Colombia', 'Venezuela'),
                    'Freaking violent',
                      ifelse(kill$country %in% c('Ecuador', 'Surinam', 'Guyana'),
                        'Plain violent',
                    'Sort of quiet'))

kp2 <- ggplot(kill, aes(x = year, y = rate, colour = country))

png('homicides-lines.png', width=1000, height = 300)
  kp2 + geom_line() + facet_grid(. ~ type) +
  scale_y_continuous('Homicides/100,000 people') +
  scale_x_continuous('Year') + theme_bw() +
  opts(axis.text.x = theme_text(size = 10),
       axis.text.y = theme_text(size = 10),
       legend.position = 'none')
dev.off()
```

![Another view, which still requires labeling countries. Venezuela, what did happen to you? You look like the Wild West&hellip;](/assets/images/homicides-lines.png)

I hope others will download the data and provide much better alternatives to display violence. If you do, please add a link in the comments.