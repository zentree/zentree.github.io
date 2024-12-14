---
id: 2113
title: 'Comment on Sustainability and innovation in staple crop production in the US Midwest'
date: '2014-07-29T10:52:46+12:00'
mathjax: true
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=2113'
permalink: /2014/07/29/comment-on-sustainability-and-innovation-in-staple-crop-production-in-the-us-midwest/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - breeding
    - research
    - stats
---

After writing a blog post about the paper “Sustainability and innovation in staple crop production in the US Midwest” I decided to submit a formal comment to the International Journal of Agricultural Sustainability in July 2013, which was published today. As far as I know, Heinemann et al. provided a rebuttal to my comments, which I have not seen but that should be published soon. This post is an example on how we can use open data (in this case from the USDA and FAO) and free software (R) to participate in scientific discussion (see supplementary material below).

The text below the \*\*\* represents my author’s version provided as part of my Green Access rights. The article published in the International Journal of Agricultural Sustainability \[copyright Taylor &amp; Francis\]; is freely available online at <http://dx.doi.org/10.1080/14735903.2014.939842>).

While I had many issues with the original article, I decided to focus on three problems—to make the submission brief and fit under the 1,000 words limit enforced by the journal editor. The first point I make is a summary of my [previous post](/2013/07/my-take-on-the-usa-versus-western-europe-comparison-of-gm-corn/) on the article, and then move on to two big problems: assuming that only the choice of biotechnology affects yield (making the comparison between USA and Western Europe inadequate) and comparing use of agrochemicals at the wrong scale (national- versus crop-level).

