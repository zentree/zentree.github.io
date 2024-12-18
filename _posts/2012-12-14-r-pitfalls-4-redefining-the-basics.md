---
id: 1573
title: 'R pitfalls #4: redefining the basics'
date: '2012-12-14T12:37:45+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1573'
permalink: /2012/12/14/r-pitfalls-4-redefining-the-basics/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
---

I try to be economical when writing code; for example, I tend to use single quotes over double quotes for characters because it saves me one keystroke. One area where I don’t do that is when typing TRUE and FALSE (R accepts T and F as well), just because it is clearer to see in code and syntax highlighting kicks in. That’s why I was surprised to read Jason Morgan’s [post](https://web.archive.org/web/20121216101834/http://leftcensored.skepsi.net/2012/12/11/r-tip-avoid-using-t-and-f-as-synonyms-for-true-and-false/) in that it is possible to redefine T and F and get undesirable behavior.

Playing around it is quite easy to redefine other fundamental constants in R. For example:

```r
> pi
[1] 3.141593
> pi <- 2
> pi*2
[1] 4
```

Ouch, dangerous! I tend to muck around with matrices quite a bit and, being a friend of parsimony, I often use capital letters to represent them. This would have eventually bitten me if I had used the abbreviated TRUE and FALSE. One can redefine even basic functions like ‘+’ and be pure evil; over the top, sure, but possible.