---
id: 2225
title: 'Using Processing and R together (in OS X)'
date: '2013-12-20T09:11:33+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=2225'
permalink: /2013/12/20/using-processing-and-r-together/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
    - stats
---

I wanted to develop a small experiment with a front end using the [Processing](http://processing.org) language and the backend calculations in R; the reason why will be another post. [This post](http://www.local-guru.net/blog/2010/08/10/calling-r-from-processing) explained the steps assuming that one already has R and Processing installed:

1. Install the [Rserve](http://rforge.net/Rserve/) package. This has to be done from source (e.g. using `R CMD INSTALL packagename`).
2. Download Rserve jar files and include them in the Processing sketch.
3. Run your code

For example, this generates 100 normal distributed random numbers in R and then sorts them (code copy and pasted from second link):

```c
import org.rosuda.REngine.Rserve.*;
import org.rosuda.REngine.*;

double[] data;

void setup() {
  size(300, 300);

  try {
    RConnection c = new RConnection();
    // generate 100 normal distributed random 
    // numbers and then sort them
    data = c.eval("sort(rnorm(100))").asDoubles();

  } catch ( REXPMismatchException rme ) {
      rme.printStackTrace();
  } catch ( REngineException ree ) {
      ree.printStackTrace();
  }
}

void draw() {
  background(255);
  for( int i = 0; i < data.length; i++) {
    line( i * 3.0, height/2, i* 3.0, height/2 - (float)data[i] * 50 );
  }
}
```

The problem is that this didn't work, because my OS X (I use macs) R installation didn't have shared libraries. My not-so-quick solution was to compile R from source, which involved:

1. Downloading R source. I went for the latest stable version, but I could have gone for the development one.
2. Setting up the latest version of C and Fortran compilers. I did have an outdated version of Xcode in my macbook air, but decided to delete it because i- uses many GB of room in a small drive and ii- it's a monster download. Instead I went for Apple's [Command Line Tools](https://developer.apple.com), which is a small fraction of size and do the job.
3. In the case of gfortran, there are many sites pointing to [this page](http://r.research.att.com/tools/) that hosts a fairly outdated version, which was giving me all sorts of problems (e.g. "checking for Fortran 77 name-mangling scheme") because the versions between the C and Fortran compilers were out of whack. Instead, I downloaded the latest version from the [GNU site](http://gcc.gnu.org/wiki/GFortranBinaries).
4. Changing the `config.site` file in a few places, ensuring that I had:

```
CC="gcc -arch x86_64 -std=gnu99"
CXX="g++ -arch x86_64"
F77="gfortran -arch x86_64"
FC="gfortran -arch x86_64"
```

Then compiled using (didn't want X11 and enabling shared library):

```
./configure --without-x --enable-R-shlib
make
make check
make pdf # This produces a lot of rubbish on screen and it isn't really needed
make info
```

And finally installed using: 

```
sudo make prefix=/luis/compiled install`
```

This used a prefix because I didn't want to replace my fully functioning R installation, but just having another one with shared libraries. If one types `R` in terminal then it is still calling the old version; the new one is called via: 

```/luis/compiled/R.framework/Versions/Current/Resources/bin/R
```

I then installed `Rserve` in the new version and was able to call R from processing so I could obtain.

![A 'hello world' of the calling R from Processing world.](/assets/images/sketch_processing.jpg)

Now I can move to what I really wanted to do. File under stuff-that-I-may-need-to-remember-one-day.