**PS 2014-08-05 16:30:** Heinemann et al.’s reply to my comment is [now available](http://www.tandfonline.com/doi/full/10.1080/14735903.2014.939843).

- They state that “Apiolaza did not report variability in the annual yield data” and that they had to ‘reconstruct’ my figure. Firstly, the published figure 2 does include error bars and, secondly, the data and R code are available as supplementary information (in contrast to their original paper). Let’s blame the journal for not passing this information to them.
- They also include 2 more years of data (2011 &amp; 2012), although the whole point of my comment is that the conclusions they derived with the *original* data set were not justified. Heinemann et al. are right in that yields in 2011 &amp; 2012 were higher in Western Europe than in the USA (the latter suffering a huge drought); however, in 2013 it was the opposite: 99,695 Hg/ha for USA vs 83,724 Hg/ha for Western Europe.
- They question that I commented only on one crop, although I did cover another crop (wheat) quickly with respect to the use of pesticides—but not with the detail I wanted, as there was a 1,000 words limit. I would have also mentioned the higher variability for Western European wheat production, as it is weird that they pointed out that high variability is a problems for USA maize production but said nothing for wheat in Europe.
- Furthermore, they also claimed “There is no statistically significant difference in the means over the entire 50-year period” however, a naive paired t-test `t.test(FAOarticle$Yield[1:50], FAOarticle$Yield[51:100], paired = TRUE)` (see full code below) says otherwise.

\*\*\*

> ## Abstract
> 
> This comment highlight issues when comparing genetically modified (GM) crops to non-GM ones across countries. Ignoring structural differences between agricultural sectors and assuming common yield trajectories before the time of introduction of GM crops results on misestimating the effect of GM varieties. Further data collection and analyses should guide policy-makers to encourage diverse approaches to agriculture, rather than excluding specific technologies (like GM crops) from the onset.
> 
> **Keywords:** genetic modification; biotechnology; productivity; economics

In a recent article Heinemann et al. (2013) focused “on the US staple crop agrobiodiversity, particularly maize” using the contrast between the yield of Western Europe and United States as a proxy for the comparison between genetically modified (GM) maize versus non-GM maize. They found no yield benefit from using GM maize when comparing the United States to Western Europe.

In addition, Heinemann et al. contrasted wheat yields across United States and Western Europe to highlight the superiority of the European biotechnological package from a sustainability viewpoint.

I am compelled to comment on two aspects that led the authors to draw incorrect conclusions on these issues. My statistical code and data are available as supplementary material.

## 1. Misestimating the effect of GM maize varieties

Heinemann et al. used FAO data\[[↓](#SM1)\], from 1961 to 2010 inclusive, to fit linear models with yield as the response variable, country and year as predictors. Based on this analysis they concluded, “W. Europe has benefitted from the same, or marginally greater, yield increases without GM”. However, this assumes a common yield trajectory for United States and Western Europe before significant commercial use of GM maize, conflating GM and non-GM yields. GM maize adoption in United States has continually increased from 25% of area of maize planted in 2000 to the current 90% (Figure 1, United States Department of Agriculture 2013\[[↓](#SM2)\]).

![Figure 1: Adoption of GM maize in United States, expressed as percentage of planted area.](/assets/images/corn_penetration_1.png)

If we fit a linear model from 1961 to 1999 (last year with less than 25% area of GM maize) we obtain the following regression equations ($$y = 1094.8 x + 39895.6$$) (United States, R<sup>2</sup> = 0.80) and ($$y = 1454.5 x + 29802.2$$) (W. Europe, R<sup>2</sup> = 0.90). This means that Western Europe started with a considerably lower yield than the USA (29,802.2 vs 39,895.6 hg/ha) in 1961 but increased yields faster than USA (1,454.5 vs 1,094.8 hg/ha per year) before substantial use of GM maize. By 1999 yield in Western Europe was superior to that in United States.

This is even more evident in Figure 2, which shows average yield per decade, removing year-to-year extraneous variation (e.g. due to weather). Western European yields surpassed United States’s during the 1990s (Figure 2). This trend reverses in the 2000s, while United States simultaneously increased the percentage of planted area with GM maize, directly contradicting Heinemann et al.’s claim.

![Figure 2: Average maize yield (and standard error) per decade for United States and Western Europe. The 2010s include a single year to replicate the original data set (click to enlarge).](/assets/images/corn_yield_per_decade.png)

## 2. Ignoring structural differences between agricultural sectors

When discussing non-GM crops using wheat the authors state, “the combination of biotechnologies used by W. Europe is demonstrating greater productivity than the combination used by the United States”. This sentence summarizes one of the central problems of their article: assuming that, if it were not for the choice of biotechnology bundle, the agricultural sectors would have the same intrinsic yield, making them comparable. However, many inputs beside biotechnology affect yield. For example, Neumann et al. (2010) studied the spatial distribution of yield and found that in the Unites States “*access* can explain most of the variability in wheat efficiency. In the more remote regions land prices are lower and inputs are therefore often substituted by land leading to lower efficiencies”. Lower yields in United States make sense from an economic point of view, as land replaces more expensive inputs like agrochemicals.

Heinemann et al. support their case by comparing pesticide use between United States and France across *all* crops. However, what is relevant to the discussion is pesticide use for the crops being compared. European cereals, and wheat in particular, are the most widely fungicide-treated group of crops worldwide (Kucket al. 2012). For example, 27% of the wheat planted area in France was already treated with fungicides by 1979 (Jenkins and Lescar 1980). More than 30 years later in the United States this figure has reached only 19% for winter wheat (which accounts for 70% of planted area, NASS 2013). Fungicide applications result on higher yield responses (Oerke 2006).

## Final remarks

Heinemann et al. ignored available data on GM adoption when analysing maize yields. They also mistakenly treated biotechnological bundles as the only/main explanation for non-GMO yield differences between United States and Western Europe. These issues mean that the thrust of their general conclusion is unsupported by the available evidence. Nevertheless, their article also raised issues that deserve more consideration; e.g. the roles of agricultural subsidies and market concentration on food security.

Agricultural sustainability requires carefully matching options in the biotechnology portfolio to site-specific economic, environmental and cultural constraints. Further data collection and analyses should lead policy makers to encourage diverse approaches to agriculture, rather than excluding specific technologies (like GMOs and pesticides) from the onset.

## References

Heinemann, J. A., Massaro, M., Coray, D. S., Agapito-Tenfen, S. Z. and Wen, J. D. 2013. Sustainability and innovation in staple crop production in the US Midwest. *International Journal of Agricultural Sustainability* (available [here](http://dx.doi.org/10.1080/14735903.2013.806408)).

Jenkins, J. E. E. and Lescar, L. 1980. Use of foliar fungicides on cereals in Western Europe. *Plant Disease*, 64(11): 987-994 (behind [paywall](http://www.cabdirect.org/abstracts/19811371172.html)).

Kuck, K. H., Leadbeater, A. and Gisi, U. 2012. FRAC Mode of Action Classification and Resistance Risk of Fungicides. In: Krämer, W., Schirmer, U., Jeschke, P. and Witschel, M., eds., *Modern Crop Protection Compounds*. Wiley. 539-567.

NASS, 2013. Highlights: 2012 Agricultural Chemical Use Survey. Wheat. United States Department of Agriculture (available [here](http://www.nass.usda.gov/Surveys/Guide_to_NASS_Surveys/Chemical_Use/ChemUseHighlights-Wheat-2012.pdf)).

Neumann, K., Verburg, P. H., Stehfest, E., and Müller, C. 2010. The yield gap of global grain production: a spatial analysis. *Agricultural Systems*, 103(5), 316–326 (behind [paywall](http://www.sciencedirect.com/science/article/pii/S0308521X10000302)).

Oerke E. 2006. Crop losses to pests. *Journal of Agriculture Science*, 144: 31-43 (behind [paywall](http://journals.cambridge.org/action/displayAbstract;jsessionid=35E571C1CE193907EFD69714F3FF5B23.journals?fromPage=online&aid=431724), or [Free PDF](http://www.nrel.colostate.edu/ftp/nrel/ftp/conant/SLM-proprietary/Oerke_2006.pdf)).

United States Department of Agriculture. 2013. Adoption of Genetically Engineered Crops in the U.S. USDA Economic Research Service (available [here](http://www.ers.usda.gov/data-products/adoption-of-genetically-engineered-crops-in-the-us.aspx)).

## Supplementary material

You can replicate the analyses and plots produced in this comment using the following files:

- <a name="SM1"></a>Maize production data for United States and Western Europe ([csv](https://luis.apiolaza.net/wp-content/uploads/2013/07/FAOcorn1.csv), extracted from [FAO](http://faostat3.fao.org)). \[[↑](#FAOcorn)\]
- <a name="SM2"></a>GMO maize penetration data ([csv](/assets/uploads/GMcornPenetration1.csv), extracted from [USDA](http://www.ers.usda.gov/data-products/adoption-of-genetically-engineered-crops-in-the-us.aspx)). \[[↑](#GMpenetration)\]
- [R code for analyses](/assets/uploads/Comments-Analyses.R).