---
id: 5395
title: 'Exposing rather than hiding complexity'
date: '2024-05-09T20:44:17+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=5395'
permalink: /2024/05/09/exposing-rather-than-hiding-complexity/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2024/05/shop_counter.jpeg
tags:
    - stats
    - breeding
    - linkedin
---

In the mid-1990s I was at Massey University in Palmerston North, centre of the known universe, where I was doing my PhD. During a short course I met Arthur Gilmour, the creator of ASReml (plain vanilla version, there was no R package yet then). I was really impressed by two things: 1- the software was insanely fast, particularly compared to the SAS scripts I was used to, and 2. How strange the syntax was for anything but the simplest cases.

I was stuck while coding some multivariate analysis, hitting my head against the wall when I complained to Arthur about the syntax. He told me that my problem was not with the syntax but with the matrices. That the syntax represented direct sums and Kronecker products. After that I read the code again, thinking of matrices(\*) and suddenly the syntax made sense: there was complexity because the underlying matrix operations were quite exposed in the notation. Exposing these operations was one of the keys that made ASReml so powerful.

Morals of the story:

- It helps to have a clue of what the software is supposed to be doing.
- Genetic analyses are turtles/matrices all the way down.
- Ask if you don’t understand. There is no point on suffering in silence.

(\*) Good thing that I had gone through Searle’s “Matrix Algebra Useful for Statistics” guided/pushed by Dorian Garrick. It was hard work, but excellent background for dealing with linear mixed models.

![A very complex small shop counter in Valdivia.](/assets/images/shop_counter.jpeg)