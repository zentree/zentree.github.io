---
id: 3181
title: 'Calculating parliament seats allocation and quotients'
date: '2017-10-03T14:22:18+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=3181'
permalink: /2017/10/03/calculating-parliament-seats-allocation-and-quotients/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2017/10/IMG_2633.jpg
tags:
    - programming
    - politics
---

I was having a conversation about dropping the minimum threshold (currently 5% of the vote) for political parties to get representation in Parliament. The obvious question is how would seat allocation change, which of course involved a calculation. There is a [calculator](http://www.elections.org.nz/voting-system/mmp-voting-system/mmp-seat-allocation-calculator) in the Electoral Commission website, but trying to understand how things work (and therefore coding) is my thing, and the Electoral Commission has a handy [explanation of the Sainte-Laguë](https://web.archive.org/web/20170618132721/http://www.elections.org.nz/voting-system/mmp-voting-system/sainte-lague-allocation-formula) allocation formula used in New Zealand. So I had to write my own seat allocation function:

```R
allocate_seats <- function(votes) {
  parties <- names(votes)
  denom <- seq(1, 121, 2)
  
  quotients <- vapply(denom, FUN =  function(x) votes/x, FUN.VALUE = rep(1, length(votes)))
  quotients <- t(quotients)
  colnames(quotients) <- parties
  
  priority <- rank(-quotients)
  seat_ranking <- matrix(priority, nrow = nrow(quotients), ncol = ncol(quotients))
  seat_ranking <- ifelse(seat_ranking <= 120, seat_ranking, NA)
  colnames(seat_ranking) <- parties
  
  return(list(quotients = quotients, ranking = seat_ranking))
}
```

Testing it with the preliminary election results (that is, no including special votes) gives:

```R
votes2017 <- c(998813, 776556, 162988, 126995, 10959, 48018, 23456)
names(votes2017) <- c('National', 'Labour', 'NZ First', 'Green', 'ACT', 
                      'Opportunities', 'Māori')

seats2017 <- allocate_seats(votes2017)

seats2017$ranking

#      National Labour NZ First Green ACT Opportunities Māori
# [1,]        1      2        6     9  98            22    46
# [2,]        3      4       19    26  NA            67    NA
# [3,]        5      7       33    42  NA           112    NA
# [4,]        8     11       47    59  NA            NA    NA
# [5,]       10     13       60    77  NA            NA    NA
# [6,]       12     15       73    93  NA            NA    NA
# [7,]       14     17       86   110  NA            NA    NA
# [8,]       16     21      100    NA  NA            NA    NA
# [9,]       18     24      113    NA  NA            NA    NA
#[10,]       20     27       NA    NA  NA            NA    NA
# ...
```

In our current setup The Opportunities and Māori parties did not reach the minimum threshold (nor won an electorate as ACT violating the spirit of the system), so did not get any seats. Those 4 seats that would have gone to minor parties under no threshold ended up going to National and Labour (2 each). It sucks.

![Tree exploring the urban landscape, Christchurch.](/assets/images/tree_building.jpg)