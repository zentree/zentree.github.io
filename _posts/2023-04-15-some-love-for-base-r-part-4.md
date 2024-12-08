---
id: 4896
title: 'Some love for Base R. Part 4'
date: '2023-04-15T18:00:00+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=4896'
permalink: /2023/04/15/some-love-for-base-r-part-4/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2017/11/IMG_2857.jpg
tags:
    - stats
    - programming
---

Following on parts [1](/2023/03/18/some-love-for-base-r-part-1/), [2](/2023/03/18/some-love-for-base-r-part-2/) &amp; [3](/2023/03/21/some-love-for-base-r-part-3/)—yes, a series—we arrive to part 4 revisiting Base R. See [part 1](/2023/03/18/some-love-for-base-r-part-1/) for the rationale, in case you’re wondering Whyyyy?

A typical question going back to `Base` from the `tidyverse`: How do I join datasets? What do I use instead of `bind_rows()` and `bind_cols()`? Easy, rbind() and cbind(), yes, r for rows and c for cols, because base is concise.

### By rows

If we have a couple of data frames with the same variables (columns), then using `rbind()` binds/glues/stitches the data frames one after the other.

```R
example_df1 <- data.frame(record = 1:24,
                          treatment = rep(LETTERS[1:3], each = 8))

example_df2 <- data.frame(record = 25:48,
                          treatment = rep(LETTERS[4:6], each = 8))

example_df3 <- data.frame(record = 49:72)

# This one works
example_bound <- rbind(example_df1, example_df2)

# This one doesn't as they don't have the same variables
example_bound <- rbind(example_df1, example_df3)

# If we redefine the data frame we can join more than two data frames
example_df3 <- data.frame(record = 49:72,
                          treatment = rep(LETTERS[7:9], each = 8))

example_bound <- rbind(example_df1, example_df2, example_df3)
```

Of course we can use pipes too:

```R
example_df1 |> rbind(example_df2) -> example_bound2
```

### By columns

If we have a couple of data frames with the same number of rows (cases), then using `cbind()` binds/glues/stitches the data frames side by side.

```R
example_df4 <- data.frame(record = 1:24,
                          treat1 = rep(LETTERS[1:3], each = 8))

example_df5 <- data.frame(treat2 = rep(LETTERS[4:5], 12),
                          meas = rnorm(24))

example_cbound <- cbind(example_df4, example_df5)
example_cbound

   record treat1 treat2       meas
1       1      A      D -2.1158479
2       2      A      E  0.7784022
3       3      A      D -0.0112054
4       4      A      E -0.1986594
...
```

When you are working with data frames you get pretty much what you’d expect in dplyr. However, if you are not working with data frames but, instead, you’re dealing with vectors you end up with matrices, in which all elements have the same type. Coercing different types may produce unexpected results

```R
# Binding columns
x <- 1:26
y <- sqrt(x)

example_1 <- cbind(x, y)

# What do we get?
is.matrix(example_1)
[1] TRUE

example_1
       x        y
 [1,]  1 1.000000
 [2,]  2 1.414214
 [3,]  3 1.732051
 [4,]  4 2.000000
 ...

# Perhaps unexpected result. Variable x
# was coerced to character
example_2 <- cbind(x, letters)
example_2
      x    letters
 [1,] "1"  "a"    
 [2,] "2"  "b"    
 [3,] "3"  "c"    
 [4,] "4"  "d"  
 ...
```

### By one or more indices

When you have data frames with one or more variables “in common” the function to use is `merge()`, which may work like `left_join()` and `right_join()` in `dplyr`.

```R
merge(x, y, by =)
# which you can read as
merge(left, right, by = )
```

Think of `x` as left and `y` as right. Using `all.x = TRUE` extra rows will be added to the output, one for each row in `x` that has no matching row in `y`. Using `all.y = TRUE` extra rows will be added to the output, one for each row in `y` that has no matching row in `x`.

As an example, I have two data frames with a tree id (`ids`) and a derived variable (first tree ring to achieve a technical threshold for microfibril angle and modulus of elasticity). I would like to join them by ids:

```R
head(firstmfa)
    ids assess
1 DM001      3
2 DM002      5
3 DM003      4
4 DM004      6
5 DM005      5
6 DM006      7

head(firstmoe)
    ids ring
1 DM001    8
2 DM002    8
3 DM003    8
4 DM004    8
5 DM005    9
6 DM006   12

# Merging keeping all observations
gendata <- merge(firstmfa, firstmoe, by = 'ids', all = TRUE)
```

Another example using more than one joining variable. Actual wood density (in kg/m<sup>3</sup>) and microfibril angle (in degrees) assessments per tree ring, joined by tree code and ring number

```R
> head(densdataT)
    ids ring density
1 DM001    1      NA
2 DM001    2      NA
3 DM001    3  327.96
4 DM001    4  325.37
5 DM001    5  336.59
6 DM001    6  360.82
...

> head(mfadataT)
    ids ring   mfa
1 DM001    1    NA
2 DM001    2    NA
3 DM001    3 31.93
4 DM001    4 31.70
5 DM001    5 33.21
6 DM001    6 27.98

assess <- merge(densdataT, 
                mfadataT, by = c('tree', 'ring'), all = TRUE)
```

![Increment cores from where the data comes from.](/assets/images/cores_graph.jpg)