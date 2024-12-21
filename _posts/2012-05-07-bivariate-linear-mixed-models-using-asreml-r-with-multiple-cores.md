---
id: 1053
title: 'Bivariate linear mixed models using ASReml-R with multiple cores'
date: '2012-05-07T22:39:18+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1053'
permalink: /2012/05/07/bivariate-linear-mixed-models-using-asreml-r-with-multiple-cores/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/05/firescapes-I.jpg
tags:
    - stats
---

A while ago I wanted to run a quantitative genetic analysis where the performance of genotypes in each site was considered as a different trait. If you think about it, with 70 sites and thousands of genotypes one is trying to fit a 70×70 additive genetic covariance matrix, which requires 70\*69/2 = 2,415 covariance components. Besides requiring huge amounts of memory and being subject to all sort of estimation problems there were all sort of connectedness issues that precluded the use of Factor Analytic models to model the covariance matrix. The best next thing was to run over 2,000 bivariate analyses to build a large genetic correlation matrix (which has all sort of issues, I know). This meant leaving the computer running for over a week.

In another unrelated post, Kevin asked [about this post](/2012/02/rstudio-and-asreml-working-together-in-a-mac) if I have ever considered using ASReml-R to run in parallel using a computer with multiple cores. Short answer, I haven’t, but there is always a first time.

```r
library(asreml) # Multivariate mixed models
library(doMC)   # To access multiple cores

registerDoMC()  # to start a "parallel backend"

# Read basic density data
setwd('~/Dropbox/quantumforest')
# Phenotypes
dat <- read.table('density09.txt', header = TRUE)

dat <- within(dat, {
  FCLN <- factor(FCLN)
  MCLN <- factor(MCLN)
  REP <- factor(REP)
  SETS <- factor(SETS)
  FAM <- factor(FAM)
  CP <- factor(CP)
  Tree_id <- factor(Tree_id)
}

head(dat)

# Pedigree
ped <- read.table('pedigree.txt', header = TRUE)
names(ped)[1] <- 'Tree_id'
ped <- within(ped, {
  Tree_id <- factor(Tree_id)
  Mother <- factor(Mother)
  Father <- factor(Father)
}

# Inverse of the numerator relationship matrix
Ainv <- asreml.Ainverse(ped)$ginv

# Wrap call to a generic bivariate analysis
# (This one uses the same model for all sites
#  but it doesn't need to be so)
bivar <- function(trial1, trial2) {
  t2 <- dat[dat$Trial_id == trial1 | dat$Trial_id == trial2,]
  t2$den1 <- ifelse(t2$Trial_id == trial1, t2$DEN, NA)
  t2$den2 <- ifelse(t2$Trial_id == trial2, t2$DEN, NA)
  t2$Trial_id <- t2$Trial_id[drop = TRUE]

  # Bivariate run
  # Fits overall mean, random correlated additive effects with
  # heterogeneous variances and diagonal matrix for heterogeneous
  # residuals
  den.bi <-  asreml(cbind(den1,den2) ~ trait,
                    random = ~ ped(Tree_id):corgh(trait),
                    data = t2,
                    ginverse = list(Tree_id = Ainv),
                    rcov = ~ units:diag(trait),
                    workspace = 64e06, maxiter=30)

# Returns only log-Likelihood for this example
  return(summary(den.bi)$loglik)
}

# Run the bivariate example in parallel for two pairs of sites
# FR38_1 with FR38_2, FR38_1 with FR38_3
foreach(trial1=rep("FR38_1",2), trial2=c("FR38_2", "FR38_3")) %dopar%
bivar(trial1, trial2)
```

The code runs in my laptop (only two cores) but I still have to test its performance in my desktop (4 cores) and see if it really makes a difference in time versus running the analyses sequentially. Initially my mistake was using the multicore package (`library(multicore)`) directly, which doesn't start the 'parallel backend' and ran sequentially. Using `library(doMC)` loads multicore but takes care of starting the 'parallel backend'.

![Gratuitous picture: Trees at 8 pm illuminated by bonfire and full moon, Canterbury.](/assets/images/firescapes-i.jpg)

P.S. Thanks to [Etienne Laliberté](https://irbv.umontreal.ca/le-personnel/etienne-laliberte/?lang=en), who sent me an email in early 2010 pointing out that I had to use doMC. One of the few exceptions in the pile of useless emails I have archived.

P.S.2. If you want to learn more about this type of models I recommend two books: Mrode's [Linear Models for the Prediction of Animal Breeding Values](https://www.librarything.com/work/2539148/book/12394060), which covers multivariate evaluation with lots of gory details, and Lynch and Walsh's [Genetics and Analysis of Quantitative Traits](https://www.librarything.com/work/590816/book/24599091), which is the closest thing to the bible in quantitative genetics.

P.S.3. `2012-05-08.` I did run the code in my desktop (iMac with 4 cores), making a couple of small changes in the code to have a fairer comparison between using `%dopar%` (for parallel code) and `%par%` (for sequential execution).

1. Added `trace = FALSE` to the `asreml()` call, to avoid printing partial iteration details to the screen, which happened when using `%do%`
2. Used 4 pairs of sites, so I could utilize all cores in my desktop.</li>

Execution time for the parallel version—measured with `Sys.time()`—was, roughly, 1/(number of cores) the time required by the sequential version.