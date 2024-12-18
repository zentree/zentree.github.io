---
id: 1542
title: 'Multisite, multivariate genetic analysis: simulation and analysis'
date: '2012-12-14T10:48:50+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1542'
permalink: /2012/12/14/multisite-multivariate-genetic-analysis-simulation-and-analysis/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - breeding
    - stats
---

The email wasn’t a challenge but a simple question: Is it possible to run a multivariate analysis in multiple sites? I was going to answer yes, of course, and leave it there but it would be a cruel, non-satisfying answer. We can get a better handle of the question if we use a simple example; let’s assume that we have two traits (call them tree stem diameter and stem density) assessed in two sites (localities).

Because this is genetics we have a family structure, let’s say half-siblings so we only half the mother in common, and we will ignore any experimental design features to keep things simple. We have 100 families, with 30 trees each, in sites A and B, for a total of 6,000 trees (100 x 30 x 2). The data could look like this:

```
site family tree diam dens
A     1     1   20    398
A     1     2   19    400
...
A    100   30   24    375
...
B     1    1    25    396
...
B    100   30   23    403
```

We can also think of a trait measured in two sites as separate, but correlated, traits. For example, diameter in site 1 (diam1) is a different variable from diameter in site 2 (diam 2). So now we have four response variables (diam1, dens1, diam2, dens2), two of which have only missing values in a given site:

```
site family tree diam1 dens1 diam2 dens2
A     1     1    20    398   NA    NA
A     1     2    19    400   NA    NA
...
A    100   30    24    375   NA    NA
...
B      1    1    NA    NA    25    396
...
B    100   30    NA    NA    23    403
```

