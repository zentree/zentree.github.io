---
id: 4817
title: 'Sense-checking data'
date: '2023-04-07T10:04:49+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=4817'
permalink: /2023/04/07/sense-checking-data/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2023/04/carpark.jpg
tags:
    - stats
---

Over the birdsite dumpster fire. Emily Harvey was asking (I had to remove the link because, sensibly, she closed her account):

> do you know of any good guidelines/advice for what one should do to sense check and make sure they understand any data before using it?

I replied the following: Typically, I might be very familiar with the type of data and its variables (if it is one of my trials) or chat/email multiple times with the owner of the dataset(s) so I can check that:

- units and recorded values match. If units are mm, for example, the magnitudes should make sense in mm.
- the order of assessments and experimental/sampling design match: people often get lost in trials or when doing data collection, recording the wrong sampling unit codes.
- dates are OK. I prefer 2023-04-07; anyway, this is often a problem when dealing with Excel data.
- if we are using environmental data that it matches my expectation about the site. Have found a few weather station problems doing that, where rainfall was too low (because there was a sensor failure).
- the relationship between variables are OK. Example of problems: tall and too skinny trees, fat and short ones, suspicious (unless broken, etc), diameter under bark smaller than over bark, big etc.
- levels of factor match planned levels (typically there are spelling mistakes and there are more levels). Same issue with locality names.
- map coverage/orientation is OK (sometimes maps are sideways). Am I using the right projection?
- joins retain the appropriate number of rows (I mean table joins using merge or left\_join in R, etc).
- Missing values! Are NA coded correctly or with zeros, negative numbers? Are they “random”?
- If longitudinal data: are older observations larger (or do we get shrinking trees?)
- etc

Of course these questions are dataset dependent and need to be adapted to each separate situation. Finally: **Do results make any sense?**

![Unrelated carpark, Christchurch.](/assets/images/carpark.jpg)