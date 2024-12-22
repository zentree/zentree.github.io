---
id: 622
title: 'An R wish list for 2012'
date: '2011-12-26T23:09:04+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=622'
permalink: /2011/12/26/an-r-wish-list-for-2012/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2011/12/rProject.jpg
tags:
    - stats
---

I expect there will be many reviews and wish lists for R this year, with many of them focusing on either running speed or dealing with large data sets. However, most issues that I would like to see tackled in R next year are not technical but, for lack of a better word, social.

Many users will first encounter R through the [r-project.org](http://www.r-project.org/) website. This site is begging for a redesign, which could start getting rid of the frames (which have sucked [since a long time ago](http://www.useit.com/alertbox/9612.html)). At a minimum, this would make pages much easier to bookmark.

The way we find, install and refer to packages could be better; both the main site and alternatives (like [crantastic](http://crantastic.org/)) do not help much to answer the question “Which package am I supposed to download?”. While folksonomies are cool (like in crantastic), they are far from sufficient and some level of curation (at the topic level, for example) could work much better. Sort of an improved version of [Task Views](http://cran.r-project.org/web/views/) with user comments, tags and indication of popularity. Tangent: if old users want packages to be called packages instead of libraries (as in most other software) the use of `library()` does not help.

![Help, I need somebody!](/assets/images/r-project.jpg)

Let’s combine a few issues for the second encounter of R users with reality. Most new (and not so new) users will require help, which involves easy access to mailing lists, because they contain the richest set of information in the R world. However, a good proportion of users will have very little idea of even the existence of the R mailing list; particularly younger people for whom email is not the primary form of communication. Old users always want people to search for answers in previous messages to avoid repeating the same question over and over again. **Solution:** put a prominent search field or link to searchable **R-help** list on the main page. The other mailing lists tend to be of secondary importance to newbies.

The third point should be consistency and meeting user expectations. In a [previous post](/2011/12/15/r-pitfall-3-friggin-factors/ "R pitfall #3: friggin’ factors") I discussed an example of broken expectations when dealing with factors. The user wants to deal with levels but by default R deals with the underlying numerical coding. Radford Neal presents other examples on [reversing sequences](http://radfordneal.wordpress.com/2008/08/06/design-flaws-in-r-1-reversing-sequences/) and using [curly brackets](http://radfordneal.wordpress.com/2010/08/15/two-surpising-things-about-r/) to speed up computation.

## R immigrants

Finally, be nice to newbies. Newbies are the functional equivalent to immigrants in a society (and I’m one myself). Immigrants induce dynamism in a society (and provide tasty alternatives to bland British food), push boundaries and, some times, challenge our beliefs. Newbies will keep the R community on its toes, forcing it to evolve and to be easier to use. Unless… unless we turn them away.

See you on the other side of the calendar.

P.S. Yes! Unless refers to Dr Seuss’s “Unless someone like you cares a whole awful lot, nothing is going to get better. It’s not.” in [The Lorax](http://en.wikipedia.org/wiki/The_Lorax).

P.S.2 I hope this text does not feel overly negative. R is the best thing since sliced bread, but it could be even better.