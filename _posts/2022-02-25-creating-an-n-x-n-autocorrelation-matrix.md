---
id: 3564
title: 'Creating an n x n autocorrelation matrix'
date: '2022-02-25T21:29:25+13:00'
author: Luis
layout: post
guid: 'https://www.quantumforest.com/?p=3564'
permalink: /2022/02/25/creating-an-n-x-n-autocorrelation-matrix/
classic-editor-remember:
    - classic-editor
image: /wp-content/uploads/2022/02/portugal.jpg
tags:
    - programming
    - stats
---

Between covid-19 news and announcements of imminent Russia-Ukraine wars I needed a bit of a distraction. Sooo, here it is how to create an n x n autocorrelation matrix based on a correlation `rho`, with a simple 5 x 5 example in R:

```R
n <- 5
rho <- 0.9
mat <- diag(n)
mat <- rho^abs(row(mat) - col(mat))
```

This produces the following output:

```R
       [,1]  [,2] [,3]  [,4]   [,5]
[1,] 1.0000 0.900 0.81 0.729 0.6561
[2,] 0.9000 1.000 0.90 0.810 0.7290
[3,] 0.8100 0.900 1.00 0.900 0.8100
[4,] 0.7290 0.810 0.90 1.000 0.9000
[5,] 0.6561 0.729 0.81 0.900 1.0000
```

How does this work? Starting from defining n as 5, and the basic rho correlation as 0.9, then `mat <- diag(n)` creates a diagonal matrix—a square matrix with ones in the diagonal and zeros elsewhere—with 5 rows and 5 columns.

```
     [,1] [,2] [,3] [,4] [,5]
[1,]    1    0    0    0    0
[2,]    0    1    0    0    0
[3,]    0    0    1    0    0
[4,]    0    0    0    1    0
[5,]    0    0    0    0    1
```

Looking at the final line of code, we have that `row(mat)` and `col(mat)` create matrices with the row or col coordinates for each location:

```R
> row(mat)
     [,1] [,2] [,3] [,4] [,5]
[1,]    1    1    1    1    1
[2,]    2    2    2    2    2
[3,]    3    3    3    3    3
[4,]    4    4    4    4    4
[5,]    5    5    5    5    5

> col(mat)
     [,1] [,2] [,3] [,4] [,5]
[1,]    1    2    3    4    5
[2,]    1    2    3    4    5
[3,]    1    2    3    4    5
[4,]    1    2    3    4    5
[5,]    1    2    3    4    5
```

Then `abs(row(mat) - col(mat))` is telling us how far is each cell in the matrix from the diagonal. We use that distance as an exponent for rho (0.9 in our example).

```R
> abs(row(mat) - col(mat))
     [,1] [,2] [,3] [,4] [,5]
[1,]    0    1    2    3    4
[2,]    1    0    1    2    3
[3,]    2    1    0    1    2
[4,]    3    2    1    0    1
[5,]    4    3    2    1    0
```

Putting it all together, `rho^abs(row(mat) - col(mat))` produces:

```R
> rho^abs(row(mat) - col(mat))
       [,1]  [,2] [,3]  [,4]   [,5]
[1,] 1.0000 0.900 0.81 0.729 0.6561
[2,] 0.9000 1.000 0.90 0.810 0.7290
[3,] 0.8100 0.900 1.00 0.900 0.8100
[4,] 0.7290 0.810 0.90 1.000 0.9000
[5,] 0.6561 0.729 0.81 0.900 1.0000
```

![Street in old neighbourhood, Lisbon.](/assets/images/portugal.jpg)