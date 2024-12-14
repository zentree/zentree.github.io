---
id: 2408
title: 'Sometimes I feel (some) need for speed'
date: '2014-07-12T10:06:06+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=2408'
permalink: /2014/07/12/sometimes-i-feel-some-need-for-speed/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

I’m the first to acknowledge that most of my code could run faster. The truth of the matter is that, in essence, I write ‘quickies’: code that will run once or twice, so there is no incentive to spend days or hours in shaving seconds of a computation. Most analyses of research data fall in to this approach: read data-clean data-fit model-check model-be happy-write article-(perhaps) make data and code available-move on with life.

One of the reasons why my code doesn’t run faster or uses less memory is the trade-off between the cost of my time (very high) compared to the cost of more memory or faster processors (very cheap) and the gains of shaving a few seconds or minutes of computer time, which tend to be fairly little.

In R vectorization is faster than working with each vector element, although it implies allocating memory for whole vectors and matrices, which for large-enough problems may become prohibitively expensive. On the other hand, not vectorizing some operations may turn your problem into an excruciatingly slow exercise and, for example in large simulations, in practice intractable in a useful timeframe.

![Dealing with vectors and matrices is like dealing with many chairs simultaneously. Some patterns and operations are easier and faster than others. (Photo: Luis, click to enlarge).](/assets/images/vectors.jpg)

