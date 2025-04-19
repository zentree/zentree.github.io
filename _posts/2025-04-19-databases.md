---
layout: post
title: Databases
date: 2025-04-19 12:50 +1200
tags:
    - breeding
    - linkedin
---

Mindblown. That's the first reaction when I start thinking of 
how much data availability has changed in breeding programmes. 
It is one of many changes that makes programmes
so different from the past, 
although one can still recognise the essential components.

In tree breeding we used to establish designed experiments 
overlaying experimental designs and mating designs. Typically, 
trees are the experimental units and there was a correspondence 
between trees and measurements. In many programmes
the trial would be assessed only once, so one could get something like: 
`tree_id diameter height` etc. Many programmes used structures like this,
which involved adding columns to the table every time you added new traits.
I am talking about people keeping Lotus 123, Quattro Pro, etc 
to record assessments.

Later someone decided to measure the trial again, which meant 
the data could end up looking like `tree_id diam_5 ht_5 diam_10 ht_10`. 
It was messy, so eventually someone would say 
'What about we normalise the table?', which would look like
`tree_id age trait_name value` so one could have any number of traits,
assessed any number of times without changing the structure of the table.

At some point, breeding programmes start taking more complex measurements.
Say I want to predict pulp yield; pulping a tree is difficult and expensive
but I could use Near Infrared Spectroscopy (NIR) to do so. The NIR machine
I usually access has 1,296 wavelengths, which I could use to predict 
not only pulp yield but many other wood properties. 
I could store only the predicted pulp yield, 
but it is likely I will reuse the spectra, 
so we need to figure out the data structure for that. 
Moreover, it is possible that during the life of the breeding programme
I will use different machines with varying numbers of wavelengths.
My data table structure has to account for this.
We also use SNPs for the genomics side of things. 10K, 30K, 60K... 
and many more if you deal with animals. 
Storing the wavelengths is a tiny problem compared to this.

And now we have other remote sensing assessments, 
which are done at the trial scale
but the results are often referred to the tree level. LiDAR, for example.
We get a point cloud from which we can derive tree metrics
which are then converted to multiple selection criteria. It could also be
hyperspectral images from a drone, thermal cameras, etc.
All of them with different complexity and, potentially, 
different models.

And all this complexity is only dealing with tree-level assessments.
There are, of course, other tables that keep track of the pedigree
and experimental design for each tree (which don't change
from trait to trait). We also have to deal with the trial-level information:
location, design, management, etc.

By now you get the idea; data management shifted from being a complex problem
to a very complex problem, at least for doing it properly. 
There was a time when a couple of us could put it together,
but now one is better off getting a commercial breeders' database
(or multiple systems).

I was having a chat about databases with a breeder who is using 
a forest trials database (trial admin), a breeding trials database
(typical phenotypic data) and a genomic database. 
All of them connect to asreml-R and to another single-step, heavy-duty
genetic prediction system. On top of that, there is a legacy database
from which there are old records that still need to be moved.
Not accounting, yet, for the remote sensing staff 
(millions or billions of points).

I would love to know how other people deal with this problem
today.

Photo: During the 2020 lockdown I was testing LiDAR processing
for our university campus.
![Testing tree locations with LiDAR, University of Canterbury](/assets/images/tree-locations.jpg)
