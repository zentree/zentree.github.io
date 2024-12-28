---
id: 43
title: 'Getting rid of convergence information in asreml'
date: '2024-03-08T15:01:20+13:00'
author: Luis
layout: post
guid: 'https://aleph.apiolaza.net/?p=43'
permalink: /2024/03/08/getting-rid-of-convergence-information-in-asreml/
tags:
    - aleph
    - asreml
---

I am coding simulations where I call `asreml()` and it was taking longer than necessary, because it was sending the convergence information to the screen. The trick to get rid of that is to use the `trace = FALSE` option as in:

```r
 asreml(trait_1 ~ 1, random = ~ mum, 
        data = current_trial, trace = FALSE)
```