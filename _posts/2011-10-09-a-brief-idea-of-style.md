---
id: 52
title: 'A brief idea of style'
date: '2011-10-09T07:00:59+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=52'
permalink: /2011/10/09/a-brief-idea-of-style/
classic-editor-remember:
    - classic-editor
    - classic-editor
tags:
    - programming
---

Once one starts writing more R code the need for consistency increases, as it facilitates managing larger projects and their maintenance. There are several style guides or suggestions for R; for example, [Andrew Gelman’s](http://andrewgelman.com/2007/09/style_guide_for/), [Hadley Wickham’s](https://web.archive.org/web/20101125005435/http://had.co.nz/stat405/resources/r-style-guide.html), [Bioconductor’s](https://web.archive.org/web/20070119001752/http://wiki.fhcrc.org/bioc/Coding_Standards) and [this one](https://web.archive.org/web/20100704020603/http://www1.maths.lth.se/help/R/RCC/). I tend to write closer to [Google’s R style guide](https://web.archive.org/web/20110815161651/http://google-styleguide.googlecode.com/svn/trunk/google-r-style.html), which contains some helpful suggestions. I use something similar but:

- I use `=` for assignment rather than `<-`, because it is visually less noisy, `<-` requires an extra keystroke (yes, I am that lazy) and—from a merely esthetics point of view—in many monospaced fonts the lower than and hyphen symbols do not align properly, so `<-` does not look like an arrow. I know that hardcore R programmers prefer the other symbol but, tough, I prefer the equal sign.
- I indent code using four spaces, just because I am used to do so in Python. I will make an exception and go down to two spaces if there are too many nested clauses.
- I like their identifier naming scheme, although I do not use it consistently. *Mea culpa*.
- I always use single quotes for text (two fewer keystrokes per text variable).

Of course you’ll find that the examples presented in this site depart from the style guide. I didn’t say that I was consistent, did I?

P.D. 2022-10-05 This is a very old post, which does not reflect my current practice. These days I use `<-` to assign, two spaces indentation, `underscored_names`, etc.