---
id: 3602
title: 'Linear regression with correlated data'
date: '2011-10-06T07:00:44+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=13'
permalink: /2011/10/06/linear-regression-with-correlated-data/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2014/11/intangibles.jpeg
tags:
    - stats
---

I started following the debate on differential minimum wage for youth (15-19 year old) and adults in New Zealand. [Eric Crampton](http://offsettingbehaviour.blogspot.com/2011/08/youth-unemployment-update.html "Offsetting Behaviour blog") has written a nice series of blog posts, making the data from Statistics New Zealand available. I will use the [nzunemployment.csv](/assets/uploads/nzunemployment.csv) data file (with quarterly data from March 1986 to June 2011) and show an example of multiple linear regression with autocorrelated residuals in R.

A first approach could be to ignore autocorrelation and fit a linear model that attempts to predict youth unemployment with two explanatory variables: adult unemployment (continuous) and minimum wage rules (categorical: equal or different). This can be done using:

```r
setwd('~/Dropbox/quantumforest')
un <- read.csv('nzunemployment.csv', 
               header = TRUE)

# Create factor for minimum wage, which was 
# different for youth and adults before 
# quarter 90 (June 2008)
un$minwage <- factor(ifelse(un$q < 90, 
                     'Different', 'Equal'))

mod1 <- lm(youth ~ adult*minwage, data = un)
summary(mod1)

Coefficients:
Estimate Std. Error t value Pr(>|t|)
(Intercept)         8.15314    0.43328  18.817  < 2e-16 ***
adult               1.53334    0.07506  20.428  < 2e-16 ***
minwageEqual       -5.69192    2.19356  -2.595   0.0109 *
adult:minwageEqual  2.85518    0.46197   6.180 1.47e-08 ***

Residual standard error: 1.447 on 98 degrees of freedom
Multiple R-squared: 0.8816,    Adjusted R-squared: 0.878
F-statistic: 243.3 on 3 and 98 DF,  p-value: < 2.2e-16
```

Remember that `adult*minwage` is expanded to `adult + minwage + adult:minwage`. We can make the coefficients easier to understand if we center adult unemployment on the mean of the first 80 quarters. Notice that we get the same slope, Adj-R2, etc. but now the intercept corresponds to the youth unemployment for the average adult unemployment before changing minimum wage rules. All additional analyses will use the centered version.

```r
un <- within(un, cadult = adult - mean(adult))
mod2 <- lm(youth ~ cadult*minwage, data = un)
summary(mod2)

Coefficients:
Estimate Std. Error t value Pr(>|t|)
(Intercept)         16.28209    0.15352  106.06  < 2e-16 ***
cadult               1.53334    0.07506   20.43  < 2e-16 ***
minwageEqual         9.44472    0.52629   17.95  < 2e-16 ***
cadult:minwageEqual  2.85518    0.46197    6.18 1.47e-08 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.447 on 98 degrees of freedom
Multiple R-squared: 0.8816,    Adjusted R-squared: 0.878
F-statistic: 243.3 on 3 and 98 DF,  p-value: < 2.2e-16

plot(mod2)    # Plots residuals for the model fit
acf(mod2$res) # Plots autocorrelation of the residuals
```

In the centered version, the intercept corresponds to youth unemployment when adult unemployment rate is 5.4 (average for the first 89 quarters). The coefficient of minwageEqual corresponds to the increase of youth unemployment (9.44%) when the law moved to have equal minimum wage for youth and adults. Notice that the slopes did not change at all.

I will use the function `gls()` from the nlme package (which comes by default with all R installations) to take into account the serial correlation. First we can fit a model equivalent to mod2, just to check that we get the same results.

```r
library(nlme)
mod3 <- gls(youth ~ cadult*minwage, 
            data = un)
summary(mod3)

Generalized least squares fit by REML
Model: youth ~ cadult * minwage
Data: un
AIC      BIC    logLik
375.7722 388.6971 -182.8861

Coefficients:
Value Std.Error   t-value p-value
(Intercept)         16.282089 0.1535237 106.05585       0
cadult               1.533341 0.0750595  20.42834       0
minwageEqual         9.444719 0.5262926  17.94576       0
cadult:minwageEqual  2.855184 0.4619725   6.18042       0

Correlation:
(Intr) cadult mnwgEq
cadult              -0.048
minwageEqual        -0.292  0.014
cadult:minwageEqual  0.008 -0.162  0.568

Standardized residuals:
Min          Q1         Med          Q3         Max
-2.96256631 -0.53975848 -0.02071559  0.63499262  2.35900240

Residual standard error: 1.446696
Degrees of freedom: 102 total; 98 residual
```

Yes, they are identical. Notice that the model fitting is done using Restricted Maximum Likelihood (REML). Now we can add an autoregressive process of order 1 for the residuals and compare the two models:

```r
mod4 <- gls(youth ~ cadult*minwage, 
            correlation = corAR1(form=~1), 
            data = un)
summary(mod4)


Generalized least squares fit by REML
Model: youth ~ cadult * minwage
Data: un
AIC      BIC    logLik
353.0064 368.5162 -170.5032

Correlation Structure: AR(1)
Formula: ~1
Parameter estimate(s):
Phi
0.5012431

Coefficients:
Value Std.Error  t-value p-value
(Intercept)         16.328637 0.2733468 59.73598       0
cadult               1.522192 0.1274453 11.94389       0
minwageEqual         9.082626 0.8613543 10.54459       0
cadult:minwageEqual  2.545011 0.5771780  4.40940       0

Correlation:
(Intr) cadult mnwgEq
cadult              -0.020
minwageEqual        -0.318  0.007
cadult:minwageEqual -0.067 -0.155  0.583

Standardized residuals:
Min          Q1         Med          Q3         Max
-2.89233359 -0.55460580 -0.02419759  0.55449166  2.29571080

Residual standard error: 1.5052
Degrees of freedom: 102 total; 98 residual

anova(mod3, mod4)
Model df      AIC      BIC    logLik   Test L.Ratio p-value
mod3     1  5 375.7722 388.6971 -182.8861
mod4     2  6 353.0064 368.5162 -170.5032 1 vs 2 24.7658  <.0001
```

There is a substantial improvement for the log likelihood (from -182 to -170). We can take into account the additional parameter (autocorrelation) that we are fitting by comparing AIC, which improved from 375.77 (-2*(-182.8861) + 2*5) to 368.52 (-2*(-170.5032) + 2*6). Remember that AIC is -2*logLikelihood + 2*number of parameters.

The file [unemployment.txt](/assets/uploads/unemployment.txt) contains the R code used in this post (I didn't use the .R extension as WordPress complains).