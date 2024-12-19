---
id: 1339
title: '(Unsurprisingly) users default to the defaults'
date: '2012-09-19T22:38:00+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1339'
permalink: /2012/09/19/unsurprisingly-users-default-to-the-defaults/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

Oddities tend to jump out when one uses software in a daily basis. The situation is even clearer when using software for teaching: many more people looking at it with fresh eyes.

Let’s say that we are fitting a simple linear model and we use the summary function, then POW! i- one gets all sorts of stars next to each of the coefficients and ii- some tiny p-values with lots of digits. Since immemorial times (childcare, at least) we got star stickers when doing a good job and here we have R doing the same. It is possible to remove the stars, I know, but the default is the subject of this post.

```r
x <- 1:20
y <- 5 + 2*x + rnorm(20) *5

m <- lm(y ~ x)
summary(m)

#Call:
#lm(formula = y ~ x)

#Residuals:
#    Min      1Q  Median      3Q     Max
#-9.1030 -0.8772  0.1168  2.3375  9.5846

#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)
#(Intercept)   5.0193     2.0507   2.448   0.0249 *
#x             2.0670     0.1712  12.074 4.57e-10 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Residual standard error: 4.415 on 18 degrees of freedom
#Multiple R-squared: 0.8901,    Adjusted R-squared: 0.884
#F-statistic: 145.8 on 1 and 18 DF,  p-value: 4.571e-10
```

In contrast, I like the simplicity of the `display()` function in the `arm` package. If we use it with the same model `m` we get:

```r
library(arm)
display(m)

#lm(formula = y ~ x)
#            coef.est coef.se
#(Intercept) 5.02     2.05
#x           2.07     0.17
#---
#n = 20, k = 2
#residual sd = 4.41, R-Squared = 0.89
```

There is an emphasis on understanding and awareness of limitations. Rather than a false sense of accuracy and precision, we get coefficients rounded to two decimal places, no stars and no p-values. Did you really believed that the p-value was 0.0249 instead of 0.0243?

Defaults also require consistency, because consistency begets ‘intuitiveness’. Every function that deals with data should take a `data` argument and avoid being schizophrenic:

```r
df <- data.frame(x = rnorm(100), y = rnorm(100))

# This works fine
plot(y ~ x, data = df)

# This craps out
plot(x, y, data = df)
#Error in plot(x, y, data = df) : object 'x' not found
```

I've mentioned in [previous](/2012/08/m-x-n-matrix-with-randomly-assigned-01/) posts the `apply()` family of functions. Yes, I hate them with passion and that's why I think we should unite and rely on [Talk like a Pirate Day](http://www.google.com/webhp?hl=en&tab=ww#hl=en&output=search&sclient=psy-ab&q=talk+like+a+pirate+day) (Rrrrstats, matey!) to lead a mutiny to get `plyr` as the new default.

However, even some of my favorite packages have strange defaults. In `ggplot2`, for example, the size (too small) and the color (too light) of the text in the axes is extremely hard to read. Maybe not for you young reader, but for a long-sighted, receding-hairline-guy with salt & pepper beard is a struggle. This is magnified when pasting said graph in a Keynote or PowerPoint presentation and then using a crappy projector. Again, thanks Hadley, I can define my own theme but there are thousands of difficult to read graphs doing the rounds because, hey, those are the defaults.

Every time we define a default we have to think that, even when we allow change, most users will probably stick to it. Of course I'm the first one to acknowledge that my favorite defaults may not coincide with yours, as shown below.

![Sticker in a University of Canterbury toilet cubicle. There are cultural differences on the default correct position.](/assets/images/toilets.jpg)