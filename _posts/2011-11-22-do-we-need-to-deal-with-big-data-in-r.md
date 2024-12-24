---
id: 459
title: 'Do we need to deal with &#8216;big data&#8217; in R?'
date: '2011-11-22T21:56:37+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=459'
permalink: /2011/11/22/do-we-need-to-deal-with-big-data-in-r/
classic-editor-remember:
    - block-editor
    - block-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2011/11/GenericTrialInTasmania.jpg
tags:
    - stats
---

David Smith at the Revolutions blog posted [a nice presentation](http://blog.revolutionanalytics.com/2011/11/analyzing-birth-rates-from-census-data-from-revoscaler.html) on “big data” (oh, how I dislike that term). It is a nice piece of work and the Revolution guys managed to process a large amount of records, starting with a download of 70GB and ending up with a series of linear regressions.

I’ve spent the last two weeks traveling (including a visit to the [trial below](http://maps.google.com.au/?ll=-41.162114,147.540894&spn=2.62609,5.806274&t=m&z=8&vpsrc=6)) and finishing marking for the semester, which has somewhat affected my perception on dealing with large amounts of data. The thing is that dealing with hotel internet caps (100MB) or even with my lowly home connection monthly cap (5GB) does get one thinking… Would I spend several months of internet connection just downloading data so I could graph and plot some regression lines for 110 data points? Or does it make sense to run a linear regression with two predictors using 100 million records?

My basic question is why would I want to deal with all those 100 million records directly in R? Wouldn’t it make much more sense to reduce the data to a meaningful size using the original database, up there in the cloud, and download the reduced version to continue an in-depth analysis? There are packages to query external databases (ROracle, RMySQL, RODBC, …, pick your poison), we can sample to explore the dataset, etc.

We **can** deal with a rather large dataset in our laptop but is it the best that we can do to deal with the underlying modeling problem? Just wondering.

![*Pinus radiata* breeding trial in Northern Tasmania.](/assets/images/
trial-in-tasmania.jpg)