---
id: 4634
title: 'Some love for Base R. Part 3'
date: '2023-03-21T08:11:28+13:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=4634'
permalink: /2023/03/21/some-love-for-base-r-part-3/
classic-editor-remember:
    - block-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2023/03/hospital.jpeg
tags:
    - programming
    - stats
---

It seems a few people have found useful the reminders of base-R functionality covered in “Some love for Base R” [Part 1](https://luis.apiolaza.net/2023/03/18/some-love-for-base-r-part-1/) and [Part 2](https://luis.apiolaza.net/2023/03/18/some-love-for-base-r-part-2/). So I will keep on mentioning a few bits and pieces that you may find handy when going back to Base or even visiting it for the first time.

A reminder: the fictional setting is that you are revisiting legacy code or developing new code under strong constraints: minimal use of packages. The latter could be because you are using `webR` or you’re keen on having few dependencies. I am assuming R 4.1 when mentioning native pipes, but not the existence of the `_` placeholder yet.

In this post I play a little with variable names. None of this would be “production code”, but it would work fine in your analyses. I have similar code (except without pipes) that is almost 20 years old and still running.

> A rose by any other name would smell as sweet
> 
> <cite>William Shakespeare</cite>

Changing variable names, renaming, does not work quite like in the `tidyverse`, in which it can be one more step in a list of transformations with `rename()`. In base R we rely on the `names()` function, which is used for both for listing the names of an object and changing them. Usually people would either change all names, providing a vector with names, or replacing one or more names by referring to their position, as in:

```R
names(warpbreaks)
#[1] "breaks"  "wool"    "tension"

names(warpbreaks) <- c("bre", "woo", "ten")
names(warpbreaks)
#[1] "bre" "woo" "ten"

names(warpbreaks)[3] <- "tension"
names(warpbreaks)
#[1] "bre"     "woo"     "tension"

names(warpbreaks)[1:2] <- c("breaks", "wool")
names(warpbreaks)
#[1] "breaks"  "wool"    "tension"
```

One problem is relying on the position of the variable, which may change with different datasets. One option—although a bit wordy—is to use a regular expression to rename a specific variable with the base `sub()` function:

```R
# General use
names(data_frame) <- sub("old_name", "new_name", 
                         names(data_frame))

names(warpbreaks) <- sub("wool", "woolly", 
                         names(warpbreaks))
names(warpbreaks)
#[1] "breaks"  "woolly"  "tension"
```

Inside `sub()` we get a list of all the names for the data frame, look for the one that matches “wool” and replace it by “woolly”.

#### Cleaning names

A typical problem when receiving datasets is that the authors followed weird naming conventions or, more likely, no convention at all. There are shouting ALLCAPS, names separated by dots, or by spaces, or whatever. I usually work with lowercase names separated by underscores if more than one word. The easiest way to convert names is using `janitor`‘s `clean_names()` function.

Our data set’s names could look like this:

```R
names(bos)
#[1] "BLOCK_NO"  "TREE_NO"   "FAM_CODE"  
#    "age core"  "site.code"
```

I could write a bare bones clean names function in base (covering most of my cleaning needs) using the following code:

```R
names(data_frame) |> 
  tolower() |> 
  {\(x) gsub("[\\. ]", "_", x)}()
```

For a data frame:

1\. get names for the data frame names(data\_frame)

2\. pass them to the next function `|>` (using native pipe)

3\. convert names to lowercase `tolower()`

4\. replace dots and spaces with underscore using regular expression `gsub()`

The Klingonian part is a lambda function wrapped by `{ }()` so it works with the native pipe and it is the same as {`function(x) gsub("[\\. ]", "_", x)}()`. One could perfectly write the code without pipes and using less Klingon.

Applying the function we’d get:

```R
names(bos) |> 
  tolower() |> 
  {\(x) gsub("[\\. ]", "_", x)}()
#[1] "block_no"  "tree_no"   "fam_code"  
#    "age_core"  "site_code"
```

Of course you’d need to assign the names, so they overwrite the existing ones. Easiest way would be to add `-> names(bos)` at the end of the line. A right-side assign (wink).

```R
names(bos) |> 
  tolower() |> 
  {\(x) gsub("[\\. ]", "_", x)}() -> names(bos)
```

Here you go to parts [2](/2023/03/18/some-love-for-base-r-part-2/) and [4](/2023/04/15/some-love-for-base-r-part-4/) of this post.

![Hospital hallway.](/assets/images/hospital.jpeg)