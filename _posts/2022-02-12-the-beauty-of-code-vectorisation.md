---
id: 3522
title: 'The beauty of code vectorisation'
date: '2022-02-12T19:20:52+13:00'
author: Luis
layout: post
guid: 'https://www.quantumforest.com/?p=3522'
permalink: /2022/02/12/the-beauty-of-code-vectorisation/
classic-editor-remember:
    - block-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2022/02/sunflower_small.jpg
tags:
    - programming
    - stats
---

I came across [this problem](https://twitter.com/fermatslibrary/status/1449027186267197463?s=20&t=sAwZo0m1Z05yqDFfoRBulg) in Twitter:

![Description of the problem by Fermat’s Library.](/assets/images/fermats.png)

The basic pieces of the problem are:

- We need to generate pseudorandom numbers with an identical distribution, add them up until they go over 1 and report back how many numbers we needed to achieve that condition.
- Well, do the above “quite a few times” and take the average, which should converge to the number e (2.7182…).

In most traditional languages, the first step would look more or less like this:

```R
counter <- 0
while(total <= 1) {
  total <- total + runif(1)
  counter <- counter + 1
}
```

or by setting a “big enough” predefined number of iterations:

```R
total <- 0 
for(counter in 1:100) { 
  total <- total + runif(1) 
  if(total > 1) return(counter)
}
```

We would need to define another loop to run the above code “quite a few times”, which for ten million times (10^7) could look like:

```R
results <- 0
average <- 0
for(iteration in 1:10^7) {
  total <- 0
  counter <- 0
  while(total < 1) {
    total <- total + runif(1)
    counter <- counter + 1
  }
results <- results + counter
average <- results/iteration
}
```

However, we are working with R, which happens to be an array-based (or matrix-based, or vector-based) language **and** it has functionality for data processing. A first, rough approach could be:

```R
mean(vapply(1:10^7, 
     FUN.VALUE = 1, FUN = function(x) {
  sum <- 0
  i <- 1
  while(TRUE) {
    sum <- sum + runif(1)
    if(sum > 1) return(i) else {
      i <- i+1
    next
    }
  }
}))
```

It can be much shorter if, rather than thinking of loops, we think of vectors:

```R
mean(replicate(10^7, 
     min(which(cumsum(runif(100)) > 1, TRUE))))
```

The code works the following way:

1. Generate 100 uniformly distributed random numbers (0, 1): `runif(100)`
2. Calculate the cumulative sum of the 100 numbers: `cumsum()`
3. Check if the cumulative sum is greater than 1: `which(cumsum() > 1, TRUE)`
4. Find the minimum position that meets the criterion: `min()`
5. Replicate that process ten million times: `replicate(10^7, )`
6. Take the average of all the positions: `mean()`

Half a tweet to solve the problem. Look, ma. No explicit loops!

![A half-tweet long code solution.](/assets/images/vectorisation.png)