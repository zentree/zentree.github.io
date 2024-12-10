---
id: 4618
title: 'Some love for Base R. Part 2'
date: '2023-03-18T15:03:57+13:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=4618'
permalink: /2023/03/18/some-love-for-base-r-part-2/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2023/03/between_buildings.jpeg
tags:
    - programming
    - stats
---

Where were we? Giving [some love](/2023/03/18/some-love-for-base-r-part-1/) to base-R and putting together the idea that it is possible to write R very clearly when using base. Two sets of typical issues:

### Subsetting rows and columns

When running analyses we often want to work on a subset of all cases (rows) or variables (columns). People are used to `filter()` (for rows) and `select()` (for columns) in the `tidyverse` but then search how to do that in base and get ugly responses. For example, if we had a number of trials in a data frame called `all_trials` and we wanted to keep only a single one located in Christchurch we could try using sort of matrix notation, keeping the rows that meet the criterion, and all variables, as we don’t specify criteria for them:

```R
my_trial <– all_trials[all_trials$location == "Christchurch", ]
# better, by using with(). More below
my_trial <- with(all_trials, 
                 all_trials[location == "Christchurch", ])
```
<p>You could have been tempted to use `all_trials[location == "Christchurch", ]` by itself, but R wouldn't have known to look for location inside `all_trials`. Much clearer, though, would have been to use the `subset()` function from base R, which does the job of both `filter()` and `select()` in the tidyverse. It works like this:</p>

```R
subset(data_frame, 
       conditions_for_rows, 
       select = conditions_for_columns)

# we keep all columns, as we aren't using select
my_trial <– subset(all_trials, 
                   location == "Christchurch")
```

It is way clearer and pipe ready, as the first argument is the data frame name!

This code can easily be expanded to more complex conditions; for example to include all trees from Christchurch <strong>and</strong> (`&`)that are also taller than 10 m:

```R
my_trial <– subset(all_trials, 
                   location == "Christchurch" & height > 10)
```

The dataset contains multiple variables but we only want to keep, say, location, block, height and diameter:

```R
my_trial <– subset(all_trials, 
                   location == "Christchurch" & height > 10,
                   select = c(location, block, height, diameter)
```

### with() and pipes

Another one. In the tidyverse functions are designed to receive the name of the data frame as the first argument, as in `some_function(data = ..., other arguments)`. Most of the time in base R data is not the first argument and, in some cases, the functions do not take `data = ...` as an argument. The first case is not a problems, unless we want to use the base pipe `|>`. The second leads to either going for `$` notation or, god helps us, using attach() to make our variables global. Note: **never do this.**

Argh! What to do? Here is where `with()` comes to life, being very useful for these two problematic cases. In essence, `with(data_frame, function)` is saying "look for the function arguments in the specified data_frame".

For example, <a href="https://towardsdatascience.com/understanding-the-native-r-pipe-98dea6d8b61b">this blog post</a> gives a lengthy comparison of the `%>%` and `|>` pipes but, in my opinion, it complicates things a lot because is missing the use of `with()`. The post starts "When I am feeling lazy, I use base R for quick plots plot(mtcars$hp, mtcars$mpg)`".

As a start, if I were feeling lazy I would've used `plot(mpg ~ hp, mtcars)`, highlighting that the `plot` function already takes the `data` argument. In fact, I'm using it as `plot(formula, data)`. If I needed data in the first place I could have simply used `with()`, which defaults to a data frame as the first argument:

```R
mtcars |> with(plot(mpg ~ hp))
```

This is simply calling

```R
with(mtcars, plot(mpg ~ hp))
```

Instead, the author chooses to use anonymous (lambda) functions, which do have their place in R, but ends up with nasty looking code:

```R
mtcars |> (\(x) plot(x$mpg ~ x$hp))()
# vs
mtcars |> with(plot(mpg ~ hp))
# or even
mtcars |> with(plot(hp, mpg))
```

I'm partial to using a formula in plot because I can easily visualise the underlying model in my head.

Some functions, `mean()` for example, don't take a data frame argument. Again, `with()` is your friend.

```R
# This produces an error
mtcars |> mean(mpg)

# while this one works
mtcars |> with(mean(mpg))
```

Both `within()` (used in part 1) and `with()` will make your base code mucho moar readable (pun intended) and pipe ready.

![Between buildings](/assets/images/between_buildings.jpeg)