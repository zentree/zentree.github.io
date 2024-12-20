---
id: 3209
title: 'Reducing friction in R to avoid Excel'
date: '2017-11-11T17:45:42+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=3209'
permalink: /2017/11/11/reducing-friction-to-avoid-excel/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2017/11/IMG_2857.jpg
tags:
    - programming
---

When you have students working in a project there is always an element of quality control. Some times the results just make sense, while others we are suspicious about something going wrong. This means going back to check the whole analysis process: can we retrace all the steps in a calculation (going back to data collection) and see if there is anything funny going on? So we sat with the student and started running code (in RStudio, of course) and I noticed something interesting: there was a lot of redundancy, pieces of code that didn’t do anything or were weirdly placed. These are typical signs of code copied from several sources, which together with the presence of `setwd()` showed unfamiliarity with R and RStudio (we have a mix of students with a broad range of R skills).

But the part that really caught my eye was that the script read many Near Infrared spectra files, column bound them together with the sample ID (which was 4 numbers separated by hyphens) and saved the 45 MB file to a CSV file. *Then the student opened the file and split the sample ID into 4 columns, deleted the top row, saved the file and read it again into R to continue the process.*

The friction point which forced the student to drop to Excel—the first of many not easily reproducible parts—was variable splitting. The loop for reading the files and some condition testing was hard to follow too. If one knows R well, any of these steps is relatively simple, but if one doesn’t know it, the copy and pasting from many different sources begins, often with inconsistent programming approaches.

Here is where I think the `tidyverse` brings something important to the table: consistency, more meaningful naming of functions and good documentation. For example, doing:

```R
nir %>%
  separate(sample_id, c('block', 'tree', 'family', 'side'), 
           sep = '-') 
```

is probably the easiest way of dealing with separating the contents of a single variable.

When working with several collaborators (colleagues, students, etc) the easiest way to reduce friction is to convince/drag/supplicate everyone to adopt a common language. Within the R world, the `tidyverse` is the closest thing we have to a lingua franca of research collaboration. ‘But isn’t R a lingua franca already?’ you may ask. The problem is that programming in base R is often too weird for normal people, and too many people just give up before feeling they can do anything useful in R (particularly if they are proficient in Excel).

Even if you are an old dog (like me) I think it pays to change to a subset of R that is more learnable. And once someone gets hooked, the transition to adding non-tidyverse functions is more bearable.

![The data were coming from cores like this one.](/assets/images/cores-graph.jpg)