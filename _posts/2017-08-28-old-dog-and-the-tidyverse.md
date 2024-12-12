---
id: 2910
title: 'Old dog and the tidyverse'
date: '2017-08-28T12:23:18+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=2910'
permalink: /2017/08/28/old-dog-and-the-tidyverse/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2017/08/IMG_2700.jpg
tags:
    - programming
    - stats
---

I started using R ages ago and have happily lived in mostly-base-R for data manipulation. Once in a while I move to something that makes a big difference, like `ggplot2` in 2010 or `Rmarkdown` in 2015, but the set of packages I use for data + plotting hasn’t seen many changes. I have to confess that, meanwhile, I have tested quite a few approaches on the analytics side of things (last year was the turn of Bayesian for me).

Last week, I decided to learn more about the `tidyverse`, thinking of using it more with forestry postgrad students. Now, there is no lack of tutorials, reviews, documentation, etc. for the tidyverse, but most writing shows a final version of the code, without exposing the thinking and dead ends that go behind it. In this post I show how my code was changing, both after reading a few pieces of documentation and, mostly, from feedback I got from Hadley Wickham and Michael MacAskill via a Kiwi-Twitter thread. This post shows minor differences in variable names from that thread, as I changed a few things while reading the files.

The problem is as follows: I have two data frames with trial assessments. Frame one, called `early`, covers trees at ages 5, 7 and 8 years (although ages are in months rather than years). Frame two, called `late`, covers trees at age 20 years. Yes, it takes a while working with trees.

We want to keep only age 8 years (96 months) from `early` and want to split a code into two variables, as well as convert a variable from numeric to character. In `late` we want to create a tree family code, based on a set of rules to connect field codes to the pedigree of trees. Did I mention that I work breeding trees?

Finally, we want to merge all the assessments from age 8 with the assessment at age 20 for the same trees.

Rather than showing the final version of the code, it is much more interesting to show its evolution, also including how I would have done this in base R. I’m omitting the reading of the file and boring case conversion of variable names, etc.

In base R, I would probably do something like this (I’m using the `stringr` package just to make my life easier):

```R
library(stringr)

early_8 <- subset(early, age == 96)
early_8 <- within(early_8, {
  rep <- sapply(section, function(x) unlist(str_split(x, '_'))[1])
  sets <- sapply(section, function(x) unlist(str_split(x, '_'))[2])
  tree <- as.character(`tree position`)
})

late <- within(late, {
  family <- ifelse(field_code < 500, paste('885', str_pad(field_code, 3, pad = '0'), sep = ''),
                   ifelse(field_code >= 500 & field_code < 600, paste('883', str_pad(field_code - 500, 3, pad = '0'), sep = ''),
                          as.character(field_code)))
  rep <- as.character(rep)
  tree <- as.character(tree)
})

both <- merge(early_8, late, by.x = 'genotype', by.y = 'family')
```
My first approach to dealing with the `early` frame with the tidyverse looked like:

```R
library(tidyverse)
library(stringr)

early %>%
  filter(age == 96) %>%
  mutate(rep = flatten_chr(map(section, function(x) unlist(str_split(x, '_'))[1]))) %>%
  mutate(sets = flatten_chr(map(section, function(x) unlist(str_split(x, '_'))[2]))) %>%
  mutate(tree = as.character(`tree position`)) -> early_8
  ```

While the second frame was processed using:

```R
late %>% 
  mutate(family = ifelse(field_code < 500, paste('885', str_pad(field_code, 3, pad = '0'), 
                                                 sep = ''),
                         ifelse(field_code >= 500 & field_code < 600, paste('883', str_pad(field_code - 500, 3, pad = '0'), sep = ''),
                                as.character(field_code)))) %>%
  mutate(rep = as.character(rep))
  mutate(tree = as.character(tree)) -> late
```

I used multiple instances of `mutate` because I thought it would be easier to read. The use of `map` instead of `sapply` is cool, particularly when one starts looking at [more advanced features](https://web.archive.org/web/20170828002824/http://ctlente.com/en/purrr-magic/). Comments from the crowd in Twitter: mutate the whole lot in a single statement (although Hadley pointed out that there was no performance penalty by using them separately) and try using `case_when` to make nested `ifelse` easier to understand. The comments on `map` went in two directions: either use `map_chr` as a clearer and safer alternative, or just use `dplyr`'s `separate` function. The first option for `early` would look like:

```R
early %>%
  filter(age == 96) %>%
  mutate(rep = map_chr(section, function(x) unlist(str_split(x, '_'))[1])) %>%
  mutate(sets = map_chr(section, function(x) unlist(str_split(x, '_'))[2])) %>%
  mutate(tree = as.character(`tree position`)) -> early_8
```

However, I ended up going with the final version that used `separate`, which is easier on the eye and faster, for a final version that looks like this:

```R
early %>% 
  filter(age == 96) %>%
  separate(section, c('rep', 'sets'), sep = '_') %>%
  mutate(tree = as.character(`tree position`),
         genotype = as.character(1:nrow(.) + 10^6)) -> early_8
```

So we filter early, separate the single set code into two variables (rep and sets) and create a couple of variables using mutate (one is a simple type conversion to character, while the other is a code starting at 1,000,000).

In the case of late, I ended up with:

```R
late %>% 
  mutate(family = case_when(
                    field_code < 500  ~  paste('885', str_pad(field_code, 3, pad = '0'), sep = ''),
                    field_code >= 500 & field_code < 600  ~  paste('883', str_pad(field_code - 500, 3, pad = '0'), sep = ''),
                    TRUE ~ as.character(field_code)),
         rep = as.character(rep), 
         tree = as.character(tree)) -> late
```

And we merge the files using:

```R
early_8 %>% 
  left_join(late, c('rep', 'sets', 'tree')) %>%
  left_join(base_pedigree, by = c('family' = 'genotype'))  -> both
```

Some (many, most?) people may disagree with [my use of right assign](/2014/11/left-to-right/), which I love. Surely one could use either left assign or `%<>%` from the maggrittr package. By the way, why do I have to explicitely load magrittr (instead of relying on tidyverse) to access `%<>%`?

And this is how I go about learning new things: lots of false starts, often working with small examples (I used a few to check how `left_join` was working), lots of searching for explanations/tutorials (thanks to everyone who has written them) and asking in Twitter. If you are just starting programming, in any language, do not feel intimidated by cool looking code; most of the time it took many iterations to get it looking like that.

![Tree + puddle in carpark, Christchurch.](/assets/images/tree_puddle.jpg)