---
title: "Breeding Ain't Noise Pollution"
date: "2025-06-23T18:00+12:00"
url: /2025/06/23/breeding-aint-noise-pollution
tags:
 - breeding
 - linkedin
---

Haven't been writing much about breeding and quantitative genetics lately, which means that I've been playing with my usual obsessions. Any book will tell you that genetic trials are at the core of any breeding programme: we use the phenotypes for predicting breeding values, estimating genetic parameters, training genomic models, etc. 

Trials are very valuable but also very expensive to establish and maintain. As a forester, I'm envious of crop breeders with their flat terrains, tidy trials and (mostly) homogeneous sites. In contrast, we live in a wrinkled, bumpy world, with sometimes strong within-trial trends. This means that we have to remove lots of environmental noise (see! there was a connection with the title) to observe a clear genetic signal.

When analysing trials, we typically have to account for experimental design components (replicates, incomplete blocks, plots, whatever) and mating design components (additive genetic effects, family effects, clonal replicates, etc). Then we have to deal with, technical term, all the other crap: autoregressive row and column effects & spatial variance in large trials, for example. However, we can use even more information; for example we can fit a Digital Elevation Model to remove even more noise. This model can come from either a drone with Aerial Laser Scanning or, even easier, they are freely available at 1 m resolution [for most of New Zealand](https://data.linz.govt.nz/layer/121859-new-zealand-lidar-1m-dem/).

I've seen (or read) several posts of people looking at enviromics to explain differences in genotype performance across locations. In my opinion, in our tree breeding programmes we have to sort two problems before getting a reasonable result for this approach:

1. Filtering out the within-environment noise with good experimental designs (I believe you should consider software like CycDesigN) because simple RCB designs just leave too much money on the table. This also means using a very flexible software for running the analyses. It will be no surprise that I highly recommend asreml-R (or stand alone if you aren't an R person).
2. Sorting out the connectedness between sites/locations/environments. Poor connectedness has the potential of really screwing up our understanding of GxE interactions and we could end up attributing noisy changes to the wrong environmental variables. At this point, we want to combine our complex within-environment analyses across multiple (perhaps many) environments. Surprise! asreml-R is one of the best options for doing this. (**)

The better our trials and their analyses, the more gain we achieve for the same investment. It doesn't matter if we're hashtag#breeding trees, peas or melons. 

(*) The post title is a tribute to AC/DC's [Rock And Roll Ain't Noise Pollution](https://www.youtube.com/watch?v=X_IWlPHMziU)
(**) This is a genuine endorsement of VSN products, for which I receive no payment. VSN people: just in case, my t-shirt size is Medium.

![Old phot of a recently installed radiata pine progeny trial in Tasmania.](/assets/images/trial-in-tasmania.jpg)