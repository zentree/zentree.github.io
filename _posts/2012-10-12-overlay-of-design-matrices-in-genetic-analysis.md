---
id: 1477
title: 'Overlay of design matrices in genetic analysis'
date: '2012-10-12T22:13:33+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1477'
permalink: /2012/10/12/overlay-of-design-matrices-in-genetic-analysis/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

I’ve ignored my quantitative geneticist side of things for a while (at least in this blog) so this time I’ll cover some code I was exchanging with a couple of colleagues who work for other organizations.

It is common to use diallel mating designs in plant and tree breeding, where a small number of parents acts as both males and females. For example, with 5 parents we can have 25 crosses, including reciprocals and selfing (crossing an individual with itself). Decades ago this mating design was tricky to fit and, considering an experimental layout with randomized complete blocks, one would have something like `y = mu + blocks + dads + mums + cross + error`. In this model dads and mums were estimating a fraction of the additive genetic variance. With the advent of animal model BLUP, was possible to fit something like `y = mu + blocks + individual (using a pedigree) + cross + error`. Another less computationally demanding alternative (at least with unrelated parents) is to fit a parental model, overlaying the design matrices for parents with something like this `y = mu + blocks + (dad + mum) + cross + error`.

The following code simulate data for a a diallel trial with three replicates and runs a parental model with ASReml. Later I expand the analysis building the matrices by hand.

```r
# Defining diallel cross
n.blocks <- 3
diallel <- matrix(0, nrow = 5, ncol = 5)
males <- 1:dim(diallel)[1]
females <- 1:dim(diallel)[2]
cross <- factor(outer(males, females, paste, sep ='x'))
cross
#[1] 1x1 2x1 3x1 4x1 5x1 1x2 2x2 3x2 4x2 5x2 1x3 2x3 3x3 4x3 5x3 1x4 2x4
#[18] 3x4 4x4 5x4 1x5 2x5 3x5 4x5 5x5
#25 Levels: 1x1 1x2 1x3 1x4 1x5 2x1 2x2 2x3 2x4 2x5 3x1 3x2 3x3 ... 5x5


#### Generating random values for the trial
# Variance components
sig2.a <- 40    # additive genetic variance
sig2.sca <- 10  # specific combining ability (SCA)
sig2.b <- 10    # blocks
sig2.e <- 30    # residuals

# Numbers of everything
n.parents <- length(males)
n.crosses <- length(cross)
n.trees <- n.crosses*n.blocks

# Random values for everything
u.g <- rnorm(n.parents)*sqrt(sig2.a)
u.sca <- rnorm(n.crosses)*sqrt(sig2.sca)
u.block <- rnorm(n.blocks)*sqrt(sig2.b)
u.e <- rnorm(n.trees)*sqrt(sig2.e)

# Whole trial
trial <- data.frame(block = factor(rep(1:n.blocks, each = n.crosses)),
                    mum = factor(rep(females, n.blocks)),
                    dad = factor(rep(males, each = length(females))),
                    mate = factor(rep(cross, n.blocks)))

trial$yield <- 0.5*(u.g[trial$mum] + u.g[trial$dad]) +
               u.sca[trial$mate] + u.block[trial$block] + u.e

head(trial)
#block mum dad mate       yield
#1     1   1   1  1x1 -0.02185486
#2     1   2   1  2x1 10.79760712
#3     1   3   1  3x1 16.45186037
#4     1   4   1  4x1  8.15026291
#5     1   5   1  5x1  5.57707180
#6     1   1   2  1x2 -7.30675148

# Fitting the model with ASReml
library(asreml)
m1 <- asreml(yield ~ 1,
             random = ~ block + dad + and(mum) + mate,
             data = trial)
summary(m1)
#                       gamma    component    std.error   z.ratio
#block!block.var 1.299110e-02 3.861892e-01 1.588423e+00 0.2431274
#dad!dad.var     2.101417e-01 6.246930e+00 5.120745e+00 1.2199259
#mate!mate.var   4.589938e-07 1.364461e-05 2.340032e-06 5.8309519
#R!variance      1.000000e+00 2.972722e+01 5.098177e+00 5.8309519

# Obtaining the predicted breeding values for the parents
coef(m1, pattern = 'dad')
#         effect
#dad_1  1.780683
#dad_2 -2.121174
#dad_3  3.151991
#dad_4 -1.473620
#dad_5 -1.337879
```

