---
id: 94
title: 'Simulating data following a given covariance structure'
date: '2011-10-13T07:00:02+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=94'
permalink: /2011/10/13/simulating-data-following-a-given-covariance-structure/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

Every year there is at least a couple of occasions when I have to simulate multivariate data that follow a given covariance matrix. For example, let’s say that we want to create an example of the effect of collinearity when fitting multiple linear regressions, so we want to create one variable (the response) that is correlated with a number of explanatory variables **and** the explanatory variables have different correlations with each other.

There is a matrix operation called [Cholesky decomposition](http://en.wikipedia.org/wiki/Cholesky_decomposition), sort of equivalent to taking a square root with scalars, that is useful to produce correlated data. If we have a covariance matrix `M`, the Cholesky descomposition is a lower triangular matrix `L`, such as that `M = L L'`. How does this connect to our simulated data? Let’s assume that we generate a vector `z` of random normally independently distributed numbers with mean zero and variance one (with length equal to the dimension of M), we can create a realization of our multivariate distribution using the product `L z`.

The reason why this works is that the `Variance(L z) = L Variance(z) L'` as `L` is just a constant. The variance of `z` is the identity matrix `I`; remember that the random numbers have variance one and are independently distributed. Therefore `Variance(L z) = L I L' = L L` = M` so, in fact, we are producing random data that follow the desired covariance matrix.

As an example, let’s simulate 100 observations with 4 variables. Because we want to simulate 100 realizations, rather than a single one, it pays to generate a matrix of random numbers with as many rows as variables to simulate and as many columns as observations to simulate.

```r
library(lattice) # for splom
library(car)     # for vif

# number of observations to simulate
nobs <- 100

# Using a correlation matrix (let' assume that all variables
# have unit variance
M <- matrix(c(1, 0.7, 0.7, 0.5,
              0.7, 1, 0.95, 0.3,
              0.7, 0.95, 1, 0.3,
              0.5, 0.3, 0.3, 1), nrow=4, ncol=4)

# Cholesky decomposition
L <- chol(M)
nvars <- dim(L)[1]


# R chol function produces an upper triangular version of L
# so we have to transpose it.
# Just to be sure we can have a look at t(L) and the
# product of the Cholesky decomposition by itself

t(L)

[,1]       [,2]        [,3]      [,4]
[1,]  1.0  0.0000000  0.00000000 0.0000000
[2,]  0.7  0.7141428  0.00000000 0.0000000
[3,]  0.7  0.6441288  0.30837970 0.0000000
[4,]  0.5 -0.0700140 -0.01589586 0.8630442

t(L) %*% L

[,1] [,2] [,3] [,4]
[1,]  1.0 0.70 0.70  0.5
[2,]  0.7 1.00 0.95  0.3
[3,]  0.7 0.95 1.00  0.3
[4,]  0.5 0.30 0.30  1.0


# Random variables that follow an M correlation matrix
r <- t(L) %*% matrix(rnorm(nvars*nobs), nrow=nvars, ncol=nobs)
r <- t(r)

rdata <- as.data.frame(r)
names(rdata) <- c('resp', 'pred1', 'pred2', 'pred3')

# Plotting and basic stats
splom(rdata)
cor(rdata)

# We are not that far from what we want to simulate!
resp     pred1     pred2     pred3
resp  1.0000000 0.7347572 0.7516808 0.3915817
pred1 0.7347572 1.0000000 0.9587386 0.2841598
pred2 0.7516808 0.9587386 1.0000000 0.2942844
pred3 0.3915817 0.2841598 0.2942844 1.0000000
```

Now we can use the simulated data to learn something about the effects of collinearity when fitting multiple linear regressions. We will first fit two models using two predictors with low correlation between them, and then fit a third model with three predictors where `pred1` and `pred2` are highly correlated with each other.

```r
# Model 1: predictors 1 and 3 (correlation is 0.28)
m1 <- lm(resp ~ pred1 + pred3, rdata) 
summary(m1) 
Coefficients: Estimate Std. Error t value Pr(>|t|)
(Intercept)  0.07536    0.06812   1.106  0.27133
pred1        0.67316    0.06842   9.838 2.99e-16 ***
pred3        0.20920    0.07253   2.884  0.00483 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.6809 on 97 degrees of freedom
Multiple R-squared: 0.5762,    Adjusted R-squared: 0.5675
F-statistic: 65.95 on 2 and 97 DF,  p-value: < 2.2e-16

# Model 2: predictors 2 and 3 (correlation is 0.29)
m2 <- lm(resp ~ pred2 + pred3, rdata) 
summary(m2) 
Coefficients: Estimate Std. Error t value Pr(>|t|)
(Intercept)  0.06121    0.06649   0.921  0.35953
pred2        0.68513    0.06633  10.329  < 2e-16 ***
pred3        0.19624    0.07097   2.765  0.00681 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.6641 on 97 degrees of freedom
Multiple R-squared: 0.5968,    Adjusted R-squared: 0.5885
F-statistic: 71.79 on 2 and 97 DF,  p-value: < 2.2e-16

# Model 3: correlation between predictors 1 and 2 is 0.96
m3 <- lm(resp ~ pred1 + pred2 + pred3, rdata) 
summary(m3) 
Coefficients: Estimate Std. Error t value Pr(>|t|)
(Intercept)  0.06421    0.06676   0.962  0.33856
pred1        0.16844    0.22560   0.747  0.45712
pred2        0.52525    0.22422   2.343  0.02122 *
pred3        0.19584    0.07114   2.753  0.00706 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.6657 on 96 degrees of freedom
Multiple R-squared: 0.5991,    Adjusted R-squared: 0.5866
F-statistic: 47.83 on 3 and 96 DF,  p-value: < 2.2e-16


# Variance inflation
vif(m3)

pred1     pred2     pred3
12.373826 12.453165  1.094875
```

In my example it is possible to see the huge increase for the standard error for `pred1` and `pred2`, when we use both highly correlated explanatory variables in model 3. In addition, model fit does not improve for model 3.