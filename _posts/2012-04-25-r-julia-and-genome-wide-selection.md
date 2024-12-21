---
id: 982
title: 'R, Julia and genome wide selection'
date: '2012-04-25T11:25:44+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=982'
permalink: /2012/04/25/r-julia-and-genome-wide-selection/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2012/04/horses.jpg
tags:
    - bayesian
    - programming
    - stats
---

— “You are a pussy” emailed my friend.  
— “*Sensu* cat?” I replied.  
— “No. *Sensu* chicken” blurbed my now ex-friend.

What was this about? He read my post on [R, Julia and the shiny new thing](https://luis.apiolaza.net/2012/04/12/r-julia-and-the-shiny-new-thing/), which prompted him to assume that I was the proverbial old dog unwilling (or was it unable?) to learn new tricks. (Incidentally, with friends like this who needs enemies? Hi, Gus.)

[![Having a look at different—statistical—horses, Canterbury.](/assets/images/horses.jpg "horses")](/assets/images/horses.jpg)

I decided to tackle a small—but hopefully useful—piece of code: fitting/training a Genome Wide Selection model, using the Bayes A approach put forward by [Meuwissen, Hayes and Goddard](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1461589/?tool=pubmed) in 2001. In that approach the breeding values of the individuals (response) are expressed as a function of a very large number of random predictors (2000, our molecular markers). The dataset ([csv file](/assets/uploads/2012/04/markers.csv)) is a simulation of 2000 bi-allelic markers (aa = 0, Aa = 1, AA = 2) for 250 individuals, followed by the phenotypes (column 2001) and breeding values (column 2002). These models are frequently adjusted using MCMC.

In 2010 I attended [this course](http://taurus.ansci.iastate.edu/wiki/pages/p6d1N2c496/) in Ames, Iowa where Rohan Fernando passed us the following R code (pretty much a transliteration from C code; notice the trailing semicolons, for example). 

**P.D. 2012-04-26 Please note that this is *teaching* code not *production* code and that I’m using `=` instead of `<-` to highlight the similarities**:

```r
nmarkers = 2000;    # number of markers
startMarker = 1981; # set to 1 to use all
numiter  = 2000;    # number of iterations
vara     = 1.0/20.0;

# input data
data     = matrix(scan("trainData.out0"),ncol=nmarkers+2,byrow=TRUE);
nrecords = dim(data)[1];

beg = Sys.time()

# x has the mean followed by the markers
x = cbind(1,data[,startMarker:nmarkers]);
y = data[,nmarkers+1];
a =  data[,nmarkers+2];
# inital values

nmarkers = nmarkers - startMarker + 1;
mean2pq = 0.5;                          # just an approximation
scalea  = 0.5*vara/(nmarkers*mean2pq);  # 0.5 = (v-2)/v for v=4

size = dim(x)[2];
b = array(0.0,size);
meanb = b;
b[1] = mean(y);
var  = array(0.0,size);

# adjust y
ycorr = y - x%*%b;

# MCMC sampling
for (iter in 1:numiter){
  # sample vare
  vare = ( t(ycorr)%*%ycorr )/rchisq(1,nrecords + 3);

  # sample intercept
  ycorr = ycorr + x[,1]*b[1];
  rhs = sum(ycorr)/vare;
  invLhs = 1.0/(nrecords/vare);
  mean = rhs*invLhs;
  b[1] = rnorm(1,mean,sqrt(invLhs));
  ycorr = ycorr - x[,1]*b[1];
  meanb[1] = meanb[1] + b[1];

  # sample variance for each locus
  for (locus in 2:size){
    var[locus] = (scalea*4+b[locus]*b[locus])/rchisq(1,4.0+1)
  }

  # sample effect for each locus
  for (locus in 2:size){
  # unadjust y for this locus
    ycorr = ycorr + x[,locus]*b[locus];
    rhs = t(x[,locus])%*%ycorr/vare;
    lhs = t(x[,locus])%*%x[,locus]/vare + 1.0/var[locus];
    invLhs = 1.0/lhs;
    mean = invLhs*rhs;
    b[locus]= rnorm(1,mean,sqrt(invLhs));
    #adjust y for the new value of this locus
    ycorr = ycorr - x[,locus]*b[locus];
    meanb[locus] = meanb[locus] + b[locus];
  }
}

Sys.time() - beg

meanb = meanb/numiter;
aHat  = x %*% meanb;
```

Thus, we just need defining a few variables, reading the data (marker genotypes, breeding values and phenotypic data) into a matrix, creating loops, matrix and vector multiplication and generating random numbers (using a Gaussian and Chi squared distributions). Not much if you think about it, but I didn't have much time to explore Julia's features as to go for something more complex.

```julia
nmarkers = 2000    # Number of markers
startmarker = 1981 # Set to 1 to use all
numiter = 2000     # Number of iterations

data = dlmread("markers.csv", ',')
(nrecords, ncols) = size(data)

tic()

#this is the mean and markers matrix
X = hcat(ones(Float64, nrecords), data[:, startmarker:nmarkers])
y = data[:, nmarkers + 1]
a = data[:, nmarkers + 2]

nmarkers = nmarkers - startmarker + 1
vara = 1.0/nmarkers
mean2pq = 0.5

scalea  = 0.5*vara/(nmarkers*mean2pq) # 0.5 = (v-2)/v for v=4

ndesign = size(X, 2)
b = zeros(Float64, ndesign)
meanb = zeros(Float64, ndesign)
b[1] = mean(y)
varian  = zeros(Float64, ndesign)

# adjust y
ycorr = y - X * b

# MCMC sampling
for i = 1:numiter
  # sample vare
  vare = dot(ycorr, ycorr )/randchi2(nrecords + 3)

  # sample intercept
  ycorr = ycorr + X[:, 1] * b[1];
  rhs = sum(ycorr)/vare;
  invlhs = 1.0/(nrecords/vare);
  mn = rhs*invlhs;
  b[1] = randn() * sqrt(invlhs) + mn;
  ycorr = ycorr - X[:, 1] * b[1];
  meanb[1] = meanb[1] + b[1];

  # sample variance for each locus
  for locus = 2:ndesign
    varian[locus] = (scalea*4 + b[locus]*b[locus])/randchi2(4.0 + 1);
  end

  # sample effect for each locus
  for locus = 2:ndesign
    # unadjust y for this locus
    ycorr = ycorr + X[:, locus] * b[locus];
    rhs = dot(X[:, locus], ycorr)/vare;
    lhs = dot(X[:, locus], X[:, locus])/vare + 1.0/varian[locus];
    invlhs = 1.0/lhs;
    mn = invlhs * rhs;
    b[locus] = randn() * sqrt(invlhs) + mn;
    #adjust y for the new value of this locus
    ycorr = ycorr - X[:, locus] * b[locus];
    meanb[locus] = meanb[locus] + b[locus];
  end
end

toc()

meanb = meanb/numiter;
aHat  = X * meanb;
```

The code looks remarkably similar and there are four main sources of differences:

1. The first trivial one is that the original code read a binary dataset and I didn't know how to do it in Julia, so I've read a csv file instead (this is why I start timing after reading the file too).
2. The second trivial one is to avoid name conflicts between variables and functions; for example, in R the user is allowed to have a variable called `var` that will not interfere with the variance function. Julia is picky about that, so I needed renaming some variables.
3. Julia pases variables by reference, while R does so by value when assigning matrices, which tripped me because in the original R code there was something like: `b = array(0.0,size); meanb = b;`. This works fine in R, but in Julia changes to the `b` vector also changed `meanb`.
4. The definition of scalar vs array created some problems in Julia. For example `y' * y` (`t(y) %*% y` in R) is numerically equivalent to `dot(y, y)`. However, the first version returns an array, while the second one a scalar. I got an error message when trying to store the 'scalar like an array' in to an array. I find that confusing.

One interesting point in this comparison is using rough code, not really optimized for speed; in fact, the only thing that I can say of the Julia code is that 'it runs' and it probably is not very idiomatic. Testing runs with different numbers of markers we get that R needs roughly 2.8x the time used by Julia. The Julia website claims [better results](http://julialang.org/) in benchmarks, but in real life we work with, well, real problems.

In 1996-7 I switched from SAS to ASReml for genetic analyses because it was 1-2 **orders of magnitude** faster and opened a world of new models. Today a change from R to Julia would deliver (in this particular case) a much more modest speed up (~3x), which is OK but not worth changing languages (yet). Together with the embryonic graphical capabilities and the still-to-develop ecosystem of packages, means that I'm still using R. Nevertheless, the Julia team has achieved very impressive performance in very little time, so it is worth keeping an eye on their progress.

P.S.1 Readers are welcome to suggesting ways of improving the code.  
P.S.2 WordPress does not let me upload the binary version of the simulated data.  
P.S.3 **2012-04-26** Following AL's recommendation in the comments, one can replace in R:

```r
rhs <- t(x[,locus])%*%ycorr/vare;
lhs <- t(x[,locus])%*%x[,locus]/vare + 1.0/var[locus]
```
 
by

```r
rhs <- crossprod(x[,locus],ycorr)/vare
lhs <- crossprod(x[,locus],x[,locus])/vare + 1.0/var[locus]
```

reducing execution time by roughly 20%, making the difference between Julia and R even smaller.