All variables are correlated at the genetic level with an unstructured G covariance matrix, while at the residual level are only correlated within-site (same tree was assessed for both traits), but there is zero correlation between sites, because one could be assessed [near Christchurch](https://maps.google.co.nz/maps?q=-45.993913,%09170.195372&hl=en&ll=-43.620637,172.347143&spn=0.010547,0.022724&sll=-36.863023,174.865469&sspn=0.746041,1.454315&t=h&z=16), while the other [near Dunedin](https://maps.google.co.nz/maps?q=-45.993913,%09170.195372&hl=en&ll=-45.995068,170.19423&spn=0.010122,0.022724&sll=-36.863023,174.865469&sspn=0.746041,1.454315&t=h&z=16), for example.

```r
###
### Data generation
###

# Simulate 100 half-sib families with 30 trees each
# for the four traits in two sites
n.fam <- 100
n.prog <- 30
n.trait <- 4
n.site <- 2

# Couple of variance matrices,
# G is for additive genetic effects
# R is for residuals
# All variances are assumed equal to 1 without loss
# of generality
G <- matrix(c(1, 0.7, 0.5, 0.3,
              0.7, 1, 0.2, 0.1,
              0.5, 0.2, 1, 0.8,
              0.3, 0.1, 0.8, 1), 4, 4)

R <- matrix(c(1, 0.3, 0, 0,
              0.3, 1, 0, 0,
              0, 0, 1, 0.2,
              0, 0, 0.2, 1), 4, 4)


# Between-family variances account for 1/4 of additive
# genetic effects. Within-family account for 3/4 of
# additive + residual.
# We also get the Cholesky decomposition in the same step
BFL <- chol(1/4 * G)
WFL <- chol(3/4 * G + R)

# Simulate random family effects for four traits
# Simulate random family effects for four traits
fam.eff <- t(BFL) %*% matrix(rnorm(n.fam*n.trait),
           n.trait, n.fam)
fam.eff <- t(fam.eff) # This is 100 x 4

tre.eff <- t(WFL) %*% matrix(rnorm(n.prog*n.fam*n.trait),
           n.trait, n.prog*n.fam)
tre.eff <- t(tre.eff) # This is 3000 x 4

# Expand family effects matrix (n.prog each) to match
# dimension of tree effects
pheno <- fam.eff[rep(1:dim(fam.eff)[1], each = n.prog),] + tre.eff

# Now to 2 sites
pheno2s <- matrix(NA, n.prog*n.fam*n.site, n.trait)
colnames(pheno2s) <- c('diam1', 'dens1', 'diam2', 'dens2')

pheno2s[1:3000, 1:2] <- pheno[1:3000, 1:2]
pheno2s[3001:6000, 3:4] <- pheno[1:3000, 3:4]

# Creating data set. Family and tree are shamelessly recycled
sim.data <- data.frame(site = factor(rep(c('A', 'B'), each = n.fam*n.prog)),
                       family = factor(rep(1:n.fam, each = n.prog)),
                       tree = factor(1:30),
                       pheno2s)
```

Some neat things:

- Data simulation relies on Cholesky decomposition, as explained [in this post](/2011/10/simulating-data-following-a-given-covariance-structure/) over a year ago (time flies!). Generation is a bit more complex this time because we have to account for two, rather than one, covariance structures.
- Another point with data simulation is that one could generate one set of correlated values at the time by using something like `t(BFL) %*% diag(rnorm(trait), 3)` and loop it or use `apply()`. This would require much less memory but would also be much slower.
- We need to repeat each line of the family effects matrix 30 times so we can add to the individual tree effects. Often we use indexing in matrices or data frames to extract a few rows. Instead here I'm using to repeat a given number of times each row by indexing with `rep()`.

If we show observations 2990 to 3010 (last 10 for site A and first 10 for site B) we can see the pattern of observations below, which will have the required structure to have a US (or heterogeneous variance correlation matrix) for G and a block diagonal matrix for R. By the way, one could also have block diagonal matrices with repeated measurements, although probably with a different correlation structure:

```r

> pheno2s[2990:3010,]
diam1      dens1      diam2       dens2
[1,]  0.57087250 -0.8521059         NA          NA
[2,]  0.94859621  0.6599391         NA          NA
[3,] -3.37405451 -0.6093312         NA          NA
[4,]  0.93541048 -0.7977893         NA          NA
[5,] -0.74758553  0.7962593         NA          NA
[6,]  0.51280201  1.4870425         NA          NA
[7,] -1.92571147 -0.2554365         NA          NA
[8,] -1.15923045 -2.0656582         NA          NA
[9,] -0.82145904 -0.3138340         NA          NA
[10,]  1.79631670  0.3814723         NA          NA
[11,] -0.01604778 -1.1804723         NA          NA
[12,]          NA         NA -0.1436143 -1.97628883
[13,]          NA         NA -2.7099687 -2.93832962
[14,]          NA         NA -2.5153420  0.73780760
[15,]          NA         NA  0.3084056  0.61696714
[16,]          NA         NA -0.2909500  0.78111864
[17,]          NA         NA -1.8629862 -2.19346309
[18,]          NA         NA  0.8673053 -0.07692884
[19,]          NA         NA -0.1459703  0.36981965
[20,]          NA         NA -0.7688851 -0.96765799
[21,]          NA         NA  0.6637173 -0.34924814
```

![Gratuitous picture: driving in rural Japan, the cultural value of wood and breaking preconceptions.](/assets/images/rural-japan.jpg)

For the analysis we will use [ASReml](http://asreml.com), which is the Pro option if you work in a breeding program and require solving much larger systems of equations than this tiny example (say 50-100 traits, large pedigrees, etc). Another option for playing with this small data set would be to use the `MCMCglmm` package, which also allows for multivariate evaluation of linear mixed models.

```r
###
### Multivariate analysis
###

require(asreml)

# Assuming zero correlation between traits (equivalent
# to four univariate analyses)
m1 <- asreml(cbind(diam1, dens1, diam2, dens2) ~ trait,
             random = ~ diag(trait):family,
             rcov = ~ units:diag(trait),
             data = sim.data)

summary(m1)$varcomp

#                                 gamma component  std.error   z.ratio constraint
#trait:family!trait.diam1.var 0.2571274 0.2571274 0.04524049  5.683569   Positive
#trait:family!trait.dens1.var 0.2265041 0.2265041 0.04059742  5.579274   Positive
#trait:family!trait.diam2.var 0.2383959 0.2383959 0.04185982  5.695102   Positive
#trait:family!trait.dens2.var 0.2567999 0.2567999 0.04459246  5.758818   Positive
#R!variance                   1.0000000 1.0000000         NA        NA      Fixed
#R!trait.diam1.var            1.8290472 1.8290472 0.04803313 38.078866   Positive
#R!trait.dens1.var            1.7674960 1.7674960 0.04641672 38.078866   Positive
#R!trait.diam2.var            1.6779793 1.6779793 0.04406589 38.078866   Positive
#R!trait.dens2.var            1.7028171 1.7028171 0.04471817 38.078866   Positive

# The multivariate analysis allowing for correlation
# is a bit more complex, so we start by generating
# a structure for starting values
m2.sv <- asreml(cbind(diam1, dens1, diam2, dens2) ~ trait,
                random = ~ corgh(trait):family,
                rcov = ~ units:us(trait),
                data = sim.data,
                start.values = TRUE)

# Now we'll constraint some R variance components
# to zero and fix them there. These are values for
# which we now they are 0
sv <- m2.sv$gammas.table
sv$Value[c 1="16," 2="18," 3="19)" language="(15,"][/c] <- 0
sv$Constraint[c 1="16," 2="18," 3="19)" language="(15,"][/c] <- 'F'

# Run the analyses with those constraints for the R matrix
# using the restricted values in R.param
m2 <- asreml(cbind(diam1, dens1, diam2, dens2) ~ trait,
             random = ~ corgh(trait):family,
             rcov = ~ units:us(trait, init = r.init),
             data = sim.data,
             R.param = sv)

summary(m2)$varcomp
#                                                 gamma   component  std.error
# trait:family!trait.dens1:!trait.diam1.cor 0.72535514 0.72535514 0.06381776
# trait:family!trait.diam2:!trait.diam1.cor 0.49100215 0.49100215 0.10067768
# trait:family!trait.diam2:!trait.dens1.cor 0.21445972 0.21445972 0.12085780
# trait:family!trait.dens2:!trait.diam1.cor 0.37476119 0.37476119 0.10975970
# trait:family!trait.dens2:!trait.dens1.cor 0.05221773 0.05221773 0.12439924
# trait:family!trait.dens2:!trait.diam2.cor 0.85356318 0.85356318 0.04321683
# trait:family!trait.diam1                  0.25712744 0.25712744 0.04524049
# trait:family!trait.dens1                  0.22650410 0.22650410 0.04059742
# trait:family!trait.diam2                  0.23839593 0.23839593 0.04185982
# trait:family!trait.dens2                  0.25679989 0.25679989 0.04459246
# R!variance                                1.00000000 1.00000000         NA
# R!trait.diam1:diam1                       1.82904721 1.82904721 0.04803313
# R!trait.dens1:diam1                       0.90450432 0.90450432 0.03737490
# R!trait.dens1:dens1                       1.76749598 1.76749598 0.04641672
# R!trait.diam2:diam1                       0.00000000 0.00000000         NA
# R!trait.diam2:dens1                       0.00000000 0.00000000         NA
# R!trait.diam2:diam2                       1.67797927 1.67797927 0.04406589
# R!trait.dens2:diam1                       0.00000000 0.00000000         NA
# R!trait.dens2:dens1                       0.00000000 0.00000000         NA
# R!trait.dens2:diam2                       0.71249532 0.71249532 0.03406354
# R!trait.dens2:dens2                       1.70281710 1.70281710 0.04471817
#
#                                              z.ratio    constraint
# trait:family!trait.dens1:!trait.diam1.cor 11.3660390 Unconstrained
# trait:family!trait.diam2:!trait.diam1.cor  4.8769710 Unconstrained
# trait:family!trait.diam2:!trait.dens1.cor  1.7744796 Unconstrained
# trait:family!trait.dens2:!trait.diam1.cor  3.4143789 Unconstrained
# trait:family!trait.dens2:!trait.dens1.cor  0.4197593 Unconstrained
# trait:family!trait.dens2:!trait.diam2.cor 19.7507102 Unconstrained
# trait:family!trait.diam1                   5.6835685      Positive
# trait:family!trait.dens1                   5.5792738      Positive
# trait:family!trait.diam2                   5.6951016      Positive
# trait:family!trait.dens2                   5.7588182      Positive
# R!variance                                        NA         Fixed
# R!trait.diam1:diam1                       38.0788655      Positive
# R!trait.dens1:diam1                       24.2008477      Positive
# R!trait.dens1:dens1                       38.0788655      Positive
# R!trait.diam2:diam1                               NA         Fixed
# R!trait.diam2:dens1                               NA         Fixed
# R!trait.diam2:diam2                       38.0788655      Positive
# R!trait.dens2:diam1                               NA         Fixed
# R!trait.dens2:dens1                               NA         Fixed
# R!trait.dens2:diam2                       20.9166565      Positive
# R!trait.dens2:dens2                       38.0788655      Positive
```

In model 1 each of the variances was supposed to be ~0.25 (1/4 * 1) and the residual variances ~1.75 (3/4*1 + 1). Once we move to model 2 we also get values similar to the correlations we were trying to simulate. And this is the end of the long answer.

P.S. If, for some bizarre reason, you would like to use SAS for this type of analyses, Fikret Isik has [proc mixed code](http://www4.ncsu.edu/~fisik/Multivariate.htm) to run multivariate genetic analyses.
