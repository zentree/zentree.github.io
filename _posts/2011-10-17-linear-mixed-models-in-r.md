---
id: 3608
title: 'Linear mixed models in R'
date: '2011-10-17T07:00:15+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=28'
permalink: /2011/10/17/linear-mixed-models-in-r/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - asreml
    - stats
---

A substantial part of my job has little to do with statistics; nevertheless, a large proportion of the statistical side of things relates to applications of linear mixed models. The bulk of my use of mixed models relates to the analysis of experiments that have a genetic structure.

## A brief history of time

At the beginning (1992-1995) I would use SAS (first `proc glm`, later `proc mixed`), but things started getting painfully slow and limiting if one wanted to move into animal model BLUP. At that time (1995-1996), I moved to DFREML (by Karen Meyer, now replaced by [WOMBAT](http://didgeridoo.une.edu.au/km/wombat.php)) and [AIREML](http://www.journalofdairyscience.org/article/S0022-0302(95)76654-1/abstract) (by Dave Johnson, now defunct—the program I mean), which were designed for the analysis of animal breeding progeny trials, so it was a hassle to deal with experimental design features. At the end of 1996 (or was it the beginning of 1997?) I started playing with [ASReml](https://vsni.co.uk/software/asreml-sa/) (programed by Arthur Gilmour mostly based on theoretical work by Robin Thompson and Brian Cullis). I was still using `SAS` for data preparation, but all my analyses went through `ASReml` (for which I wrote [the cookbook](https://asreml.kb.vsni.co.uk/knowledge-base/apiolaza-asreml-cookbook/)), which was orders of magnitude faster than `SAS` (and could deal with much bigger problems). Around 1999, I started playing with `R` (prompted by a suggestion from Rod Ball), but I didn’t *really* use `R/S+` often enough until 2003. At the end of 2005 I started using OS X and quickly realized that using a virtual machine or dual booting was not really worth it, so I dropped `SAS` and totally relied on `R` in 2009.

## Options

As for many other problems, there are several packages in R that let you deal with linear mixed models from a frequentist (REML) point of view. I will only mention nlme (Non-Linear Mixed Effects), lme4 (Linear Mixed Effects) and asreml (average spatial reml). There are also several options for Bayesian approaches, but that will be another post.

[nlme](http://cran.r-project.org/web/packages/nlme/index.html) is the most mature one and comes by default with any R installation. In addition to fitting hierarchical generalized linear mixed models it also allows fitting non-linear *mixed models following a Gaussian distribution* (my explanation wasn’t very clear, thanks to ucfagls below for pointing this out). Its main advantages are, in my humble opinion, the ability to fit fairly complex hierarchical models using linear or non-linear approaches, a good variety of variance and correlation structures, and access to several distributions and link functions for generalized models. In my opinion, its main drawbacks are i- fitting cross-classified random factors is a pain, ii- it can be slow and may struggle with lots of data, iii- it does not deal with pedigrees by default and iv- it does not deal with multivariate responses.

[lme4](http://cran.r-project.org/web/packages/lme4/index.html) is a project led by Douglas Bates (one of the co-authors of `nlme`), looking at modernizing the code and making room for trying new ideas. On the positive side, it seems to be a bit faster than nlme and it deals a lot better with cross-classified random factors. Drawbacks: similar to nlme’s, but dropping point i- and adding that it doesn’t deal with covariance and correlation structures yet. It is possible to fit pedigrees using the [pedigreemm](http://cran.r-project.org/web/packages/pedigreemm/index.html) package, but I find the combination a bit flimsy.

[ASReml-R](http://www.asreml.com) is, unsurprisingly, an R package interface to `ASReml`. On the plus side it i- deals well with cross-classified random effects, ii- copes very well with pedigrees, iii- can work with fairly large datasets, iv-can run multivariate analyses and v- covers a large number of covariance and correlation structures. Main drawbacks are i- limited functionality for non-Gaussian responses, ii- it does not cover non-linear models and iii- it is non-free (as in beer and speech). The last drawback is *relative*; it is possible to freely use asreml for academic purposes (and there is also a version for developing countries). Besides researchers, the main users of `ASReml/ASReml-R` are breeding companies.

All these three packages are available for Windows, Linux and OS X.

## A (very) simple example

I will use a traditional dataset to show examples of the notation for the three packages: Yates’ variety and nitrogen split-plot experiment. We can get the dataset from the MASS package, after which it is a good idea to rename the variables using meaningful names. In addition, I will follow Bill Venables’s [excellent advice](/assets/uploads/venables_split_plot_reply_s_news.txt) and create additional variables for main plot and subplots, as it is confusing to use the same factor for two purposes (e.g. variety as treatment and main plot). Incidentally, if you haven’t read Bill’s post go and read it; it is one of the best explanations I have ever seen for a split-plot analysis.

```r
library(MASS)
data(oats)
names(oats) <- c('block', 'variety', 'nitrogen', 'yield')
oats$mainplot <- oats$variety
oats$subplot <- oats$nitrogen

summary(oats)
block           variety     nitrogen      yield              mainplot
I  :12   Golden.rain:24   0.0cwt:18   Min.   : 53.0   Golden.rain:24
II :12   Marvellous :24   0.2cwt:18   1st Qu.: 86.0   Marvellous :24
III:12   Victory    :24   0.4cwt:18   Median :102.5   Victory    :24
IV :12                    0.6cwt:18   Mean   :104.0
V  :12                                3rd Qu.:121.2
VI :12                                Max.   :174.0
subplot
0.0cwt:18
0.2cwt:18
0.4cwt:18
0.6cwt:18
```

The nlme code for this analysis is fairly simple: response on the left-hand side of the tilde, followed by the fixed effects (variety, nitrogen and their interaction). Then there is the specification of the random effects (which also uses a tilde) and the data set containing all the data. Notice that `1|block/mainplot` is fitting block and mainplot within block. There is no reference to subplot as there is a single assessment for each subplot, which ends up being used at the residual level.

```r
library(nlme)
m1.nlme <- lme(yield ~ variety*nitrogen,
               random = ~ 1|block/mainplot,
               data = oats)

summary(m1.nlme)

Linear mixed-effects model fit by REML
Data: oats
AIC      BIC    logLik
\n559.0285 590.4437 -264.5143

Random effects:
Formula: ~1 | block
(Intercept)
StdDev:    14.64496

Formula: ~1 | mainplot %in% block
(Intercept) Residual
StdDev:    10.29863 13.30727

Fixed effects: yield ~ variety * nitrogen
Value Std.Error DF   t-value p-value
(Intercept)                      80.00000  9.106958 45  8.784492  0.0000
varietyMarvellous                 6.66667  9.715028 10  0.686222  0.5082
varietyVictory                   -8.50000  9.715028 10 -0.874933  0.4021
nitrogen0.2cwt                   18.50000  7.682957 45  2.407927  0.0202
nitrogen0.4cwt                   34.66667  7.682957 45  4.512152  0.0000
nitrogen0.6cwt                   44.83333  7.682957 45  5.835427  0.0000
varietyMarvellous:nitrogen0.2cwt  3.33333 10.865342 45  0.306786  0.7604
varietyVictory:nitrogen0.2cwt    -0.33333 10.865342 45 -0.030679  0.9757
varietyMarvellous:nitrogen0.4cwt -4.16667 10.865342 45 -0.383482  0.7032
varietyVictory:nitrogen0.4cwt     4.66667 10.865342 45  0.429500  0.6696
varietyMarvellous:nitrogen0.6cwt -4.66667 10.865342 45 -0.429500  0.6696
varietyVictory:nitrogen0.6cwt     2.16667 10.865342 45  0.199411  0.8428

anova(m1.nlme)

numDF denDF   F-value p-value
(Intercept)          1    45 245.14299  <.0001
variety              2    10   1.48534  0.2724
nitrogen             3    45  37.68562  <.0001
variety:nitrogen     6    45   0.30282  0.9322

```

The syntax for `lme4` is not that dissimilar, with random effects specified using a `(1|something here)` syntax. One difference between the two packages is that `nlme` reports standard deviations instead of variances for the random effects.

```r
library(lme4)
m1.lme4 <- lmer(yield ~ variety*nitrogen + (1|block/mainplot),
                data = oats)

summary(m1.lme4)

Linear mixed model fit by REML
Formula: yield ~ variety * nitrogen + (1 | block/mainplot)
Data: oats
AIC   BIC logLik deviance REMLdev
\n559 593.2 -264.5    595.9     529
Random effects:
Groups         Name        Variance Std.Dev.
mainplot:block (Intercept) 106.06   10.299
block          (Intercept) 214.48   14.645
Residual                   177.08   13.307
Number of obs: 72, groups: mainplot:block, 18; block, 6

Fixed effects:
Estimate Std. Error t value
(Intercept)                       80.0000     9.1064   8.785
varietyMarvellous                  6.6667     9.7150   0.686
varietyVictory                    -8.5000     9.7150  -0.875
nitrogen0.2cwt                    18.5000     7.6830   2.408
nitrogen0.4cwt                    34.6667     7.6830   4.512
nitrogen0.6cwt                    44.8333     7.6830   5.835
varietyMarvellous:nitrogen0.2cwt   3.3333    10.8653   0.307
varietyVictory:nitrogen0.2cwt     -0.3333    10.8653  -0.031
varietyMarvellous:nitrogen0.4cwt  -4.1667    10.8653  -0.383
varietyVictory:nitrogen0.4cwt      4.6667    10.8653   0.430
varietyMarvellous:nitrogen0.6cwt  -4.6667    10.8653  -0.430
varietyVictory:nitrogen0.6cwt      2.1667    10.8653   0.199

anova(m1.lme4)

Analysis of Variance Table
Df  Sum Sq Mean Sq F value
variety           2   526.1   263.0  1.4853
nitrogen          3 20020.5  6673.5 37.6856
variety:nitrogen  6   321.7    53.6  0.3028
```

For this type of problem, the notation for `asreml` is also very similar, particularly when compared to nlme.

```r
library(asreml)
m1.asreml <- asreml(yield ~ variety*nitrogen,
                    random = ~ block/mainplot,
                    data = oats)

summary(m1.asreml)$varcomp

gamma component std.error  z.ratio constraint
block!block.var          1.2111647  214.4771 168.83404 1.270343   Positive
block:mainplot!block.var 0.5989373  106.0618  67.87553 1.562593   Positive
R!variance               1.0000000  177.0833  37.33244 4.743416   Positive

wald(m1.asreml, denDF = 'algebraic')

$Wald
Df denDF    F.inc           Pr
(Intercept)       1     5 245.1000 1.931825e-05
variety           2    10   1.4850 2.723869e-01
nitrogen          3    45  37.6900 2.457710e-12
variety:nitrogen  6    45   0.3028 9.321988e-01

$stratumVariances
df  Variance block block:mainplot R!variance
block           5 3175.0556    12              4          1
block:mainplot 10  601.3306     0              4          1
R!variance     45  177.0833     0              0          1
```

In this simple example one pretty much gets the same results, independently of the package used (which is certainly comforting). I will soon cover another simple model, but with much larger dataset, to highlight some performance differences between the packages.