---
id: 786
title: 'Rstudio and asreml working together in a mac'
date: '2012-02-06T05:00:40+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=786'
permalink: /2012/02/06/rstudio-and-asreml-working-together-in-a-mac/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - asreml
    - stats
---

December and January were crazy months, with a lot of travel and suddenly I found myself in February working in four parallel projects involving quantitative genetics data analyses. (I’ll write about some of them very soon)

Anyhow, as I have pointed out [in repeated occasions](/tags/asreml/), I prefer asreml-R for mixed model analyses because I run out of functionality with nlme and lme4 very quickly. Ten-trait multivariate mixed model with a pedigree, anyone? I thought so. Well, there are asreml-R versions for Windows, Linux and OS X; unsurprisingly, I use the latter. Installation in OS X is not particularly complicated (just follow the instructions [in this PDF](http://www.mmontap.org/sites/default/files/install-asreml-R.pdf) file) and remember to add and export the following environment variables in your `.bash_profile`:

```
# Location of license file, usually installed
# under Applications, together with the console
# version of asreml
ASREML_LICENSE_FILE=/Applications/asreml3/bin/asreml.lic
export ASREML_LICENSE_FILE

# Location for dynamic library loading. The number will
# depend on R version (here is 2.13)
DYLD_LIBRARY_PATH=$LD_LIBRARY_PATH:/Users/lap44/Library/R/2.13/library/asreml/libs
export DYLD_LIBRARY_PATH
```

These instructions work fine if one uses asreml-R in a Terminal window or if one uses a text editor (`emacs + ESS`, `VIM + VIM-R`, `Textmate + R + R console` bundles, etc). However, I couldn’t get the default R GUI in OS X (`R.app`) or `Rstudio` (my favorite way to work with R these days) working.

I would use `library(asreml)` or `require(asreml)`, which would create no problems, but as soon as I used the function `asreml(...)` I would get an error message stating that I did not have a valid license. Frustrating to say the list (I even considered using emacs for the rest of my life, can you believe it?), because it meant that Rstudio was not being able to ‘see’ the environment variables (as posted [in this question](http://support.rstudio.org/help/discussions/problems/852-how-to-get-r-to-pay-attention-to-environmental-variables)). The discussion on that question points to a very useful part of the R help system, which explains the [startup process for R](http://stat.ethz.ch/R-manual/R-patched/library/base/html/Startup.html), suggesting a simple solution: **create an `.Renviron` file in your home directory**.

Thus, I simply copied the previously highlighted code in a text file called `.Renviron`, saved it in my home directory and I can now call asreml-R from Rstudio without any problems. This solution should also work for any other time when one would like to access environment variables from Rstudio for OS X. Incidentally, Rstudio is becoming really useful, adding ‘projects’ and integrating version control, which means that now I have a(n almost) self-contained working environment.

P.S. Note to self: While I was testing environment variables in my `.bash_profile` I wanted to refresh the variables without rebooting the computer. The easiest way to do so is typing <code>. .bash_profile</code> (yes, that starts with dot space). To check the exported value of a specific variable one can use the `echo` command as so `echo $ASREML_LICENSE_FILE`, which should return the assigned value (`/Applications/asreml3/bin/asreml.lic` in my case).