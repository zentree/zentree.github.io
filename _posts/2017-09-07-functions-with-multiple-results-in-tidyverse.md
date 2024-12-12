---
id: 3143
title: 'Functions with multiple results in tidyverse'
date: '2017-09-07T15:23:58+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=3143'
permalink: /2017/09/07/functions-with-multiple-results-in-tidyverse/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2017/09/IMG_2721.jpg
tags:
    - programming
    - stats
---

I have [continued playing with the tidyverse](/2017/08/old-dog-and-the-tidyverse/) for different parts of a couple of projects.

Often I need to apply a function by groups of observations; sometimes, that function returns more than a single number. It could be something like for each group fit a distribution and return the distribution parameters. Or, simpler for the purposes of this exploration, calculate and return a bunch of numbers.

```R
describe_c <- function(x) {
  mn <- mean(x, na.rm = TRUE)
  dev <- sd(x, na.rm = TRUE)
  n <- sum(!is.na(x))
  cv <- dev/mn*100
  return(c(mean = mn, sdev = dev, 
           count = n, coefvar = cv))
}
```

If I have a data frame called <code>field_data</code>, with family codes (trees with the same parents, codes have been changed to protect the innocent) and stem diameters (in mm), I could do the following in base R:

```R
# This line produces an annoying list
summary_one <- with(field_data, 
                    tapply(stem, family, FUN = describe_v))

# This puts together a matrix by joining 
# the list results using rbind()
summary_one <- do.call(rbind, summary_one)

# To continue processing it might be better to convert
# to a data frame
summary_one <- data.frame(summary_one)
```

And if I need to do this for several variables, I will need to merge each of these matrices in a data frame.

Continuing with my experimentation with the tidyverse, I was wondering how to get the above going with dplyr et al. After failing a few times I asked the question in Twitter and got a number of helpful replies.

One of the keys is that `dplyr` can store a list result from a function. Modifying my toy function is pretty straightforward, and now looks like:

```R
describe_list <- function(x) {
  mn <- mean(x, na.rm = TRUE)
  dev <- sd(x, na.rm = TRUE)
  n <- sum(!is.na(x))
  cv <- dev/mn*100
  return(list(c(mean = mn, sdev = dev, 
                count = n, coefvar = cv)))
}
```

And we can check the contents of `summary_two` to see we have a list in which each element contains 4 values:

```
head(summary_two)
#  A tibble: 6 x 2
#   family     model
#   <fctr>    <list>
# 1      A <dbl [4]="">
# 2      B <dbl [4]="">
# 3      C <dbl [4]="">
# 4      D <dbl [4]="">
# 5      E <dbl [4]="">
# 6      F <dbl [4]="">
#
```

We still need to extract the elements of each element of the list and assign them to a variable name. Using `map` from the `purrr` package is pretty straightforward in this case, and we can extract the values either using their names or their position in the element.

```R
summary_two %>% 
  mutate(mn = map_dbl(model,'mean'),
         sd = map_dbl(model,'sdev'),
         n = map_dbl(model,'count'),
         cv = map_dbl(model,4)) %>% head

#  A tibble: 6 x 6
#   family     model       mn       sd     n       cv
#   <fctr>    <list>    <dbl>    <dbl> <dbl>    <dbl>
# 1      A <dbl [4]=""> 190.8306 23.71290   425 12.42615
# 2      B <dbl [4]=""> 190.1111 25.46554   396 13.39508
# 3      C <dbl [4]=""> 188.2646 27.39215   461 14.54981
# 4      D <dbl [4]=""> 189.2668 25.16330   431 13.29514
# 5      E <dbl [4]=""> 183.5238 19.70182    21 10.73530
# 6      F <dbl [4]=""> 183.1250 28.82377    24 15.73994
#
```

I'm still playing with ideas to be lazier at extraction time. An almost abhorrent idea is to provide the output as character for posterior type conversion, as in:

```R
describe_char <- function(x) {
  mn <- mean(x, na.rm = TRUE)
  dev <- sd(x, na.rm = TRUE)
  n <- sum(!is.na(x))
  cv <- dev/mn*100
  return(paste(mn, dev, n, cv, sep = ':'))
}

field_data %>% 
  group_by(family) %>%
  summarise(model = describe_char(stem)) -> summary_three

head(summary_three)

# A tibble: 6 x 2
#   family                                                  model
#   <fctr>                                                  <chr>
# 1      A 190.830588235294:23.7128956613006:425:12.4261502731746
# 2      B 190.111111111111:25.4655444116168:396:13.3950847284951
# 3      C  188.26464208243:27.3921487349435:461:14.5498105390125
# 4      D 189.266821345708:25.1632953227626:431:13.2951434085746
# 5      E   183.52380952381:19.7018249094317:21:10.7352963959021
# 6      F           183.125:28.8237711378767:24:15.7399432834822
#

summary_three %>% 
  separate(model, 
           c('mn', 'sd', 'n', 'cv'), 
           sep = ':') %>% head

# A tibble: 6 x 5
#   family               mn               sd     n               cv
#   <fctr>            <chr>            <chr> <chr>            <chr>
# 1      A 190.830588235294 23.7128956613006   425 12.4261502731746
# 2      B 190.111111111111 25.4655444116168   396 13.3950847284951
# 3      C  188.26464208243 27.3921487349435   461 14.5498105390125
# 4      D 189.266821345708 25.1632953227626   431 13.2951434085746
# 5      E  183.52380952381 19.7018249094317    21 10.7352963959021
# 6      F          183.125 28.8237711378767    24 15.7399432834822
#
```

And we can get all the way there with:

```R
summary_three %>% 
  separate(model, 
           c('mn', 'sd', 'n', 'cv'), 
           sep = ':') %>% 
  mutate_at(c('mn', 'sd', 'n', 'cv'), 
            as.numeric) %>% head

# A tibble: 6 x 5
#   family       mn       sd     n       cv
#   <fctr>    <dbl>    <dbl> <dbl>    <dbl>
# 1      A 190.8306 23.71290   425 12.42615
# 2      B 190.1111 25.46554   396 13.39508
# 3      C 188.2646 27.39215   461 14.54981
# 4      D 189.2668 25.16330   431 13.29514
# 5      E 183.5238 19.70182    21 10.73530
# 6      F 183.1250 28.82377    24 15.73994
```

Which I assume has all sort of potential negative side-effects, but looks really cool.

In case you want to play with the problem, here is a [tiny example of field data](/assets/uploads/field_data.csv).

![Cell tower antenna, Christchurch.](/assets/images/antenna.jpg)