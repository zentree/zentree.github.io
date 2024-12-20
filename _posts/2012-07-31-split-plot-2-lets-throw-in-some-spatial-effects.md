---
id: 1169
title: 'Split-plot 2: let&#8217;s throw in some spatial effects'
date: '2012-07-31T13:48:17+12:00'
mathjax: true
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1169'
permalink: /2012/07/31/split-plot-2-lets-throw-in-some-spatial-effects/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/07/gargoyle.jpg
tags:
    - stats
---

Disappeared for a while collecting frequent flyer points. In the process I ‘discovered’ that I live [in the middle of nowhere](https://maps.google.co.nz/maps?q=Christchurch,+Canterbury&hl=en&ll=-43.580391,172.617188&spn=171.212657,59.0625&sll=-43.068888,171.914063&sspn=171.285878,59.0625&oq=chris&hnear=Christchurch,+Canterbury&t=m&z=2), as it took me 36 hours to reach my conference destination (Estoril, Portugal) through Christchurch, Sydney, Bangkok, Dubai, Madrid and Lisbon.

Where was I? Showing how [split-plots look like under the bonnet](/2012/06/split-plot-1-how-does-a-linear-mixed-model-look-like/) (hood for you US readers). Yates presented a nice diagram of his oats data set in the paper, so we have the spatial location of each data point which permits us playing with within-trial spatial trends.

Rather than mucking around with typing coordinates we can rely on Kevin Wright’s version of the oats dataset contained in the [agridat package](http://cran.r-project.org/web/packages/agridat/index.html). Kevin is a man of mystery, a James Bond of statisticians—so he keeps a low profile—with a keen interest in experimental design and analyses. This chap has put a really nice collection of data sets WITH suggested coding for the analyses, including nlme, lme4, asreml, MCMCglmm and a few other bits and pieces. Recommended!

Plants ([triffids](http://en.wikipedia.org/wiki/Triffid) excepted) do not move, which means that environmental trends within a trial (things like fertility, water availability, temperature, etc) can affect experimental units in a way that varies with space and which induces correlation of the residuals. Kind of we could be violating the independence assumption if you haven’t got the hint yet.

![Gratuitous picture: Detail of Mosteiro dos Jerónimos, Belém, Lisboa.](/assets/images/gargoyle.jpg)

There are a few ways to model environmental trends (AR processes, simple polynomials, splines, etc) that can be accounted for either through the G matrix (as random effects) or the R matrix. See previous post for explanation of the bits and pieces. We will use here a very popular approach, which is to consider two separable (so we can estimate the bloody things) autoregressive processes, one for rows and one for columns, to model spatial association. In addition, we will have a spatial residual. In summary, the residuals have moved from $$\mathbf{R} = \sigma^2_e \mathbf{I}$$ to $$\mathbf{R} = \sigma^2_s \mathbf{R}_{col} \otimes \mathbf{R}_{row}$$. I previously showed the general form of this autoregressive matrices [in this post](/2011/10/covariance-structures/), and you can see the $$\mathbf{R}_{col}$$ matrix below. In some cases we can also add an independent residual (the so-called nugget) to the residual matrix.

We will first fit a split-plot model considering spatial residuals using `asreml` because, let’s face it, there is no other package that will give you the flexibility:

```r
library(asreml)
library(agridat)

# Having a look at the structure of yates.oats
# and changing things slightly so it matches
# previous post
str(yates.oats)

names(yates.oats) <- c('row', 'col', 'Y', 'N', 'V', 'B')

yates.oats$row <- factor(yates.oats$row)
yates.oats$col <- factor(yates.oats$col)
yates.oats$N <- factor(yates.oats$N)
yates.oats$MP <- yates.oats$V

# Base model (this was used in the previous post)
m2 <- asreml(Y ~ V*N, random = ~ B/MP, data = yates.oats)
summary(m2)$varcomp
#                gamma component std.error  z.ratio constraint
# B!B.var    1.2111647  214.4771 168.83404 1.270343   Positive
# B:MP!B.var 0.5989373  106.0618  67.87553 1.562593   Positive
# R!variance 1.0000000  177.0833  37.33244 4.743416   Positive

# Spatial model
m3 <- asreml(Y ~ V*N, random = ~ B/MP,
             rcov = ~ ar1(col):ar1(row),
             data = yates.oats)
summary(m3)$varcomp
#                 gamma    component   std.error   z.ratio    constraint
# B!B.var    0.80338277 169.24347389 156.8662436 1.0789031      Positive
# B:MP!B.var 0.49218005 103.68440202  73.6390759 1.4080079      Positive
# R!variance 1.00000000 210.66355939  67.4051020 3.1253355      Positive
# R!col.cor  0.04484166   0.04484166   0.2006562 0.2234751 Unconstrained
# R!row.cor  0.49412567   0.49412567   0.1420397 3.4787860 Unconstrained

coef(m3)$fixed
coef(m3)$random
# effect
# V_GoldenRain:N_0     0.0000000
# V_GoldenRain:N_0.2   0.0000000
# V_GoldenRain:N_0.4   0.0000000
# V_GoldenRain:N_0.6   0.0000000
# V_Marvellous:N_0     0.0000000
# V_Marvellous:N_0.2  -0.8691155
# V_Marvellous:N_0.4 -12.4223873
# V_Marvellous:N_0.6  -5.5018907
# V_Victory:N_0        0.0000000
# V_Victory:N_0.2     -1.9580360
# V_Victory:N_0.4      2.1913469
# V_Victory:N_0.6      0.3728648
# N_0                  0.0000000
# N_0.2               23.3299154
# N_0.4               40.0570745
# N_0.6               47.1749577
# V_GoldenRain         0.0000000
# V_Marvellous         9.2845952
# V_Victory           -5.7259866
# (Intercept)         76.5774292

# effect
# B_B1               21.4952875
# B_B2                1.0944484
# B_B3               -5.4336461
# B_B4               -4.4334455
# B_B5               -6.6925874
# B_B6               -6.0300569
# B_B1:MP_GoldenRain  1.3036724
# B_B1:MP_Marvellous -0.9082462
# B_B1:MP_Victory    12.7754283
# B_B2:MP_GoldenRain  1.3286187
# B_B2:MP_Marvellous  7.4181674
# B_B2:MP_Victory    -8.0761824
# B_B3:MP_GoldenRain -6.5288220
# B_B3:MP_Marvellous 10.4361799
# B_B3:MP_Victory    -7.2367277
# B_B4:MP_GoldenRain  6.6868810
# B_B4:MP_Marvellous -9.2317585
# B_B4:MP_Victory    -0.1716372
# B_B5:MP_GoldenRain  2.4635492
# B_B5:MP_Marvellous -9.7086196
# B_B5:MP_Victory     3.1443067
# B_B6:MP_GoldenRain -5.2538993
# B_B6:MP_Marvellous  1.9942770
# B_B6:MP_Victory    -0.4351876

# In a larger experiment we could try fitting a nugget using units
m4 <- asreml(Y ~ V*N, random = ~ B/MP + units,
             rcov = ~ ar1(col):ar1(row),
             data = yates.oats)
summary(m4)

# However in this small experiments the system
# goes crazy and results meaningless
#                       gamma   component  std.error  z.ratio constraint
# B!B.var         0.006759124   223.70262   185.3816 1.206714   Positive
# B:MP!B.var      0.001339017    44.31663    29.2004 1.517672   Positive
# units!units.var 0.003150356   104.26542    34.2738 3.042132   Positive
# R!variance      1.000000000 33096.39128 19480.8333 1.698921   Positive
# R!col.cor       0.999000000     0.99900         NA       NA      Fixed
# R!row.cor       0.999000000     0.99900         NA       NA      Fixed
``` 

So we have to build an autoregressive correlation matrix for rows, one for columns and multiply the whole thing for a spatial variance. Then we can add an independent residual (the nugget, if we want—and can estimate—one). Peter Dalgaard has [neat code](http://tolstoy.newcastle.edu.au/R/e2/help/07/05/16585.html) for building the autocorrelation matrix. And going back to [the code in the previous post](/2012/06/split-plot-1-how-does-a-linear-mixed-model-look-like/):

```r
ar.matrix <- function(ar, dim) {
  M <- diag(dim)
  M <- ar^abs(row(M)-col(M))
return(M)
}

# Variance components (from m3)
varB <- 169.243
varMP <- 103.684
varR <- 210.664
arcol <- 0.045
arrow <- 0.494

# Basic vector and matrices: y, X, Z, G & R
y <- matrix(yates.oats$Y, nrow = dim(yates.oats)[1], ncol = 1)
X <- model.matrix(~ V*N, data = yates.oats)
Z <- model.matrix(~ B/MP - 1, data = yates.oats,
                  contrasts.arg = list(B = contrasts(yates.oats$B, contrasts = F),
MP <- contrasts(yates.oats$MP, contrasts = F)))

G <- diag(c(rep(varB, 6), rep(varMP, 18)))

# Only change from previous post is building the R matrix
Rcol <- ar.matrix(arcol, 4)
Rrow <- ar.matrix(arrow, 18)
Rcol
# Having a look at the structure
#            [,1]     [,2]     [,3]       [,4]
# [1,] 1.0000e+00 0.045000 0.002025 9.1125e-05
# [2,] 4.5000e-02 1.000000 0.045000 2.0250e-03
# [3,] 2.0250e-03 0.045000 1.000000 4.5000e-02
# [4,] 9.1125e-05 0.002025 0.045000 1.0000e+00

R <- varR * kronecker(Rcol, Rrow)
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
#                         [,1]
# (Intercept)       76.5778238
# VMarvellous        9.2853002
# VVictory          -5.7262894
# N0.2              23.3283060
# N0.4              40.0555464
# N0.6              47.1740348
# VMarvellous:N0.2  -0.8682597
# VVictory:N0.2     -1.9568979
# VMarvellous:N0.4 -12.4200362
# VVictory:N0.4      2.1912083
# VMarvellous:N0.6  -5.5017225
# VVictory:N0.6      0.3732453
# BB1               21.4974445
# BB2                1.0949433
# BB3               -5.4344098
# BB4               -4.4333080
# BB5               -6.6948783
# BB6               -6.0297918
# BB1:MPGoldenRain   1.3047656
# BB2:MPGoldenRain   1.3294043
# BB3:MPGoldenRain  -6.5286993
# BB4:MPGoldenRain   6.6855568
# BB5:MPGoldenRain   2.4624436
# BB6:MPGoldenRain  -5.2534710
# BB1:MPMarvellous  -0.9096022
# BB2:MPMarvellous   7.4170634
# BB3:MPMarvellous  10.4349240
# BB4:MPMarvellous  -9.2293528
# BB5:MPMarvellous  -9.7080694
# BB6:MPMarvellous   1.9950370
# BB1:MPVictory     12.7749000
# BB2:MPVictory     -8.0756682
# BB3:MPVictory     -7.2355284
# BB4:MPVictory     -0.1721988
# BB5:MPVictory      3.1441163
# BB6:MPVictory     -0.4356209
```

Which are the same results one gets from ASReml-R. QED.

P.S. Many thanks to Kevin Wright for answering my questions about agridat.