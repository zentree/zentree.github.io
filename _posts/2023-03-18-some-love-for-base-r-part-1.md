---
id: 4609
title: 'Some love for Base R. Part 1'
date: '2023-03-18T10:00:36+13:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=4609'
permalink: /2023/03/18/some-love-for-base-r-part-1/
classic-editor-remember:
    - block-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2014/07/mirrormirror.jpg
tags:
    - programming
    - stats
---

For a long time it has bothered me when people look down at `base-R` (meaning the set of functions that comes in a default installation), as it were a lesser version of the language when compared to the `tidyverse` set of functions or `data.table` or whatever. I think part of this situation is due to 1. much less abundant *modern* documentation and tutorials using `base` and 2. the treatment of `base` in those tutorials ignores base constructs that make it look, well, tidy.

This could be read as a curmudgeon complaining at clouds BUT there are occasions when relying on a minimal installation without any extra packages is quite useful. For example, when you want almost maintenance-free code between versions, base R is very stable. I have code that’s almost 20 years old and still running. As a researcher, this is a really good situation.

If you’re unconvinced, there is a much cooler application [webr](https://github.com/r-wasm/webr), or R in the browser. It happens to be that loading additional packages (particularly large ones, like the `tidyverse`) makes the whole R in the browser proposition much slower. A toot (this was in Mastodon, by the way) by bOb Rudis ([hrbrmstr](https://mastodon.nz/@hrbrmstr@mastodon.social)) got me thinking that:

> @hrbrmstr It would be cool to see a renaissance of base R, leading to a tidier, much more readable use with with(), within(), etc.
> 
> <cite>Luis</cite>

![Exchanging ideas on webR: packages are a pain, perhaps a base-R renaissance.](/assets/images/webr.jpg)

Perhaps an example will show better what I mean. Let’s assume we go back in time and you find 15-year-old code that looks like this:

```R
setwd("/Users/luis/Documents/Research/2008/Glasshouse")
gw <- read.csv("data20091111.csv", header = TRUE)

gw$dratio <- gw$dia1.mm/gw$dia2.mm
gw$dia <- ifelse(is.na(gw$dia2.mm), 
                 gw$dia1.mm, (gw$dia1.mm + gw$dia2.mm)/2)
gw$slend <- gw$ht.cm/gw$dia
# Squared standing velocity in April
gw$smoe <- 1.1*gw$v2104^2 
gw$gmoe <- 1.1*gw$vgreen^2
gw$dmoe <- (gw$bden/1000)*1.14*gw$vdry^2
```

Which, let’s face it, it doesn’t look pretty. If you were working in the tidyverse you’d probably also be using RStudio (and projects). If you are using projects, your code would look like:

```R
library(readr)
library(dplyr)

gw <- read_csv("data20091111.csv")

gw <- gw %>% 
  mutate(dratio = dia1.mm/dia2.mm,
         dia = ifelse(is.na(dia2.mm), 
                      dia1.mm, (dia1.mm + dia2.mm)/2),
         slend = ht.cm / dia,
         smoe = 1.1 * v2104^2,
         gmoe = 1.1 * vgreen^2,
         dmoe = (bden / 1000) * 1.14 * vdry^2)
```

which is easier to read and follow in my opinion. However, there was nothing stopping you to write the following 15 years ago:

```R
setwd("/Users/luis/Documents/Research/2008/Glasshouse")
gw <- read.csv("data20091111.csv", header = TRUE)

gw <- within(gw, { 
  dratio<- dia1.mm/dia2.mm
  dia <- ifelse(is.na(dia2.mm), 
                dia1.mm, (dia1.mm + dia2.mm)/2)
  slend <- ht.cm / dia
  smoe <- 1.1 * v2104^2
  gmoe <- 1.1 * vgreen^2
  dmoe <- (bden / 1000) * 1.14 * vdry^2
})
```

which is quite similar to the `dplyr` code, but without any external package dependencies. Now, if you are missing the `magrittr` pipes, from R 4.1.0 it is possible to use native pipes and write the above code as:

```R
setwd("/Users/luis/Documents/Research/2008/Glasshouse")
gw <- read.csv("data20091111.csv", header = TRUE)

gw <- gw |> within({ 
  dratio <- dia1.mm/dia2.mm
  dia <- ifelse(is.na(dia2.mm), 
                dia1.mm, (dia1.mm + dia2.mm)/2)
  slend <- ht.cm / dia
  smoe <- 1.1 * v2104^2
  gmoe <- 1.1 * vgreen^2
  dmoe <- (bden / 1000) * 1.14 * vdry^2
})
```

which gets us even closer to the `tidyverse`. The real magic is using `within()` to specify inside which data frame we are looking for all the variables that are being referred by the calculations. This permits us writing `dratio <- dia1.mm/dia2.mm` instead of `gw$dratio <- gw$dia1.mm/gw$dia2.mm`. There are a few “tricks” like this to make `base-R` a very attractive option, particularly if you like minimal, few dependencies coding.

**P.D. 2023-03-26:** A couple of people asked in Mastodon Why not use `transform()` instead of `within()`? It is a good question, because `transform()` looks closer to `mutate()` with a call like:

```R
transform(data_frame, 
          transformation_1, 
          transformation_2, etc)
```

But there is a subtle difference that creates an error in my previous example. In transform one cannot refer to variables previously created in the same transformation. Therefore, this fails:

```R
setwd("/Users/luis/Documents/Research/2008/Glasshouse")
gw <- read.csv("data20091111.csv", header = TRUE)

gw <- gw |> 
  transform(dratio = dia1.mm/dia2.mm,
            dia = ifelse(is.na(dia2.mm), 
                         dia1.mm, (dia1.mm + dia2.mm)/2),
            slend = ht.cm / dia,
            smoe = 1.1 * v2104^2,
            gmoe = 1.1 * vgreen^2,
            dmoe = (bden / 1000) * 1.14 * vdry^2)
```

because `slend = ht.cm / dia` refers to the variable `dia` created in the previous line. However, this could be fixed by using:

```R
setwd("/Users/luis/Documents/Research/2008/Glasshouse")
gw <- read.csv("data20091111.csv", header = TRUE)

gw <- gw |> 
  transform(dratio = dia1.mm/dia2.mm,
            dia = ifelse(is.na(dia2.mm), 
            dia1.mm, (dia1.mm + dia2.mm)/2)) |>
  transform(slend = ht.cm / dia,
            smoe = 1.1 * v2104^2,
            gmoe = 1.1 * vgreen^2,
            dmoe = (bden / 1000) * 1.14 * vdry^2)
```

There are parts [2](/2023/03/18/some-love-for-base-r-part-2/), [3](/2023/03/21/some-love-for-base-r-part-3/) and [4](/2023/04/15/some-love-for-base-r-part-4/) of this post.