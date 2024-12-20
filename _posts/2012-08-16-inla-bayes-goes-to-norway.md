---
id: 443
title: 'INLA: Bayes goes to Norway'
date: '2012-08-16T16:48:18+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=443'
permalink: /2012/08/16/inla-bayes-goes-to-norway/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2012/08/cubist.jpg
tags:
    - bayesian
    - stats
---

[INLA](http://www.r-inla.org/) is not the Norwegian answer to ABBA; that would probably be [a-ha](http://en.wikipedia.org/wiki/A-ha). INLA is the answer to ‘Why do I have enough time to cook a three-course meal while running MCMC analyses?”.

Integrated Nested Laplace Approximations (INLA) is based on direct numerical integration (rather than simulation as in MCMC) which, according to people ‘in the know’, allows:

- the estimation of marginal posteriors for all parameters,
- marginal posteriors for each random effect and
- estimation of the posterior for linear combinations of random effects.

Rather than going to the usual univariate randomized complete block or split-plot designs that I have analyzed before ([here](/2011/11/multivariate-linear-mixed-models-livin-la-vida-loca/) using REML and [here](/2011/11/coming-out-of-the-bayesian-closet/) using MCMC), I’ll go for some analyses that motivated me to look for INLA. I was having a look at some reproductive output for Drosophila data [here at the university](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0043113), and wanted to fit a logistic model using `MCMCglmm`. Unfortunately, I was running into the millions (~3M) of iterations to get a good idea of the posterior and, therefore, leaving the computer running overnight. Almost by accident I came across INLA and started playing with it. The idea is that Sol—a Ph.D. student—had a cool experiment with a bunch of flies using different mating strategies over several generations, to check the effect on breeding success. Therefore we have to keep track of the pedigree too.

![Cubist apartments not in Norway but near Lisbon.](/assets/images/cubist.jpg)
```r
# Set working directory containing data and code
setwd('~/Dropbox/research/2010/flies')

# Packages needed for analysis
# This code requires the latest (and updated) version of INLA
library(INLA)            # This loads INLA
library(pedigreemm)      # pedigree(), relfactor(), Tinv, D, ...

####### Pedigree and assessment files
# Reads pedigree file
ped <- read.csv('recodedped.csv', header=FALSE)
names(ped) <- c('id', 'mum', 'dad')

# Reads data file
dat <- read.csv('ggdatall.csv', header=TRUE)
dat$cross <- factor(dat$cross)

# Pedigree object for pedigreemm functions
pedPMM <- with(ped, pedigreemm::pedigree(sire=dad, dam=mum, label=id))

# Pedigree precision matrix (A inverse)
# T^{-1} in A^{-1} = (T^{-1})' D^{-1} T^{-1}
Tinv <- as(pedPMM, "sparseMatrix") 
D    <- Diagonal(x=Dmat(pedPMM))   # D      in A = TDT'
Dinv <- solve(D)
Ainv <- t(Tinv) %*% Dinv %*% Tinv
```

Up to this point we have read the response data, the pedigree and constructed the inverse of the pedigree matrix. We also needed to build a contrast matrix to compare the mean response between the different mating strategies. I was struggling there and contacted [Gregor Gorjanc](http://ggorjan.blogspot.com/), who kindly emailed me the proper way to do it.

```r
# Define contrasts to compare cross types. Thanks to Gregor Gorjanc
# for coding contrasts
k <- nlevels(dat$cross)
tmp <- matrix(nrow=(k-1)*k/2, ncol=k)

##               1   2   3   4   5   6 
tmp[ 1, ] =  c(  1, -1, NA, NA, NA, NA) ## c1-c2
tmp[ 2, ] =  c(  1, NA, -1, NA, NA, NA) ##   -c3
tmp[ 3, ] =  c(  1, NA, NA, -1, NA, NA) ##   -c4
tmp[ 4, ] =  c(  1, NA, NA, NA, -1, NA) ##   -c5
tmp[ 5, ] =  c(  1, NA, NA, NA, NA, -1) ##   -c6
tmp[ 6, ] =  c( NA,  1, -1, NA, NA, NA) ## c2-c3
tmp[ 7, ] =  c( NA,  1, NA, -1, NA, NA) ##   -c4
tmp[ 8, ] =  c( NA,  1, NA, NA, -1, NA) ##   -c5
tmp[ 9, ] =  c( NA,  1, NA, NA, NA, -1) ##   -c6
tmp[10, ] =  c( NA, NA,  1, -1, NA, NA) ## c3-c4
tmp[11, ] =  c( NA, NA,  1, NA, -1, NA) ##   -c5
tmp[12, ] =  c( NA, NA,  1, NA, NA, -1) ##   -c6
tmp[13, ] =  c( NA, NA, NA,  1, -1, NA) ## c4-c5
tmp[14, ] =  c( NA, NA, NA,  1, NA, -1) ##   -c6
tmp[15, ] =  c( NA, NA, NA, NA,  1, -1) ## c5-c6


# Make Linear Combinations
LC <- inla.make.lincombs(cross=tmp)

# Assign names to combinations
t <- 0
for(i in 1:(k-1)) {
  for(j in (i+1):k) {
    t <- t + 1
    names(LC)[t] <- paste("c", i, "-", "c", j, sep="")
  }
}
```

There is another related package ([Animal INLA](http://www.r-inla.org/related-projects/animalinla)) that takes care of i- giving details about the priors and ii- "easily" fitting models that include a term with a pedigree (an animal model in quantitative genetics speak). However, I wanted the assumptions to be clear so read the source of Animal INLA and shamelessly copied the useful bits (read the source, Luke!).

```r
######  Analysis for for binomial traits
####### Plain-vanilla INLA Version
# Feeling more comfortable with *explicit* statement of assumptions
# (rather than hidden behind animal.inla()) 

# Function to backconvert logits to probabilities
back.conv <- function(values){
  return(1/(1+exp(-(values))))
}

# Function to get posterior of the odds
# Thanks to Elena Moltchanova
inla.marginal.summary <- function(x){
  m1 <- inla.emarginal(function(z) exp(z), marginal=x)
  odds <- inla.marginal.transform(function(x) exp(x), x)
  q <- inla.qmarginal(p=c(0.025, 0.975), marginal=odds)
  c("0.025quant" = q[1], "0.5quant" = m1, "0.975quant" = q[2])
}


# Model for pupae/eggs
# Drops a few observations with no reproductive output (trips INLA)
no0eggs <- subset(dat, eggs>0 & pupae <= eggs)

# Actual model
mpueg <-  pupae ~ f(cross, model='iid', constr=TRUE, hyper=list(theta=list(initial=-10, fixed=TRUE))) +
                  f(id, model='generic0', constr=TRUE, Cmatrix=Ainv,
                  hyper=list(theta=list(param=c(0.5,0.5), fixed=FALSE)))

# INLA call
fpueg <-  inla(formula=mpueg, family='binomial', data=no0eggs,
               lincomb=LC,
               Ntrials=eggs,
               control.compute=list(dic=FALSE))

# Results
summary(fpueg)

# Call:
#   c("inla(formula = mpueg, family = \"binomial\", data = no0eggs, 
#     Ntrials = eggs, ",  "    lincomb = LC, control.compute = list(dic = FALSE))")
# 
# Time used:
#   Pre-processing    Running inla Post-processing           Total 
# 0.2712612       1.1172159       2.0439510       3.4324281 
# 
# Fixed effects:
#   mean        sd 0.025quant 0.5quant 0.975quant       kld
# (Intercept) 1.772438 0.1830827   1.417413 1.770863   2.136389 0.5833235
# 
# Linear combinations (derived):
#   ID        mean        sd 0.025quant    0.5quant  0.975quant kld
# c1-c2  0 -0.26653572 0.7066540 -1.6558225 -0.26573011  1.11859967   0
# c1-c3  1  0.04150999 0.7554753 -1.4401435  0.04104020  1.52622856   0
# c1-c4  2 -0.08777325 0.6450669 -1.3557501 -0.08713005  1.17693349   0
# c1-c5  3 -1.36702960 0.6583121 -2.6615604 -1.36618274 -0.07690788   0
# c1-c6  4 -1.82037714 0.8193280 -3.4338294 -1.81848244 -0.21714431   0
# c2-c3  5  0.30804735 0.7826815 -1.2248185  0.30677279  1.84852340   0
# c2-c4  6  0.17876229 0.5321948 -0.8654273  0.17859036  1.22421409   0
# c2-c5  7 -1.10049385 0.7466979 -2.5663142 -1.10046590  0.36558211   0
# c2-c6  8 -1.55383673 0.8188321 -3.1640965 -1.55276603  0.05084282   0
# c3-c4  9 -0.12928419 0.7475196 -1.5996080 -0.12817855  1.33522000   0
# c3-c5 10 -1.40854298 0.6016539 -2.5930656 -1.40723901 -0.23103707   0
# c3-c6 11 -1.86189314 0.8595760 -3.5555571 -1.85954031 -0.18100418   0
# c4-c5 12 -1.27925604 0.6998640 -2.6536362 -1.27905616  0.09438701   0
# c4-c6 13 -1.73259977 0.7764105 -3.2600936 -1.73134961 -0.21171790   0
# c5-c6 14 -0.45334267 0.8179794 -2.0618730 -0.45229981  1.14976690   0
# 
# Random effects:
#   Name    Model	  	Max KLD 
# cross   IID model 
# id   Generic0 model 
# 
# Model hyperparameters:
#   mean    sd      0.025quant 0.5quant 0.975quant
# Precision for id 0.08308 0.01076 0.06381    0.08244  0.10604   
# 
# Expected number of effective parameters(std dev): 223.95(0.7513)
# Number of equivalent replicates : 1.121 
# 
# Marginal Likelihood:  -1427.59 

fpueg$summary.random$cross
#   ID       mean        sd  0.025quant   0.5quant 0.975quant          kld
# 1  1 -0.5843466 0.4536668 -1.47561024 -0.5840804  0.3056632 0.0178780930
# 2  2 -0.3178102 0.4595676 -1.21808638 -0.3184925  0.5865565 0.0009666916
# 3  3 -0.6258600 0.4978254 -1.60536281 -0.6250077  0.3491075 0.0247426578
# 4  4 -0.4965763 0.4071715 -1.29571071 -0.4966277  0.3030747 0.0008791629
# 5  5  0.7826817 0.4389003 -0.07756805  0.7821937  1.6459253 0.0077476806
# 6  6  1.2360387 0.5768462  0.10897529  1.2340813  2.3744368 0.0451357379

# Backtransforms point estimates and credible intervals for odds -> prob
for(name in names(fpueg$marginals.lincomb.derived)){
  summa <- inla.marginal.summary(eval(parse(text=paste("fpueg$marginals.lincomb.derived$\'", name, "\'", sep=''))))
  cat(name, summa, '\n')
}

# c1-c2 0.1894451 0.9831839 3.019878 
# c1-c3 0.2338952 1.387551 4.534581 
# c1-c4 0.256858 1.127751 3.204961 
# c1-c5 0.0695406 0.3164847 0.9145132 
# c1-c6 0.03157478 0.2264027 0.792517 
# c2-c3 0.289088 1.850719 6.255175 
# c2-c4 0.4213069 1.377848 3.366947 
# c2-c5 0.0759222 0.4398384 1.420934 
# c2-c6 0.04135211 0.2955985 1.035951 
# c3-c4 0.1996085 1.16168 3.747526 
# c3-c5 0.0746894 0.2929174 0.7847903 
# c3-c6 0.02774805 0.2245797 0.821099 
# c4-c5 0.06988459 0.355529 1.084414 
# c4-c6 0.03780307 0.2389529 0.7974092 
# c5-c6 0.1245211 0.8878682 3.108852 
```

A quick look at the time taken by INLA shows that it is in the order of seconds (versus overnight using MCMC). I have tried a few examples and the MCMCglmm and INLA results tend to be very close; however, figuring out how to code models has been very tricky for me. INLA follows the glorious tradition of not having a 'proper' manual, but a number of examples with code. In fact, they reimplement [BUGS](http://www.mrc-bsu.cam.ac.uk/bugs/)'s examples. Personally, I struggle with that approach towards documentation, but you may be the right type of person for that. Note for letter to Santa: real documentation for INLA.

I was talking with a student about using Norwegian software and he mentioned Norwegian Black Metal. That got me thinking about how the developers of the package would look like; would they look like [Gaahl](http://en.wikipedia.org/wiki/Gaahl) of [Gorgoroth](http://en.wikipedia.org/wiki/Gorgoroth")?

![Not an INLA developer](http://upload.wikimedia.org/wikipedia/commons/7/7b/Gaahl_Gorgoroth.jpg)

Talk about disappointment! In fact [Håvard Rue](https://faculty.kaust.edu.sa/en/persons/haavard.rue), INLA mastermind, looks like a nice, clean-shaven, non-black-metal statistician. To be fair, it would be quite hard to code in any language wearing those spikes...