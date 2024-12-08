---
id: 4800
title: 'Flotsam 16: new laptop'
date: '2023-04-05T19:26:36+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=4800'
permalink: /2023/04/05/new-laptop/
classic-editor-remember:
    - block-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2023/04/Screenshot-2023-04-04-at-4.20.27-PM.png
tags:
    - meta
---

In my job I get a new laptop every 3 years or so; at least that is how it works with Apple laptops. You get a new one, together with Apple care, and it is depreciated during three years. Keeping computers for longer doesn’t make financial sense according to the bean counters. Coincidentally, it is roughly the time for the laptops to start falling apart, more likely by design.

On terms of features, I reached 1 TB SSD disk around 6 years ago (I don’t use half of that), 16 GB of RAM 3 years ago (I used to be quite comfortable with 8 GB of RAM 9 years ago or so. What I am trying to say is that spec-wise I’ve been OK for the last half decade, at least. The peak of my computing was a Macbook Air 13″ just before the appalling Macbook Pro 13″ butterfly keyboard fiasco. In 2020 I ordered a huge 16″ Macbook Pro, despite 13″ being my sweetspot for laptop size, because of COVID19. We didn’t know for how long we’d be working at home—which in NZ turned out to be not very long—so I ordered a larger screen and, gasp, a real ESC key (again). I don’t have much love for the 16″: too heavy, too noisy, meh battery life, got too hot, etc.

This time I went back to Macbook Pro 14″ because: real ESC key (ridiculous to mention this, but I was traumatised by the touch bar ESC), no touch bar (yay!), SD card slot (I like photography), HDMI connector (FINALLY!) so I can skip on one dongle, proper power connector. The screen notch looks funny, but it disappears from my mind when busy writing. Overall impression: solid, hefty, fast. It actually feels much faster than the 16″ with Intel processor.

I test a lot of software that I don’t end up using, R packages, etc. so I avoid moving my old setup to the new laptop, starting from scratch and avoid carrying over all the cruft accummulated over three years. Then it comes the unavoidable boring task of installing the software I need for my work (the university already install MS Office and other software that don’t use, like Endnote). I installed:

- `Homebrew`: unix package manager\*.
- `R` and `RStudio`: R stuff (see below for packages)\*.
- Apple command line tools: compiler, etc.
- `MacTex`: everything and the kitchen sink LaTeX for mac\*.
- `Zotero` (including `Zotfile` and `Better Bibtex` plugins)
- `Joplin`: notetaking in markdown\*
- `NetNewsWire`: reading RSS feeds, free, synchronises across mac and ipad\*.
- `Calibre`: e-book management\*.
- `Digikam`: photo management\*.
- `Rawtherapee`: RAW photo processing\*.
- Visual Studio Code: free text editor, don’t think it is fully open source.
- Neovim: text editor\*.
- pandoc: text transformer\*.
- asciidoctor: text transformer\*.

All starred (\*) items are Open Source Software.

I use numerous R packages, but when I start with a new computer I don’t compile a list of packages to import in the new machine (lots of cruft) but I add a few packages that I know I use often and then add when I need to. Included in this list:

- `tidyverse`: so I get ggplot, dplyr, reader, etc\*.
- `data.table`: sometimes I use this for fread() and data management\*.
- `asremlr`: multivariate + spatial genetic analyses.
- `rjags`: bayesian stuff\*.
- `rstan`: bayesian stuff\*.

I still have to install “a few” things (like QGIS) but I’m getting there. I’ll update the post later once I have added more software.

![Terminal screenshot.](/assets/images/terminal_screenshot_2023.jpg)