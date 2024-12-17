---
id: 1667
title: 'Remembering server installation details'
date: '2013-01-08T22:01:47+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1667'
permalink: /2013/01/08/remembering-server-installation-details/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2013/01/driers.jpg
tags:
    - meta
---

I’ve been moving part of my work to university servers, where I’m just one more peasant user with little privileges. In exchange, I can access the jobs from anywhere and I can access multiple processors if needed. Given that I have a sieve-like memory, where configuration details quickly disappear through many small holes, I’m documenting the little steps needed to move my work environment there.

The server provides a default R installation but none of the additional packages I often install are available (most people accessing the servers don’t use R). I could contact the administrator to get them installed, but I’ve opted for installing them under my user space. For that I followed the instructions presented [here](http://answers.stat.ucla.edu/groups/answers/wiki/1e5f7/), which in summary require adding the name of the default folder (`/hpc/home/luis/rpackages`) for the local library of packages to my .bashrc file:

```r
R_LIBS="/hpc/home/luis/rpackages"
export R_LIBS
```

I also have a temporary folder (called `rpackages`)in the account where I move the source of the packages to be installed (using SFTP). Once the R session is started it is possible to check that the local folder is first in the library path, confirming that `R_LIBS` has been made available to R.

Then I can install the packages I moved to the server with SFTP from the temporary folder to the local library using `install.packages()`.

```r
.libPaths()
# [1] "/hpc/home/luis/rpackages"
# [2] "/hpc/home/projects/packages/local.linux.ppc/pkg/R/2.15.1/lib64/R/library"
#
install.packages("~/temporary/plyr_1.8.tar.gz", 
                 lib="/hpc/home/luis/rpackages", 
                 repos=NULL)

# * installing *source* package 'plyr' ...
# ** package 'plyr' successfully unpacked and MD5 sums checked
# ** libs
# gcc -std=gnu99 -I/usr/local/pkg/R/2.15.1/lib64/R/include -DNDEBUG      -fPIC  -O2  -c loop-apply.c -o loop-apply.o
# gcc -std=gnu99 -I/usr/local/pkg/R/2.15.1/lib64/R/include -DNDEBUG      -fPIC  -O2  -c split-numeric.c -o split-numeric.o
# gcc -std=gnu99 -shared -Wl,--as-needed -o plyr.so loop-apply.o split-numeric.o
# installing to /hpc/home/luis/rpackages/plyr/libs
# ** R
# ** data
# **  moving datasets to lazyload DB
# ** inst
# ** preparing package for lazy loading
# ** help
# *** installing help indices
# ** building package indices
# ** testing if installed package can be loaded
#
# * DONE (plyr)
```

Now we can load the package as normal:

```r
library(plyr)
# Loading required package: plyr
```

Nothing complicated or groundbreaking, just writing down the small details before I forget them.

![Gratuitous picture: just different hardware, Christchurch.](/assets/images/driers.jpg)