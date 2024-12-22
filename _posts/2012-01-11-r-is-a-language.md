---
id: 671
title: 'R is a language'
date: '2012-01-11T22:46:21+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=671'
permalink: /2012/01/11/r-is-a-language/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

A commenter on this blog reminded me of one of the frustrating aspects faced by newbies, not only to R but to any other programming environment (I am thinking of typical students doing stats for the first time). The statement “R is a language” sounds perfectly harmless if you have previous exposure to programming. However, if you come from a zero-programming background the question is What do you really mean?

R—and many other statistical systems for that matter—is often approached from either one of two extremes:

1. Explaining R as a programming language, as most of the [R documentation](http://cran.r-project.org/doc/manuals/R-intro.html) and books (like [The Art of R Programming](https://www.librarything.com/work/11800069), quite good by the way) do.
2. The other one is from a hodgepodge of statistical analyses, introducing the language as a bonus, best represented by Crowley’s [The R Book](https://www.librarything.com/work/3618321) (which I find close to unreadable). In contrast, [Modern Applied Statistics with S](https://www.librarything.com/work/123714) by Ripley and Venables is much better even when it doesn’t mention R in the title<sup>†</sup>.

If you are new to both statistics and R I like the level of the [Quick-R website](http://www.statmethods.net/) as a starting point, which was expanded into a book ([R in Action](https://www.librarything.com/work/9913076)). It uses the second approach listed above, so if you come from a programming background the book will most likely be disappointing. Nevertheless, if you come from a newbie point of view both the website and book are great resources. In spite of this, Quick-R assumes that the reader is familiar with statistics and starts with *“R is an elegant and comprehensive statistical and graphical **programming language**“*.

## A simpler starting point

I would like to start from an even simpler point, ignoring for a moment programming and think about languages like English, Spanish, etc. In languages we have things (nouns) and actions (verbs)<sup>‡</sup>. We perform actions on things: we measure a tree, draw a plot, make some assumptions, estimate coefficients, etc. In R we use **functions** to perform actions on **objects** (things in the previous explanations). Our data sets are objects that we read, write, fit a model (and create objects with results), etc. “R is a language” means that we have a grammar that is designed to deal with data from a statistical point of view.

A simple sentence “Luis writes Quantum Forest” has two objects (*Luis* and *Quantum Forest*) and one function (*writes*). Now lets look at some simple objects in R; for example, a number, a string of characters and a collection of numbers (the latter using the function `c()` to keep the numbers together):

```r
> 23
[1] 23

> "Luis"
[1] "Luis"

> c(23, 42, pi)
[1] 23.000000 42.000000  3.141593
```

Up to this point we have pretty boring software, but things start becoming more interesting when we can assign objects to names, so we can keep acting on those objects (using functions). In this blog I use `=` instead of `<-` to assign things (objects) to names **outside** function calls. This is considered "bad form" in the R world, but to me is much more readable<sup>§</sup>. (Inside function calls the arguments should always be referred with an `=` sign, as we'll see in a future post). Anyway, if you are feeling in a conformist mood replace the `=` by `<-` and the code will work equally well.

```r
sex <- 23

Sex <- "Luis"

SEX <- c(23, 42, pi)
```

R is case sensitive, meaning that upper- and lower-case letters are considered different. Thus, we can assign different objects to variables named sex, Sex and SEX and R will keep track of them as separate entities (A [Kama Sutra](http://en.wikipedia.org/wiki/Kama_Sutra) of names!). Once objects are assigned to a variable R stops printing the object back to the user. However, it is possible to type the object name, press enter and get the content stored in the name. For example:

```r
> sex
[1] 23

> SEX
[1] 23.000000 44.000000  3.141593
```

The lowly `<-` sign is a function as well. For example, both a and b are assigned the same bunch of numbers:

```r
> a <- c(23 , 42, pi)
> a
[1] 23.000000 42.000000  3.141593

# Is equivalent to
> assign('b', c(23 , 42, pi))
> b
[1] 23.000000 42.000000  3.141593
```

Even referring to an object by its name calls a function! `print()`, which is why we get `[1] 23.000000 44.000000  3.141593` when typing `b` and hitting enter in R.

## Grouping objects

Robert Kabacoff has a nice [invited post](http://www.r-statistics.com/2011/12/data-frame-objects-in-r-via-r-in-action/) explaining data frames. Here I will present a very rough explanation with a toy example.

Objects can be collected in other objects and assigned a name. In data analysis we tend to collect several variables (for example tree height and stem diameter, people's age and income, etc). It is convenient to keep variables referring to the same units (trees, persons) together in a table. If you have used Excel, a rough approximation would be a spreadsheet. Our toy example could be like:

```r
> x <- c(1, 3, 4, 6, 8, 9)
> y <- c(10, 11, 15, 17, 17, 20)
> toy <- data.frame(x, y)
> toy

  x  y
1 1 10
2 3 11
3 4 15
4 6 17
5 8 17
6 9 20
```

The last line combines two objects (x and y) in an R table using the function `data.frame()` and then it assigns the name `toy` to that table (using the function `<-`). From now on we can refer to that data table when using other functions as in:

```r
# Getting descriptive statistics using summary()
> summary(toy)

x               y
Min.   :1.000   Min.   :10
1st Qu.:3.250   1st Qu.:12
Median :5.000   Median :16
Mean   :5.167   Mean   :15
3rd Qu.:7.500   3rd Qu.:17
Max.   :9.000   Max.   :20

# Obtaining the names of the variables in
# a data frame
> names(toy)
[1] "x" "y"

# Or actually doing some stats. Here fitting
# a linear regression model
> fm1 <- lm(y ~ x, data = toy)
```

Incidentally, anything following a `#` is a comment, which helps users document their work. Use them liberally.

Fitting a linear regression will produce lots of different outputs: estimated regression coefficients, fitted values, residuals, etc. Thus, it is very handy to assign the results of the regression to a name (in this case "fm1") for further manipulation. For example:

```r
# Obtaining the names of objects contained in the
# fm1 object
> names(fm1)
[1] "coefficients"  "residuals"     "effects"       "rank"
[5] "fitted.values" "assign"        "qr"            "df.residual"
[9] "xlevels"       "call"          "terms"         "model"

# We can access individual objects using the notation
# objectName$components

# Obtaining the intercept and slope
> fm1$coefficients
(Intercept)           x
8.822064    1.195730

# Fitted (predicted) values
> fm1$fitted.values
1        2        3        4        5        6
10.01779 12.40925 13.60498 15.99644 18.38790 19.58363

# Residuals
> fm1$residuals
1           2           3           4           5           6
-0.01779359 -1.40925267  1.39501779  1.00355872 -1.38790036  0.41637011

# We can also use functions to extract components from an object
# as in the following graph
> plot(resid(fm1) ~ fitted(fm1))
```

The last line of code extracts the residuals of fm1 (using the function `resid()`) and the fitted values (using the function `fitted()`), which are then combined using the function `plot()`.

**In summary:** in this introduction we relied on the R language to manipulate objects using functions. Assigning names to objects (and to the results of applying functions) we can continue processing data and improving our understanding of the problem under study.

## Footnotes

<sup>†</sup> R is an implementation ([a dialect](http://en.wikipedia.org/wiki/Dialect_(computing))) of the [S language](http://en.wikipedia.org/wiki/S_(programming_language)). But remember, [a language is a dialect with an army and a navy](http://en.wikipedia.org/wiki/A_language_is_a_dialect_with_an_army_and_navy).

<sup>‡</sup> Natural languages tend to be more complex and will have pronouns, articles, adjectives, etc. Let's ignore that for the moment.

<sup>§</sup>Languages change; for example, I speak Spanish—a bad form of Latin—together with hundreds of millions of people. Who speaks Latin today?