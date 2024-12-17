---
id: 2016
title: 'My take on the USA versus Western Europe comparison of GM corn'
date: '2013-07-04T20:27:26+12:00'
mathjax: true
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=2016'
permalink: /2013/07/04/my-take-on-the-usa-versus-western-europe-comparison-of-gm-corn/
tags:
    - breeding
    - stats
---

A few days ago I came across Jack Heinemann and collaborators’ [article](http://www.tandfonline.com/doi/full/10.1080/14735903.2013.806408) (Sustainability and innovation in staple crop production in the US Midwest, Open Access) comparing the agricultural sectors of USA and Western Europe<sup>‡</sup>. While the article is titled around the word sustainability, the main comparison stems from the use of Genetically Modified crops in USA versus the absence of them in Western Europe.

I was curious about part of the results and discussion which, [in a nutshell](http://explore.tandfonline.com/page/est/tags-jack-heinemann), suggest that *“GM cropping systems have not contributed to yield gains, are not necessary for yield gains, and appear to be eroding yields compared to the equally modern agroecosystem of Western Europe”*. The authors relied on several crops for the comparison (Maize/corn, rapeseed/canola<sup>see P.S.6</sup>, soybean and cotton); however, I am going to focus on a single one (corn) for two reasons: 1. I can’t afford a lot of time for blog posts when I should be preparing lectures and 2. I like eating corn.

When the authors of the paper tackled corn the comparison was between the USA and Western Europe, using the [United Nations definition](http://en.wikipedia.org/wiki/Western_europe#United_Nations) of Western Europe (i.e. Austria, Belgium, France, Germany, Liechtenstein, Luxembourg, Monaco, Netherlands, Switzerland). Some large [European corn producers](http://www.cepm.org/maize_key_figures.php?lang=en) like Italy are not there because of the narrow definition of Western.

I struggled with the comparison used by the authors because, in my opinion, there are potentially so many confounded effects (different industry structures, weather, varieties, etc.) that it can’t provide the proper counterfactual for GM versus non-GM crops. Anyway, I decided to have a look at the same data to see if I would reach the same conclusions. The article provides a good description of where the data came from, as well as how the analyses were performed. Small details to match exactly the results were fairly easy to figure out. I downloaded the [FAO corn data (3.7 MB csv file)](/assets/uploads/FAOcorn.csv) for all countries (so I can reuse the code and data later for lectures and assignments). I then repeated the plots using the following code:

```r
# Default directory
setwd('~/Dropbox/quantumforest')

# Required packages
library(ggplot2)
library(labels)

# Reading FAO corn data
FAOcorn <- read.csv('FAOcorn.csv')

# Extracting Area
FAOarea <- subset(FAOcorn, Element == 'Area Harvested',
                  select = c('Country', 'Year', 'Value'))

names(FAOarea)[3] <- 'Area'

# and production
FAOprod <- subset(FAOcorn, Element == 'Production',
                  select = c('Country', 'Year', 'Value'))

names(FAOprod)[3] <- 'Production'

# to calculate yield in hectograms
FAOarea <- merge(FAOarea, FAOprod, by = c('Country', 'Year'))
FAOarea$Yield <- with(FAOarea, Production/Area*10000)

# Subsetting only the countries of interest (and years to match paper)
FAOarticle <- subset(FAOarea, Country == 'United States of America' | 
                              Country == 'Western Europe')

# Plot with regression lines
ggplot(FAOarticle, aes(x = Year, y = Yield, color = Country)) +
  geom_point() + stat_smooth(method = lm, fullrange = TRUE, alpha = 0.1) +
  scale_y_continuous('Yield [hectograms/ha]', limits = c(0, 100000), labels = comma) +
  theme(legend.position="top")
```

![Figure 1. Corn yield per year for USA and Western Europe.](/assets/images/corn-regression2.png)

I could obtain pretty much the same regression model equations as in the article by expressing the years as deviation from 1960 as in:

```r
# Expressing year as a deviation from 1960, so results
# match paper
FAOarticle$NewYear <- with(FAOarticle, Year - 1960)

usa.lm <- lm(Yield ~ NewYear, data = FAOarticle,
             subset = Country == 'United States of America')
summary(usa.lm)

#Call:
#lm(formula = Yield ~ NewYear, data = FAOarticle, subset = Country ==
#    "United States of America")
#
#Residuals:
#     Min       1Q   Median       3Q      Max
#-18435.4  -1958.3    338.3   3663.8  10311.0
#
#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)
#(Intercept) 38677.34    1736.92   22.27|t|)
#(Intercept) 31510.14    1665.90   18.91
```

Heinemann and collaborators then point out the following:

> ...the slope in yield increase by year is steeper in W. Europe ($$y = 1344.2x + 31512, R^2 = 0.92084$$) than the United States ($$y = 1173.8x + 38677, R^2 = 0.89093$$) from 1961 to 2010 (Figure 1). <em>This shows that in recent years W. Europe has had similar and even slightly higher yields than the United States despite the latter's use of GM varieties.</em>

However, that interpretation using all data assumes that both 'countries' are using GMO all the time. An interesting thing is that USA and Western Europe were in different trends <strong>already before the introduction of GM corn</strong>. We can state that because we have some idea of when GM crops were introduced in the USA. This information is collected by the US Department of Agriculture in their June survey to growers and made <a href="http://www.ers.usda.gov/data-products/adoption-of-genetically-engineered-crops-in-the-us.aspx">publicly available</a> at the State level (<a href="/assets/uploads/GMcornPenetration.csv">GMcornPenetration.csv</a>):

[Figure 2. GM corn percentage by state in the USA.](/assets/images/corn-penetration.png)

This graph tells us that by the year 2000 the percentage of planted corn was way below 50% in most corn producing states (in fact, it was 25% at the country level). From that time on we have a steady increase reaching over 80% for most states by 2008. Given this, it probably makes sense to assume that, at the USA level, yield reflects non-GM corn until 1999 and progressively reflects the effect of GM genotypes from 2000 onwards. This division is somewhat arbitrary, but easy to implement.

We can repeat the previous analyzes limiting the data from 1961 until, say, 1999:

```r
usa.lm2 <- lm(Yield ~ NewYear, data = FAOarticle,
              subset = Country == 'United States of America' & Year < 2000)
summary(usa.lm2)

#Call:
#lm(formula = Yield ~ NewYear, data = FAOarticle, subset = Country ==
#    "United States of America" & Year < 2000)
#
#Residuals:
#   Min     1Q Median     3Q    Max
#-17441  -2156   1123   3989   9878
#
#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)
#(Intercept) 39895.57    2084.81   19.14  < 2e-16 ***
#NewYear      1094.82      90.84   12.05 2.25e-14 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#Residual standard error: 6385 on 37 degrees of freedom
#Multiple R-squared:  0.797,    Adjusted R-squared:  0.7915
#F-statistic: 145.2 on 1 and 37 DF,  p-value: 2.245e-14

weu.lm2 <- lm(Yield ~ NewYear, data = FAOarticle,
              subset = Country == 'Western Europe' & Year < 2000)
summary(weu.lm2)

#Call:
#lm(formula = Yield ~ NewYear, data = FAOarticle, subset = Country ==
#    "Western Europe" & Year < 2000)
#
#Residuals:
#   Min     1Q Median     3Q    Max
#-10785  -3348    -34   3504  11117
#
#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)
#(Intercept) 29802.17    1813.79   16.43
```

These analyses indicate that Western Europe started with a lower yield than the USA (29,802.17 vs 39,895.57 hectograms/ha) and managed to increase yield much more quickly (1,454.48 vs 1,094.82 hectograms/ha per year) <strong>before any use of GM corn</strong> by the USA. Figure 1 shows a messy picture because there are numerous factors affecting yield each year (e.g. weather has a large influence). We can take averages for each decade and see how the two 'countries' are performing:

```r
# Aggregating every decade.
# 2013-07-05 20:10 NZST I fixed the aggregation because it was averaging yields rather
# calculating total production and area for the decade and then calculating average yield
# Discussion points are totally valid
FAOarticle$Decade <- cut(FAOarticle$Year,
                         breaks = seq(1959, 2019, 10),
                         labels = paste(seq(1960, 2010, 10), 's', sep = ''))

decadeProd <- aggregate(Production ~ Country + Decade,
                        data = FAOarticle,
                        FUN = sum)

decadeArea <- aggregate(Area ~ Country + Decade,
                        data = FAOarticle,
                        FUN = sum)

decadeYield <- merge(decadeProd, decadeArea, by = c('Country', 'Decade'))
decadeYield$Yield <- with(decadeYield, Production/Area*10000)

ggplot(decadeYield, aes(x = Decade, y = Yield, fill = Country)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  scale_y_continuous('Yield [hectograms/ha]', expand = c(0, 0)) +
  theme(legend.position="top")
```

![Figure 3. Corn yield by decade.](/assets/images/decade-yield-1.png)

This last figure requires more attention. We can <em>again</em> see that Western Europe starts with lower yields than the USA; however, it keeps on increasing those yields faster than USA, overtaking it during the 1990s. Again, all this change happened <strong>while both USA and Western Europe were not</strong> using GM corn. The situation <strong>reverses</strong> in the 2000s, when the USA overtakes Western Europe, <strong>while the USA continuously increased the percentage of GM corn</strong>. The last bar in Figure 3 <strong>is misleading</strong> because it includes a single year (2010) and we know that yields in USA went down in 2011 and 2012, affected by a very large drought (see Figure 4).

At least when looking at corn, I can't say (with the same data available to Heinemann) that there is no place or need for GM genotypes. I do share some of his concerns with respect to the low level of diversity present in staple crops but, in contrast to his opinion, I envision a future for agriculture that includes large-scale operations (either GM or no-GM), as well as smaller operations (including organic ones). I'd like to finish with some optimism looking further back to yield, because the <a href="http://www.nass.usda.gov/">USDA National Agricultural Statistics Service</a> keeps yield statistics for corn <a href="/assets/uploads/NASScorn.csv">since 1866(!)</a> (csv file), although it uses bizarre non-metric units (bushels/acre). As a metric boy, I converted to kilograms per hectare (multiplying by 62.77 from <a href="http://www.extension.iastate.edu/agdm/wholefarm/html/c6-80.html">this page</a>) and then to hectograms (100 g) multiplying by 10.

```r
# Reading NASS corn data
NASS <- read.csv('NASScorn.csv')

# Conversion to sensical units (see Iowa State Extension article)
# http://www.extension.iastate.edu/agdm/wholefarm/html/c6-80.html
NASS$Yield <- with(NASS, Value*62.77*10)

# Average by decade
NASS$Decade <- cut(NASS$Year,
                   breaks = seq(1859, 2019, 10),
                   labels = paste(seq(1860, 2010, 10), 's', sep = ''))

oldYield <- aggregate(Yield ~ Decade, data = NASS, FUN = mean)

# Plotting
ggplot(oldYield, aes(x = Decade, y = Yield)) +
  geom_bar(stat = 'identity') +
  scale_y_continuous('Yield [hectograms]', expand = c(0, 0))
```

![Figure 4. Historic average yield per decade for USA](/assets/images/old-yields.png)

It is interesting to see that there was little change until the 1940s, with the advent of the Green Revolution (modern breeding techniques, fertilization, pesticides, etc.). The 2010s decade in Figure 4 includes 2010, 2011 and 2012, with the last two years reflecting extensive <a href="http://www.nytimes.com/interactive/2012/07/20/us/drought-footprint.html?_r=0">droughts</a>. Drought tolerance is one of the most important traits in modern breeding programs.

![Drought’s Footprint map produced by The New York Times. This can help to understand the Decade patterns in previous figures.](/assets/images/drought-map-matrix.png)

<sup>‡</sup> While Prof. Heinemann and myself work for the same university I don't know him in person.

P.S. Did you know that <a href="http://en.wikipedia.org/wiki/Norman_Borlaug#Early_life.2C_education_and_family">Norman Borlaug</a> (hero of mine) studied forestry?

P.S.2 Time permitting I'll have a look at other crops later. I would have liked to test a regression with dummy variables for corn to account for pre-2000 and post-1999, but there are not yet many years to fit a decent model (considering natural variability between years). We'll have to wait for that one.

P.S.3 I share some of Heinemann's concerns relating to subsidies and other agricultural practices.

P.S.4 In case anyone is interested, I did write about a <a href="/2013/06/ordinal-logistic-gm-pigs/">GM-fed pigs study</a> not long ago.

P.S.5 2013-07-05 20:10 NZST. I updated Figures 1 and 3 to clearly express that yield was in hectograms/ha and recalculated average decade yield because it was originally averaging yields rather calculating total production and area for the decade and then calculating average yield. The discussion points I raised are still completely valid.

P.S.6 2013-07-07 11:30 NZST. The inclusion of <em>Canadian</em> canola does not make any sense because, as far as I know, Canada is not part of Western Europe or the US Midwest. This opens the inclusion of crops from any origin as far as the results are convenient for one's argument.

P.S.7 2014-08-06 13:00 NZST My comment was expanded and published <a href="http://dx.doi.org/10.1080/14735903.2014.939842">in the journal</a> (or here for <a href="/2014/07/comment-on-sustainability-and-innovation-in-staple-crop-production-in-the-us-midwest/">HTML version</a> with comments on the authors' reply to my comment.