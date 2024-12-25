---
id: 63
title: 'Operating on datasets inside a function'
date: '2011-10-10T07:00:22+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=63'
permalink: /2011/10/10/operating-on-datasets-inside-a-function/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
---

There are times when we need to write a function that makes changes to a generic data frame that is passed as an argument. Let’s say, for example, that we want to write a function that converts to factor any variable with names starting with a capital letter. There are a few issues involved in this problem, including:

- Obtaining a text version of the name of the dataset (using the `substitute()` function).
- Looping over the variable names and checking if they start with a capital letter (comparing with the `LETTERS` vector of constants).
- Generating the plain text version of the factor conversion, glueing the dataset and variable names (using `paste()`).
- Parsing the plain text version of the code to R code (using `parse()`) and evaluating it (using `eval()`). This evaluation has to be done in the parent environment or we will lose any transformation when we leave the function, which is the reason for the `envir()` specification.

```r
CapitalFactors <- function(dataset) {
  # Gets text version name of dataset
  data.name = substitute(dataset)

  # Loops over variable names of dataset
  # and extracts the ones that start with uppercase
  for(var.name in names(dataset)){
    if(substr(var.name, 1, 1) %in% LETTERS) {
      left <- paste(data.name, '$', var.name, sep = '')
      right <- paste('factor(', left, ')', sep = '')
      code <- paste(left, '=', right)
      # Evaluates the parsed text, using the parent environment
      # so as to actually update the original data set
      eval(parse(text = code), envir = parent.frame())
    }
  }
}

# Create example dataset and display structure
example <- data.frame(Fert = rep(1:2, each = 4),
                      yield = c(12, 9, 11, 13, 14, 13, 15, 14))
str(example)

'data.frame':    8 obs. of  2 variables:
$ Fert : int  1 1 1 1 2 2 2 2
$ yield: num  12 9 11 13 14 13 15 14

# Use function on dataset and display structure
CapitalFactors(example)
str(example)

'data.frame':    8 obs. of  2 variables:
$ Fert : Factor w/ 2 levels "1","2": 1 1 1 1 2 2 2 2
$ yield: num  12 9 11 13 14 13 15 14
```

And that's all. Now the `Fert` integer variable has been converted to a factor. This example function could be useful for someone out there.