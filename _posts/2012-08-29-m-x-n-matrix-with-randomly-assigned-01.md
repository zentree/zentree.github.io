---
id: 1281
title: 'm x n matrix with randomly assigned 0/1'
date: '2012-08-29T11:19:01+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1281'
permalink: /2012/08/29/m-x-n-matrix-with-randomly-assigned-01/
classic-editor-remember:
    - block-editor
    - block-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/08/horse_race.jpg
tags:
    - programming
    - stats
---

Today Scott Chamberlain tweeted asking for a better/faster solution to building an m x n matrix with randomly assigned 0/1. He already had a working version:

```r
r <- 1000
c <- 1000
m0 <- matrix(0, r, c)
apply(m0, c(1,2), function(x) sample(c(0,1),1))
```

Now, I’m the first to acknowledge that I’ve never got the ‘apply’ family of functions and that—thanks [Hadley](http://had.co.nz/)—if I need to do something like that I go for the [plyr](http://plyr.had.co.nz/) package. Nevertheless, if you think about it, the starting point is a sugary version of a loop; I like loops because they are explicit and clear, but they can be very slow in R. The loop could be written as:

```r
m00 <- matrix(0, r, c)
for(i in 1:r) {
  for(j in 1:c) {
    m00[i, j] <- sample(c(0,1),1)
  }
}
```

In contrast, my first idea was to generate a bunch of uniformly distributed \[0, 1) random numbers and round them to the closest integer, which is a more ‘matricy’ way of thinking:

```r
m1 <- round(matrix(runif(r*c), r, c)))
```

and it happens to be a lot faster. My second idea, and Edmund Hart beat me to that one, was to use something like:

```r
m2 <- matrix(rbinom(r*c,1,0.5),r,c)
```

which is a nice option, generating r*c random numbers following a binomial distribution, which also has the advantage of allowing for different probabilities, rather than 0.5 as in m1. This is also faster than m1, although probably one would not notice the difference until working with fairly big matrices. When Scott pointed out the speed bump he got me thinking about order of the operations; would this be better?

```r
m3 <- matrix(round(runif(r*c)), r, c)
```

In terms of speed, m3 fits between m1 and m2, so the order *can* make a difference.

David Smith and Rafael Maia came up with a different approach, using `sample()` which I had not considered at all. m4 has the advantage that one could use any number of values to randomize.

```r
m4 <- matrix(sample(0:1,r*c, replace=TRUE),r,c)
```

Any of these options can be timed using the `system.time()` function as in `system.time(m3 = matrix(round(runif(r*c)), r, c))`. It’s interesting how different people come up with alternative strategies (reflecting different ways of thinking about the problem) using exactly the same language. I’m not sure what should be the ‘obvious’ solution; but for almost any purpose any of them (with the exception of the explicit loop) will work just fine.

![Racing horses training at the beach.](/assets/images/horse_race.jpg)

**P.S. 2012-08-29, 22:33.** Another way that would work (although 4 times slower than m1) would be:  
`m5 = matrix(ifelse(runif(r*c) < 0.5, 0, 1))`. Still, it takes less than 0.5 seconds for a 1,000,000 elements matrix.  

**P.S. 2012-09-04.** Very cool, Dirk Eddelbuettel implemented [even faster creation of random 1/0 matrices](http://dirk.eddelbuettel.com/blog/2012/09/02/#faster_binomial_matrix_creation) using Rcpp, with inline C++ code. Much faster in a crazy overkill sort of way.