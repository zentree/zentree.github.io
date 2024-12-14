---
id: 2244
title: 'R as a second language'
date: '2014-01-06T12:52:08+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=2244'
permalink: /2014/01/06/r-as-a-second-language/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

Imagine that you are studying English as a second language; you learn the basic rules, some vocabulary and start writing sentences. After a little while, it is very likely that you’ll write grammatically correct sentences that no native speaker would use. You’d be following the formalisms but ignoring culture, idioms, slang and patterns of effective use.

[R is a language](/2012/01/r-is-a-language/) and any newcomers, particularly if they already know another programming language, will struggle at the beginning to get what is beyond the formal grammar and vocabulary. I use R [for inquisition](/2012/12/r-for-inquisition/): testing ideas, data exploration, visualization; under this setting, the easiest is to perform a task the more likely is one going to do it. It is possible to use several other languages for this but—and I think this is an important but—R’s brevity reduces the time between thinking and implementation, so we can move on and keep on trying new ideas<sup>†</sup>.

A typical example is when we want to repeat something or iterate over a collection of elements. In most languages if one wants to do something many times the obvious way is using a loop (coded like, `for()` or `while()`). It is *possible* to use a `for()` loop in R but many times is the wrong tool for the job, as it increases the lag between thought and code, moving us away from ‘the flow’.

```R
# Generate some random data with 10 rows and 5 columns
M <- matrix(round(runif(50, 1, 5), 0), 
            nrow = 10, ncol = 5)
M

#      [,1] [,2] [,3] [,4] [,5]
# [1,]    2    3    4    2    1
# [2,]    3    1    3    3    4
# [3,]    4    2    5    1    3
# [4,]    2    4    4    5    3
# [5,]    2    3    1    4    4
# [6,]    3    2    2    5    1
# [7,]    1    3    5    5    2
# [8,]    5    4    2    5    4
# [9,]    3    2    3    4    3
#[10,]    4    4    1    2    3

# Create dumb function that returns mean and median
# for data
sillyFunction <- function(aRow) {
  c(mean(aRow), median(aRow))
}

# On-liner to apply our function to each row
apply(M, 1, sillyFunction)

#     [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#[1,]  2.4  2.8    3  3.6  2.8  2.6  3.2    4    3   2.8
#[2,]  2.0  3.0    3  4.0  3.0  2.0  3.0    4    3   3.0

# or one could do it for each column
apply(M, 2, sillyFunction)

# Of course one could use a loop. Pre-allocating
# the result matrix would have a loop with little
# time penalty (versus growing the matrix)
nCases <- dim(M)[1]
resMatrix <- matrix(0, nrow = nCases, ncol = 2)
# and here is the loop
for(i in 1:nCases){
  resMatrix[i, 1:2] <- sillyFunction(M[i,])
}

resMatrix
# Same results as before
#      [,1] [,2]
# [1,]  2.4    2
# [2,]  2.8    3
# [3,]  3.0    3
# [4,]  3.6    4
# [5,]  2.8    3
# [6,]  2.6    2
# [7,]  3.2    3
# [8,]  4.0    4
# [9,]  3.0    3
#[10,]  2.8    3
```

[How apply loops around a matrix or data frame, doing its business for all rows [1] or columns [2] (Shaky handwriting and all).](/assets/images/flow.jpeg)

One of the distinctive features of R is that there is already a lot of functionality available for jobs that occur frequently in data analysis. The easiest is to perform a task the more likely is one going to do it, which is perfect if one is exploring/thinking about data.

Thomas Lumley reminded me of the ACM citation for [John Chambers](https://en.wikipedia.org/wiki/John_Chambers_%28statistician%29)—father of S of which R is an implementation—which stated that Chambers's work:

> ...will forever alter the way people analyze, visualize, and manipulate data . . . S is an elegant, widely accepted, and enduring software system, with conceptual integrity, thanks to the insight, taste, and effort of John Chambers.

If I could summarize the relevance of R in a Tweetable phrase (with hash tags and everything) it would be:

> Most data analysis languages underestimate the importance of interactivity/low barrier to exploration. That's where #Rstats shines.

One could run statistical analyses with many languages (including generic ones), but to provide the right level of interactivity for analysis, visualization and data manipulation one ends up creating functions that, almost invariably, look a bit like R; [pandas](http://pandas.pydata.org/) in Python, for example.

There are some complications with some of the design decisions in R, especially when we get down to consistency which begets memorability. A glaring example is the `apply` family of functions and here is where master opportunist (in the positive sense of expert at finding good opportunities) Hadley Wickham<sup>‡</sup> made sense out of confusion in his package plyr.

There is also a tension in languages under considerable use because speakers/writers/analysts/coders start adapting them to new situations, adding words and turns of phrase. Look at English for an example!  This is also happening to R and some people wish the language looked different in some non-trivial ways. A couple of examples: [Coffeescript for R](https://web.archive.org/web/20140110101336/http://www.yaksis.com/posts/coffeescript-for-r.html) and [Rasmus Bååth's](http://www.sumsar.net/blog/2013/12/three-syntax-addtions-that-would-make-r/) suggestions. Not all of them can be implemented, but suggestions like this speak of the success of R.

If you are struggling to start working with R, as with other languages, first let go. The key to learning and working with a new language is immersing yourself in it; even better if you do it with people who already speak it.

<sup>†</sup> Just to be clear, there are several good statistical languages. However, none is as supportive of rapid inquisition as R (IMO). It is not unusual to develop models in one language (e.g. R) and implement it in another for operational purposes (e.g. SAS, Python, whatever).

<sup>‡</sup> The first thing I admire about [Hadley](http://had.co.nz/) is his 'good eye' for finding points of friction. The second one is doing something about the frictions, often with very good taste.

P.S. It should come clear from this post that English is indeed my second language.
