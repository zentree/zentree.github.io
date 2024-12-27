---
id: 71
title: 'Reading HTML pages in R for text processing'
date: '2011-10-11T07:00:18+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=71'
permalink: /2011/10/11/reading-html-pages-in-r-for-text-processing/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
---

We were talking with one of my colleagues about doing some text analysis—that, by the way, I have never done before—for which the first issue is to get text in R. Not any text, but files that can be accessed through internet. In summary, we need to access an HTML file, parse it so we can access specific content and then remove the HTML tags. Finally, we may want to replace some text (the end of lines, `\n`, for example) before continue processing the files.

The package `XML` has the necessary functionality to deal with HTML, while the rest is done using a few standard R functions.

```r
library(XML)

# Read and parse HTML file
doc.html <- htmlTreeParse('/babel.html',
                          useInternal = TRUE)

# Extract all the paragraphs (HTML tag is p, starting at
# the root of the document). Unlist flattens the list to
# create a character vector.
doc.text <- unlist(xpathApply(doc.html, '//p', xmlValue))

# Replace all by spaces
doc.text <- gsub('\n', ' ', doc.text)

# Join all the elements of the character vector into a single
# character string, separated by spaces
doc.text <- paste(doc.text, collapse = ' ')
```

Incidentally, [this page](/2010/04/03/the-library-of-babel/) contains a translation of the short story 'The Library of Babel' by Jorge Luis Borges. Great story! We can repeat this process with several files and then create a corpus (and analyze it) using the `tm` package.