---
id: 99
title: 'Upgrading R (and packages)'
date: '2011-10-11T12:07:19+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=99'
permalink: /2011/10/11/upgrading-r-and-packages/
sharing_disabled:
    - '1'
    - '1'
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - stats
---

I tend not to upgrade R very often—running from 6 months to 1 year behind in version numbers—because I had to reinstall all packages: a real pain. A quick search shows that people have managed to come up with good solutions to this problem, as presented in [this stackoverflow thread](http://stackoverflow.com/questions/1401904/painless-way-to-install-a-new-version-of-r). I used the code in my mac:

```r
# Run in the old installation (pre-upgrade)
# saving a list of installed packages
setwd('~/Downloads')
package.list <- installed.packages()[, "Package"]
save(package.list, file='package-list.Rdata')

# Run in new install
setwd('~/Downloads')
load('package-list.Rdata')
for (p in setdiff(package.list, 
          installed.packages()[,"Package"])) {
  install.packages(p)
}

# Final output
Warning messages:
1: In getDependencies(pkgs, dependencies, available, lib) :
package ‘Acinonyx’ is not available (for R version 2.13.2)
2: In getDependencies(pkgs, dependencies, available, lib) :
package ‘AnimalINLA’ is not available (for R version 2.13.2)
3: In getDependencies(pkgs, dependencies, available, lib) :
package ‘asreml’ is not available (for R version 2.13.2)
4: In getDependencies(pkgs, dependencies, available, lib) :
package ‘INLA’ is not available (for R version 2.13.2)
5: In getDependencies(pkgs, dependencies, available, lib) :
package ‘graph’ is not available (for R version 2.13.2)
```

```r
# Installing INLA
source("http://www.math.ntnu.no/inla/givemeINLA.R")
inla.upgrade(testing=TRUE)
```

From all installed packages, I only had issues with 5 of them, which require installation from their respective websites: [Acinonyx](http://www.rforge.net/Acinonyx/), [INLA](http://www.r-inla.org/) (and AnimalINLA) and [asreml](https://vsni.co.uk/software/asreml-r/). Package graph is now available from <bioconductor.org>. INLA can be installed really easily from inside R (see below), while I did not bother downloading again asreml and just copied the folder from `~/Library/R/OldVersion/library/asreml` to `~/Library/R/CurrentVersion/library/asreml`.

Overall, it was a good upgrade experience, so thanks to the stackoverflow crowd for so many ideas on how to make R even nicer than it is.

P.S. 20100-10-14 [Similar instructions](http://onertipaday.blogspot.com/2008/10/r-upgrade-on-mac-os-x-1055-leopard.html), but including compiling R and installing bioconductor.