[John Muschelli](http://hopstat.wordpress.com/2014/07/07/sometimes-table-is-not-the-answer-a-faster-2x2-table/) wrote an interesting post reimplementing 2×2 frequency tables for a highly specific use, comparing the results of image processing algorithms. In John’s case, there are two greater-than-9-million-long-elements logical vectors, and when comparing vectors for *many* images the process becomes very slow. He explains part of his rationale in his blog (go and read it), but say that his solution can be expressed like this:

```R
# I don't have any image data, but I'll simulate a couple
# of 10 million long logical vectors (just to round things)
set.seed(2014)

manual <- sample(c(TRUE, FALSE), 10E6, replace = TRUE)
auto <- sample(c(TRUE, FALSE), 10E6, replace = TRUE)

logical.tab <- function(x, y) {
  tt <- sum(x & y)
  tf <- sum(x & !y)
  ft <- sum(!x & y)
  ff <- sum(!x & !y)
return(matrix(c(ff, tf, ft, tt), 2, 2))
}
```

which uses 1/4 of the time used by `table(manual, auto)`. Mission accomplished! However, if I stopped here this blog post would not make much sense, simply rehashing (pun intended) John's code. The point is to explain what is going on and, perhaps, to find even faster ways of performing the calculations. As a start, we have to be aware that the calculations in `logical.tab()` rely on logical (boolean) operations and on the coercion of logical vectors to numerical values, as stated in the documentation:

> Logical vectors are coerced to integer vectors in contexts where a numerical value is required, with `TRUE` being mapped to 1L, `FALSE` to 0L and `NA` to `NA_integer_`.
>

In R Logical operations can be slower than mathematical ones, a consideration that may guide us to think of the problem in a slightly different way. For example, take the difference between the vectors (`dif = x - y`), so both `TRUE-TRUE` (1-1) and `FALSE-FALSE` (0-0) are 0, while `TRUE - FALSE` (1-0) is 1 and `FALSE - TRUE` (0-1) is -1. Therefore:

- the sum of positive values (`sum(dif > 0)`) is the frequency of `TRUE & FALSE`,
- while the sum of negative values (`sum(dif < 0)` is the frequency of `FALSE & TRUE`.`

The values for `TRUE & TRUE` can be obtained by adding up the element-wise multiplication of the two vectors, as `TRUE*TRUE` (1\*1) is the only product that's different from zero. A vectorized way of performing this operation would be to use `t(x) %*% y`; however, for large vectors the implementation `crossprod(x, y)` is faster. The values for `FALSE & FALSE` are simply the difference of the length of the vectors and the previously calculated frequencies `length(dif) - tt - tf - ft`. Putting it all together:

```R
basic.tab <- function(x, y) {
  dif <- x - y 
  tf <- sum(dif > 0)
  ft <- sum(dif < 0)
  tt <- crossprod(x, y)
  ff <- length(dif) - tt - tf - ft
return(c(tf, ft, tt, ff))
}
```

This code takes 1/20 of the time taken by `table(x, y)`. An interesting result is that the crossproduct `crossprod(x, y)` can also be expressed as `sum(x * y)`, which I didn't expect to be faster but, hey, it is. So we can express the code as:

```R
basic.tab2 <- function(x, y) {
  dif <- x - y
  tf <- sum(dif > 0)
  ft <- sum(dif < 0)
  tt <- sum(x*y)
  ff <- length(dif) - tt - tf - ft
return(c(tf, ft, tt, ff))
}
```

to get roughly 1/22 of the time. The cost of logical operations is easier to see if we isolate particular calculations in `logical.tab` and `basic.tab`; for example,

```R
tf1 <- function(x, y) {
  tf <- sum(x & !y)
}
```

is slower than

```R
tf2 <- function(x, y) {
  dif <- x - y
  tf <- sum(dif > 0)
}
```

This also got me thinking of the cost of coercion: Would it take long? In fact, coercing logical vectors to numeric has little (at least I couldn't see from a practical viewpoint) if any cost. In some cases relying on logical vectors converted using `as.numeric()` seems to be detrimental on terms of speed.

As I mentioned at the beginning, vectorization uses plenty of memory, so if we were constrained in that front and we wanted to do a single pass on the data we could write an explicit loop:

```R
loopy.tab <- function(x, y) {
  tt <- 0; tf <- 0; ft <- 0; ff <- 0

for(i in seq_along(x)) {
  if(x[i] == TRUE & y[i] == TRUE)
    tt <- tt + 1
  else
  if(x[i] == TRUE & y[i] == FALSE)
    tf <- tf + 1
  else
  if(x[i] == FALSE & y[i] == TRUE)
    ft <- ft + 1
  else
  ff <- ff + 1
}
return(matrix(c(ff, tf, ft, tt), 2, 2))
}
```

The `loopy.tab` does only one pass over the vectors and should use less memory as it doesn't need to create those huge 10M elements vectors all the time (at least it would if we used a proper iterator in the loop instead of iterating on a vector of length 10M (that's 40 MB big in this case). The [iterators](http://cran.r-project.org/web/packages/iterators/index.html) package may help here). We save room/memory at the expense of speed, as `loopy.tab` is ten times slower than the original `table()` function. Of course one could run it a lot faster if implemented in another language like C++ or Fortran and here Rcpp or Rcpp11 would come handy (updated! See below).

This is only a not-so-short way of reminding myself what's going on when trading-off memory, execution speed and my personal time. Thus, I am not saying that any of these functions is the best possible solution, but playing with ideas and constraints that one often considers when writing code. Incidentally, an easy way to compare the execution time of these functions is using the `microbenchmark` library. For example:

```R
library(microbenchmark)
microbenchmark(logical.tab(manual, auto), 
               basic.tab2(manual, auto), 
               times = 1000)
```

will spit numbers when running a couple of functions 1,000 times with results that apply to your specific system.

PS 2014-07-12 11:08 NZST Hadley Wickham suggested using `tabulate(manual + auto * 2 + 1, 4)` as a fast alternative. Nevertheless, I would like to point out that i- the initial tabulation problem is only an excuse to discuss a subset of performance issues when working with R and ii- this post is more about the journey than the destination.

PS 2014-07-13 20:32 NZST Links to two posts related to this one:

- [Wiekvoet](http://wiekvoet.blogspot.nl/2014/07/odfweave-setup-and-counting-logicals.html)'s work which i- relies on marginals and ii- reduces the use of logical operators even more than my `basic.tab2()`, simultaneously taking around 1/4 of the time.
- [Yin Zhu](http://fdatamining.blogspot.co.nz/2014/07/r-notes-vectors.html)'s post describing vectors is a handy reminder of the basic building blocks used in this post.

###  Updated with Rcpp goodness!

PS 2014-07-13 21:45 NZST I browsed the [Rcpp Gallery](http://gallery.rcpp.org/) and Hadley Wickham's [Rcpp tutorial](http://adv-r.had.co.nz/Rcpp.html) and quickly converted `loopy.tab()` to C++. Being a bit of an oldie I've used Fortran (90, not *that* old) before but never C++, so the following code is probably not very idiomatic.

```R
library(Rcpp)
cppFunction('NumericVector loopyCpp(LogicalVector x, LogicalVector y) {
  int niter = x.size();
  int tt = 0, tf = 0, ft = 0, ff = 0;
  NumericVector tab(4);


  for(int i = 0; i < niter; i++) {
    if(x[i] == TRUE && y[i] == TRUE)
      tt++;
    else
    if(x[i] == TRUE && y[i] == FALSE)
      tf++;
    else
    if(x[i] == FALSE && y[i] == TRUE)
      ft++;
    else
      ff++;
}

tab[0] = ff; tab[1] = tf; tab[2] = ft; tab[3] = tt;
return tab;
}'
)

loopyCpp(manual, auto)
```
Loops and all it runs roughly twice as fast as `basic.tab2()` but it should also use much less memory.