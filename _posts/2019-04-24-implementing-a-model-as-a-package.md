---
id: 3370
title: 'Implementing a model as an R package'
date: '2019-04-24T23:08:39+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=3370'
permalink: /2019/04/24/implementing-a-model-as-a-package/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2019/04/car_front.jpg
tags:
    - programming
    - research
    - stats
---

In our research group we often have people creating statistical models that end up in publications but, most of the time, the practical implementation of those models is lacking. I mean, we have a bunch of barely functioning code that is very difficult to use in a reliable way in operations of the breeding programs. I was very keen on continue using one of the models in our research, enough to rewrite and document the model fitting, and then create another package for using the.model in operations.

Unfortunately, neither the data nor the model are mine to give away, so I can’t share them (yet). But I hope these notes will help you in you are in the same boat and need to use your models (or ‘you’ are in fact future me, who tend to forget how or why I wrote code in a specific way).

## A basic motivational example

Let’s start with a simple example: linear regression. We want to predict a `response` using a `predictor` variable, and then we can predict the response for new values of the predictor contained in `new_data` with:

 ```R
my_model <- lm(response ~ predictor, data = my_data)
predictions <- predict(my_model, newdat = new_data)

# Saving the model object
save(my_model, "model_file.Rda")
```

The model coefficients needed to predict new values are stored in the `my_model` object. If we want to use the model elsewhere, we can save the object as an `.Rda` file, in this case `model_file.Rda`.



We can later read the model file in, say, a different project and get new predictions using:

```R
load("model_file.Rda")
more_predictions <- predict(my_model, 
                            newdat = yet_another_new_data)
```

## Near-infrared Spectroscopy

[Near-infrared spectroscopy](https://en.wikipedia.org/wiki/Near-infrared_spectroscopy) is the stuff of CSI and other crime shows. We measure the reflection at different wavelengths and run a regression analysis using what we want to predict as Y in the model. The number of predictors (wavelengths) is much larger than in the previous example—1,296 for the NIR machine we are using—so it is not unusual to have more predictors than observations. NIR spectra are often trained using `pls()` (from the `pls` package) with help from functions from the `prospectr` package.

I could still use the `save/load` approach from the motivational example to store and reuse the model object created with `pls` but, instead, I wanted to implement the model, plus some auxiliary functions, in a package to make the functions easier to use in our lab.

I had two issues/struggles/learning opportunities that I needed to sort out to get this package working:

### 1. How to automatically load the model object when attaching the package?

Normally, datasets and other objects go in the `data` folder, where they are made available to the user. Instead, I wanted to make the object <em>internally</em> available. The solution turned out to be quite straightforward: save the model object to a file called `sysdata.rda` (either in the `R` or `data` folders of the package). This file is automatically loaded when we run `library(package_name)`. We just need to create that file with something like:

```R
save(my_model, "sysdata.rda")
```

### 2. How to make predict.pls work in the package?

I was struggling to use the `predict` function, as in my head it was being provided by the `pls` package. However, `pls` is only extending the `predict` function, which comes with the default R installation but is part of the `stats` package. At the end, sorted it out with the following `Imports`, `Depends` and `LazyData` in the `DESCRIPTION` file:

```
Imports: prospectr,
         stats
Depends: pls
Encoding: UTF-8
LazyData: Yes
```

Now it is possible to use predict, just remember to specify the package where it is coming from, as in:

```R
stats::predict(my_model, 
               ncomp = n_components,
               newdata = spectra, 
               interval = 'confidence')
```

Nothing groundbreaking, I know, but spent a bit of time sorting out that couple of annoyances before everything fell into place. Right now we are using the models in a much easier and reproducible way.

![Shiny classic car front: a real model.](/assets/images/car_front.jpg)