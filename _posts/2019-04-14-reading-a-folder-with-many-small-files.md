---
id: 3346
title: 'Reading a folder with many small files'
date: '2019-04-14T20:29:30+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=3346'
permalink: /2019/04/14/reading-a-folder-with-many-small-files/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2019/04/P1130303.jpg
tags:
    - programming
    - stats
---

One of the tools we use in our research is [NIR](https://en.wikipedia.org/wiki/Near-infrared_spectroscopy) (Near-Infrared Spectroscopy), which we apply to thousands of samples to predict their chemical composition. Each NIR spectrum is contained in a CSV text file with two numerical columns: wavelength and reflectance. All files have the same number of rows (1296 in our case), which corresponds to the number of wavelengths assessed by the spectrometer. One last thing: the sample ID is encoded in the file name.

As an example, the contents of file `A1-4-999-H-L.0000.csv` look like:

```
8994.82461,0.26393
8990.96748,0.26391
8987.11035,0.26388
8983.25322,0.26402
8979.39609,0.26417
...
```

Once the contents of all the files are stored in a single matrix, one can apply a bunch of algorithms to build a model, and then use the model to predict chemical composition for new observations. I am not concerned about that process in this blog post, but only about reading thousands of small files from R, without relying on calls to the operating system to join the small files and read a single large file.

As I see it, I want to:

- give R a folder name,
- get a list of all the file names in that folder,
- iterate over that list and keep only the second column for each of the files.
- join the elements of the list.

I can use `list.files()` to get the names of all files in a folder. Rather than using a explicit loop, it’s easier to use `lapply()` to iterate over the list of names and apply the `read.csv()` function to all of them. I want a matrix, but `lapply()` creates a list, so I joined all the elements of the list using `do.call()` to bind the rows using `rbind()`.

```R
spectra_folder <- "avery_raw_spectra"

read_spectra_folder <- function(folder) {
  # Read all files and keep second column only 
  # for each of them. Then join all rows
  spectra_list <- list.files(path = folder, full.names = TRUE)
  raw_spectra <- lapply(spectra_list, 
                        function(x) read.csv(x, header = FALSE)[,2])
  
  raw_spectra <- do.call(rbind, raw_spectra)
}
```

There are many ways to test performance, for example using the microbenchmark package. Instead, I'm using something rather basic, almost cute, the `Sys.time()` function:

```R
start <- Sys.time()
option1 <- read_spectra_folder(spectra_folder)
end <- Sys.time()
end - start
```

This takes about 12 seconds in my laptop (when reading over 6,000 files). I was curious to see if it would be dramatically faster with `data.table`, so I replaced `read.csv()` with `fread()` and joined the elements of the list using `rbindlist()`.

```R
library(data.table)

read_folder_dt <- function(folder) {
  spectra_list <- list.files(path = folder, full.names = TRUE)
  raw_spectra <-  lapply(spectra_list, 
                         function(x) fread(x, sep=",")[,2])
  
  raw_spectra <- rbindlist(raw_spectra)
}
```

Using the same basic timing as before this takes around 10 seconds in my laptop. I have the impression that packages like `data.table` and `readr` have been optimized for reading larg(ish) files, so they won't necessarily help much in this reading-many-small-files type of problem. Instead, I tested going back to even more basic R functions (`scan`), and adding more information about the types of data I was reading. Essentially, going back even closer to base R.

```R
read_folder_scan <- function(folder, prefix = 'F') {
  # Read all files and keep second column 
  # only for each of them. Then join all rows
  spectra_list <- list.files(path = folder, 
                             full.names = TRUE)
  raw_spectra <- lapply(spectra_list, 
                        function(x) matrix(scan(x, what = list(NULL, double()), 
                                           sep = ',', quiet = TRUE)[[2]], 
                                           nrow = 1))
  raw_spectra <- do.call(rbind, raw_spectra)
}
```

Timing this new version takes only 4 seconds, not adding any additional dependencies. Any of these versions is faster than the original code I inherited, that was growing a data frame with `rbind()` one iteration at the time.

![Literally tiny seedlings.](/assets/images/seedlings.jpg)