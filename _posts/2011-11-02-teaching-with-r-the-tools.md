---
id: 372
title: 'Teaching with R: the tools'
date: '2011-11-02T05:00:00+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=372'
permalink: /2011/11/02/teaching-with-r-the-tools/
classic-editor-remember:
    - classic-editor
    - classic-editor
tags:
    - stats
---

I bought an Android phone, nothing fancy just my first foray in the smartphone world, which is a big change coming from the dumb phone world<sup>(\*)</sup>. Everything is different and I am back at being a newbie; this is what many students feel the same time they are exposed to R. However, and before getting into software, I find it useful to think of teaching from several points of view, considering that there are several user cases:

1. *A few* of the students will get into statistics and heavy duty coding, they will be highly motivated and take several stats courses. It is in their best interest to learn R (and other software) very well.
2. *Some*, but not many, of the students will use statistics once in while. A point and click GUI may help to remember commands.
3. *Most* students will have to consume statistics, read reports, request information from colleagues and act as responsible, statistically literate citizens. I think that concepts (rather than software) are far the most relevant element to this group.

The first group requires access to all the power in R and, very likely, has at least a passing idea of coding in other languages. The second and third groups are occasional users, which will tend to forget the language and notation and most likely will need a system with menus.

At this point, some of the readers may be tempted to say that everyone (that is groups 1—3) should learn to write R code and they just need a good text editor (say `Emacs`). This may come as a surprise but normal people not only do not use text editors, they even don’t know what they are. You could be tempted to say that having a good editor would also let them write in `LaTeX` (or `XeLaTeX`), which is an excellent way to ‘future proof’ your documents. Please let me repeat this: normal people do not write in `LaTeX`, they use `Word` or something equivalent.

But, but. Yes, I know, *we are not* normal people.

## What are the problems?

When working in my Ph.D. I had the ‘brilliant’ (a.k.a. masochistic) idea of using different languages for each part of my project: Fortran 90 (Lahey), ASReml, Python ([ActiveState](http://www.activestate.com/activepython)), Matlab and Mathematica. One thing that I experienced, was that working with a scripting language integrated with a good IDE (e.g. ActiveState Python or Matlab) was much more conducive to learning than a separate console and text editor. I still have fond memories of learning and using Python. This meandering description brings me back to what we should use for teaching.

Let’s be honest, the stock R IDE that one gets with the initial download is spartan if you are in OS X and plain sucky if you are in Windows. Given that working with the console plus a text editor (`Emacs`, `Vim`, `Textmate`, etc) is an uncomfortable learning experience (at least in my opinion) there is a nice niche for IDEs like [RStudio](http://www.rstudio.org/), which integrate editor, data manager, graphs, etc.; particularly if they are cross-platform. Why is that RStudio is not included as the default R IDE? (Incidentally, I have never used Revolution R Productivity Environment—Windows only—that looks quite cool).

Today I am tempted to recommend moving the whole course to `RStudio`, which means installing it in an awful lot of computers at the university. One of the issues that stops me is that is introducing another layer of abstraction to R. We have the plain-vanilla console, then the normal installation and, on top, RStudio. On the other hand, we are already introducing an extra level with R commander.

At this point we reach the point-and-click GUI. The last two years we have used [R Commander](https://web.archive.org/web/20110716024654/http://socserv.socsci.mcmaster.ca/jfox/Misc/Rcmdr/index.html), which has helped, but I have never felt entirely comfortable with it. This year I had a chat with some students that used SPSS before and, after the initial shock, they seemed to cope with R Commander. In a previous post [someone](/2011/10/22/teaching-with-r-the-switch/#comments) suggested [Deducer](http://www.deducer.org/pmwiki/pmwiki.php?n=Main.DeducerManual), which I hope to check before the end of this year. I am always on the look out for a good and easy interface for students that fall in the second and third cases (see above). Please let me know if you have any suggestions.

<sup>(\*)</sup>This is not strictly true, as I had a Nokia E72, which was a dumb phone with a lot of buttons pretending to be a smartphone.

<sup>(\*\*)</sup>This post should be read as me thinking aloud and reflecting today’s impressions, which are continually evolving. I am not yet truly comfortable with any GUI in the R world, and still feel that `SPSS`, `Splus` or `Genstat` (for example) provide a nicer flow on the GUI front.