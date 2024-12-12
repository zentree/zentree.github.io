---
id: 3158
title: 'Where are New Zealand&#8217;s bellwether electorates?'
date: '2017-09-13T12:40:10+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=3158'
permalink: /2017/09/13/where-are-new-zealands-bellwether-electorates/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2017/09/IMG_2746.jpg
tags:
    - programming
    - politics
---

I was reading [a piece](https://publicaddress.net/legalbeagle/dispatches-from-my-twitter-feed-or-i-salute/) by [Graeme Edgeler](https://twitter.com/GraemeEdgeler) who, near the end, asked “Where are New Zealand’s bellwether electorates?”. I didn’t know where the data came from or how was the “index of disproportionality for each electorate” calculated, but I saw it mostly as an opportunity to whip up some quick code to practice the use of R and look at other packages that play well with the tidyverse.

The task can be described as: fetch Wikipedia page with results of the 2014 parliamentary election, extract the table with results by electorate, calculate some form of deviation from the national results, get the top X electorates with lowest deviation from national results.

A web search revealed that [this page](https://en.wikipedia.org/wiki/New_Zealand_general_election,_2014) contains a whole bunch of results for the 2014 election and that the specific results I’m interested in are in table number 17 of the list created by `html_nodes('table')`. Besides the tidyverse, I needed the packages `rvest` for web scraping, `magrittr` for using `%%` (pipe and assign to original data frame) and `lucid` for pretty printing the final table.

```R
library(tidyverse)
library(rvest)
library(magrittr)
library(lucid)

election14 % 
  html_nodes('table') %>% .[[17]] %>% 
  html_table() %>% 
  filter(Electorate != 'Electorate') -> electorate14

glimpse(electorate14)
```

Rather than reading the national results directly from Wikipedia I just typed them in code, as I already had them from some other stuff I was working on. My measure of “disproportionality for each electorate” was as sophisticated as the sum of squared deviations.

```R
# Results for National, Labour, Green, NZ First, 
# Conservative, Internet Mana & Māori
national_results <- c(47.04, 25.13, 10.7, 8.66, 
                      3.99, 1.42, 1.32)

electorate14 %>% 
  mutate(total_vote = apply(.[,2:8], 1, sum),
         dev = apply(.[,2:8], 1, function(x) sum((x - national_results)^2))) %>%
         arrange(dev) %>% slice(1:15) %>% 
         lucid

```

```
# A tibble: 15 x 10
#             Electorate National Labour Green `NZ First` Conservative `Internet Mana` Māori total_vote   dev
#                  <chr>    <chr>  <chr> <chr>      <chr>        <chr>           <chr> <chr>      <chr> <chr>
# 1                Ōtaki     49.1   24.8  9.46       9.96         4.41            0.65  0.44       98.8  9.02
# 2        Hamilton West     47.7   25.7  8.21      10.8          4.67            0.72  0.56       98.4 13.2 
# 3        Hamilton East     50     23.8 11          7.14         4.81            1     0.64       98.4 14.5 
# 4    West Coast-Tasman     44.8   23.5 13          8.71         5.12            0.76  0.28       96.2 15.7 
# 5               Napier     49.4   26    8.77       7.43         6.23            0.6   0.44       98.8 17.9 
# 6           Hutt South     45.3   28   12.8        7.48         3.57            0.72  0.53       98.3 18   
# 7           East Coast     48.6   22.7  9.21      11.8          4.08            1.17  0.95       98.6 20.7 
# 8               Nelson     44.4   24.7 14.1        7.67         5.5             0.83  0.33       97.6 23.4 
# 9         Invercargill     49.5   25.1  7.57      11.2          3.68            0.62  0.32       97.9 23.7 
#10            Whanganui     47.3   25.5  7.21      12            5.02            0.73  0.58       98.3 25.4 
#11            Northcote     50.7   22.1 11.6        7.32         4.31            0.95  0.46       97.5 26.3 
#12               Wigram     42.9   28.7 12.8        8.56         3.61            0.76  0.47       97.8 35.4 
#13 Christchurch Central     44.7   26.2 15.8        7.19         3.11            1.03  0.46       98.5 37   
#14             Tukituki     52     22.8  8.57       7.6          6.56            0.68  0.52       98.8 43.3 
#15           Port Hills     47     23.9 17.1        6.62         3.11            0.75  0.4        98.8 48.7
```

I’m sure there must be a ‘more idiomatic’ way of doing the squared deviation using the tidyverse. At the same time, using `apply` came naturally in my head when writing the code, so I opted for keeping it and not interrupting the coding flow. The results are pretty similar to the ones presented by Graeme in his piece.

I’m getting increasingly comfortable with this mestizo approach of using the tidyverse and base R for completing tasks. Whatever it takes to express what I need to achieve quickly and more or less in a readable way.

![Newton meditating how far down the list is the Wigram electorate: not quite bellwether.](/assets/images/newton_wondering.jpg)