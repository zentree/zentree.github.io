---
id: 3202
title: 'Keeping track of research'
date: '2017-10-21T22:22:36+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=3202'
permalink: /2017/10/21/keeping-track-of-research/
classic-editor-remember:
    - classic-editor
image: /wp-content/uploads/2017/10/PA230001.jpg
tags:
    - programming
    - research
---

If you search for data analysis workflows for research there are lots of blog posts on using R + databases + git, etc. While in some cases I may end up working with a combination like that, it’s much more likely that reality is closer to a bunch of emailed Excel or CSV files.

Some may argue that one should move the whole group of collaborators to work *the right way*. In practice, well, not everyone has the interest and/or the time to do so. In one of our collaborations we are dealing with a trial established in 2009 and I was tracking a field coding mistake (as in happening outdoors, doing field work, assigning codes to trees), so I had to backtrack where the errors were introduced. After checking emails from three collaborators, I think I put together the story and found the correct code values in a couple of files going back two years.

The new analysis lives in an RStudio project with the following characteristics:

1. Folder in Dropbox, so it’s copied in several locations and it’s easy to share.
2. Excel or CSV files with their original names (warts and all), errors, etc. Resist the temptation to rename the files to sane names, so it’s easier to track back the history of the project.
3. R code
4. **Important part:** text file (Markdown if you want) documenting the names of the data files, who &amp; when they sent it to me.

Very low tech but, hey, it works.

![Warts and all: fight your inner OCD and keep original file names](/assets/images/screenshot.jpg)