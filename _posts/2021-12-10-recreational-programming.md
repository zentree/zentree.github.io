---
id: 3505
title: 'Recreational programming'
date: '2021-12-10T12:34:28+13:00'
author: Luis
layout: post
guid: 'https://www.quantumforest.com/?p=3505'
permalink: /2021/12/10/recreational-programming/
classic-editor-remember:
    - classic-editor
image: /wp-content/uploads/2021/12/advent.png
tags:
    - programming
---

I think programming, aka coding, is a fun activity. We are solving a problem subject to a set of constraints that can be time, memory, quantity of code, language, etc. Besides being a part of my work, coding is also a good distraction when doing it for the sake of it.

In this type of situation I like to set myself additional constraints. For example, I try to use only base R or a very minimal set of features. Moreover, I prefer vectorised code: there are no explicit loops in the code. For toy problems this restriction doesn’t make much of a difference in execution time, but in real problems R (and Matlab) run much more slowly with non-vectorised code.

![Advent of code.](/assets/images/advent.png)

I started browsing the problems in the Advent of Code and I could see that, at least the first seven problems, could be solved within my constraints. Some of them were even trivial, with the code fitting in one tweet. For example, reading carefully [problem 7](https://adventofcode.com/2021/day/7) it was just minimising the absolute deviations from a number of observations. We tend to think of minimising the sum of the squared deviations (the mean), but this was a case of minimising the sum of absolute deviations (the median).

```R
pos <- '1101,1,29,67,...'
new_pos <- as.integer(unlist(strsplit(pos , split = ',')))
fuel <- sum(abs(new_pos - round(median(new_pos))))
```

If `pos` contains a string of comma separated values, we split the string using comma as a separator, unlist the result because we really want a vector, and then convert the vector of strings to a vector of integers called `new_pos`.

We then take all the number deviations from the median (which I rounded just in case), take the absolute value of the deviations and sum the results, saving it to the variable `fuel`. Three lines, no loops, only base functions, …, very terse!

Some years ago I wrote about [R as a second language](/2014/01/06/r-as-a-second-language/), explaining why this terseness was conducive to thinking and exploration. We don’t need to write an insane amount of code to do basic data manipulation in R; it is part of the language ethos and, therefore, immediately available to the user.

Some people will say ‘ah, but choose another problem!’ because it sounds like one is cheating. OK, let’s go for [problem 1](https://adventofcode.com/2021/day/1):

```R
depth <- read.table('input.txt', header = FALSE)
depth_num <- depth$V1
diff <- depth_num[2:length(depth_num)] - 
                  depth_num[1:(length(depth_num) - 1)]
sum(diff > 0)
```

In summary, displace vector by 1, calculate the difference between the vectors, check if the differences are greater than 0 (which produces a vector of `TRUE` and `FALSE`), add app the Boolean vector, in which `TRUE` are converted to 1 and `FALSE` to 0. Of course Tom Elliott asked me why didn’t you use the `diff() `function? Good point, the code can be even shorter:

```R
depth <- read.table('input.txt', header = FALSE)
depth_num <- depth$V1
sum(diff(depth_num) > 0))
```

## Just one more

One more, really, [problem 2](https://adventofcode.com/2021/day/2). A submarine is going up, down or forward a number of units `k`. We need to sort out the product of the final depth and horizontal displacement. The code reads this type of instructions:

```
forward 5
down 5
forward 8
up 3
down 8
forward 2
```

There are several ways of doing this, but this is an easy and short one:

```R
pos <- readLines('input2.txt')

hor <- pos[grepl('forward', pos)]
hor <- gsub('forward', '1', hor)

ver <- pos[!grepl('forward', pos)]
ver <- gsub('down', '-1', ver)
ver <- gsub('up', '1', ver)

splitter <- \(x) prod(as.integer(unlist(strsplit(x, 
                                        split = ' '))))
tot_hor <- sum(sapply(hor, FUN = splitter))
tot_ver <- sum(sapply(ver, FUN = splitter))
tot_hor * abs(tot_ver)
```

Once you get used to the building blocks of a matrix/vector language is hard to not miss their existence when using a ‘normal’ general purpose language.