How is the matrix overlay working? We can replicate the calculations used by ASReml by building the matrices from scratch and reusing the variance components, so we avoid the nastiness of writing code for residual maximum likelihood. Once I build the basic matrices I use the code from my <a href="/2012/06/split-plot-1-how-does-a-linear-mixed-model-look-like/">How does a linear mixed model look like?</a> post.

```r
# Building incidence matrices for males and females
Zmales <- model.matrix(~ dad - 1, data = trial)
Zfemales <- model.matrix(~ mum - 1, data = trial)

# and() in ASReml overlays (i.e. sums) the matrices
# (Notice that this creates 0s, 1 and 2s in the design matrix)
Zparents <- Zmales + Zfemales
Zparents[1:6,]
#   dad1 dad2 dad3 dad4 dad5
#1     2    0    0    0    0
#2     1    1    0    0    0
#3     1    0    1    0    0
#4     1    0    0    1    0
#5     1    0    0    0    1
#6     1    1    0    0    0

# Design matrices from other factors
Zblocks <- model.matrix(~ block - 1, data = trial)
Zmates <- model.matrix(~ mate - 1, data = trial)

# Creating y, X and big Z matrices to solve mixed model equations
y <- trial$yield
X <- matrix(1, nrow = 75, ncol = 1)
Z <- cbind(Zblocks, Zparents, Zmates)

# Building covariance matrices for random effects
# Using the variance components from the ASReml model
G <- diag(c(rep(3.861892e-01, 3),
            rep(6.246930e+00, 5),
            rep(1.364461e-05, 25)))

R <- diag(2.972722e+01, 75, 75)
Rinv <- solve(R)

# Components of C
XpX <- t(X) %*% Rinv %*% X
ZpZ <- t(Z) %*% Rinv %*% Z

XpZ <- t(X) %*% Rinv %*% Z
ZpX <- t(Z) %*% Rinv %*% X

Xpy <- t(X) %*% Rinv %*% y
Zpy <- t(Z) %*% Rinv %*% y

# Building C * [b a] = RHS
C <- rbind(cbind(XpX, XpZ),
           cbind(ZpX, ZpZ + solve(G)))

RHS <- rbind(Xpy, Zpy)

blup <- solve(C, RHS)
blup
# These results are identical to the ones
# produced by ASReml
#dad1     1.780683e+00
#dad2    -2.121174e+00
#dad3     3.151991e+00
#dad4    -1.473620e+00
#dad5    -1.337879e+00
```

The overlay matrix Zparents is double the actual value we should use:

```r
Zparents2 <- 0.5*(Zmales + Zfemales)
Zparents2[1:6,]
#  dad1 dad2 dad3 dad4 dad5
#1  1.0  0.0  0.0  0.0  0.0
#2  0.5  0.5  0.0  0.0  0.0
#3  0.5  0.0  0.5  0.0  0.0
#4  0.5  0.0  0.0  0.5  0.0
#5  0.5  0.0  0.0  0.0  0.5
#6  0.5  0.5  0.0  0.0  0.0
```

Repeating the analyses 'by hand' using <code>Zparents2</code> to build the Z matrix results in the same overall mean and block effects, but the predicted breeding values for parents when using <code>Zparents</code> are 0.7 of the predicted breeding values for parents when using <code>Zparents2</code>. I may need to refit the model and obtain new variance components for parents when working with the correct overlaid matrix.

![Gratuitous picture: walking in Quail Island](/assets/images/quail-island.jpg)