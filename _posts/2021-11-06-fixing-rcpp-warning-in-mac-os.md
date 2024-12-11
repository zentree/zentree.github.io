---
id: 3460
title: 'Fixing Rcpp warning in Mac OS'
date: '2021-11-06T20:33:08+13:00'
author: Luis
layout: post
guid: 'https://www.quantumforest.com/?p=3460'
permalink: /2021/11/06/fixing-rcpp-warning-in-mac-os/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2021/11/market.jpg
tags:
    - programming
    - stats
---

In Mac OS I was getting an annoying warning when compiling Cpp code via Rcpp in R:

```
ld: warning: directory not found for option '-L/usr/local/gfortran/lib/gcc/x86_64-apple-darwin15/version_number'
```

Adding a file called `Makevars` in `~/.R` defining `FLIBS` to the actual location of gfortran in my machine fixed the problem. In my case, `Makevars` only contains the following line:

```
FLIBS=-L/usr/local/gfortran/lib
```

That’s it.

![The marketplace of terrible computer advice, Christchurch.](/assets/images/market.jpg)