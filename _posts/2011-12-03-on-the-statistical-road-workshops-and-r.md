---
id: 514
title: 'On the (statistical) road, workshops and R'
date: '2011-12-03T23:35:16+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=514'
permalink: /2011/12/03/on-the-statistical-road-workshops-and-r/
classic-editor-remember:
    - classic-editor
    - classic-editor
tags:
    - stats
---

Things have been a bit quiet at Quantum Forest during the last ten days. Last Monday (Sunday for most readers) I flew to Australia to attend a couple of [one-day workshops](https://web.archive.org/web/20111129064927/http://www.biometrics.org.au/conferences/kiama2011/shortCourses.html); one on spatial analysis (in [Sydney](http://maps.google.com.au/?ll=-33.880962,151.205692&spn=0.045248,0.090723&t=m&z=14&vpsrc=6)) and another one on modern applications of linear mixed models (in [Wollongong](http://maps.google.com.au/?ll=-34.405493,150.878763&spn=0.022484,0.045362&t=m&z=15&vpsrc=6)). This will be followed by attending [The International Biometric Society Australasian Region Conference](https://web.archive.org/web/20111117102415/http://www.biometrics.org.au/conferences/kiama2011/index.html) in [Kiama](http://maps.google.com.au/?ll=-34.673488,150.858121&spn=0.021565,0.045362&t=m&z=15&vpsrc=6).

I would like to comment on the workshops to look for commonalities and differences. First, both workshops heavily relied on R, supporting the idea that if you want to reach a lot of people and get them using your ideas, R is pretty much **the** vehicle to do so. It is almost trivial to get people to install R and RStudio before the workshop so they are ready to go. “Almost” because you have to count on someone having a bizarre software configuration or draconian security policies for their computer.

The workshop on Spatial Analysis also used WinBUGS, which with all respect to the developers, is a clunky piece of software. Calling it from R or using JAGS from R seems to me a much more sensible way of using a Bayesian approach while maintaining access to the full power of R. The workshop on linear mixed models relied on [asreml-R](http://www.vsni.co.uk/software/asreml); if you haven’t tried it, please give it a go (it is a free license for academic/research use). There were applications on multi-stage experiments, composite samples and high dimensional data (molecular information). In addition, there was an initial session on optimal design of experiments.

In my opinion, the second workshop (modern applications…) was much more successful than the first one (spatial analysis…) for a few reasons:

- One has to limit the material to cover in a one-day workshop; if you want to cover a lot consider three days so people can digest all the material.
- One has to avoid the “split-personality” approach to presentations; having very-basic and super-hard but nothing in the middle is not a great idea (IMHO). Pick a starting point and gradually move people from there.
- Limit the introduction of new software. One software per day seems to be a good rule of thumb.

Something bizarre (for me, at least) was the difference between the audiences. In Sydney the crowd was a lot younger, with many trainees in biostatistics coming mostly from health research. They had little exposure to R and seemed to come from a mostly SAS shop. The crowd in Wollongong had people with a lot of experience (OK, oldish) both in statistics and R. I was expecting young people to be more conversant in R.

Tomorrow we will drive down to Kiama, sort out registration and then go to the welcome BBQ. Funny thing is that this is my first statistics conference; as I mentioned in the About page of this blog, I am a simple forester. 🙂