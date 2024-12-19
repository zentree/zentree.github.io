---
id: 1353
title: 'New Zealand School data'
date: '2012-09-24T11:42:03+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1353'
permalink: /2012/09/24/new-zealand-school-data/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - politics
    - stats
---

Some people have the naive idea that the national standards data and the decile data will not be put together. Given that at some point in time all data will be available, there is no *technical* reason to not have merged the data, which I have done in this post for an early release.

Stuff made data for the National Standards for a bit over 1,000 schools available [here as an Excel File](http://schoolreport.stuff.co.nz/index.html). I cleaned it up a bit to read it in R, saved it to csv format, of which you can get a copy [here](/assets/uploads/SchoolReport_data_distributable.csv). Decile data is available from the [Ministry of Education](http://www.minedu.govt.nz/NZEducation/EducationPolicies/Schools/SchoolOperations/Resourcing/OperationalFunding/Deciles/ReviewOfDecilesGeneralInformation.aspx), which I transformed to csv and uploaded [here](/assets/uploads/DecileChanges20072008.csv). We can now merge the datasets using R:

```r
options(stringsAsFactors = FALSE)

deciles <- read.csv('DecileChanges20072008.csv')
standards <- read.csv('SchoolReport_data_distributable.csv')

standards <- merge(standards, deciles, by = 'school.id')
```

But there are some name discrepancies in the merge, which we can check using:

```r
standards$name.discrepancy <- factor(ifelse(standards$school.name.x != standards$school.name.y, 1, 0))

tocheck <- subset(standards[, c(1, 2, 64, 77)], name.discrepancy == 1)
#    school.id                            school.name.x                          school.name.y name.discrepancy
#9          82              Aidanfield Christian School           Canterbury Christian College                1
#33        266                   Waipa Christian School                Bethel Christian School                1
#73        429                        Excellere College                 Kamo Christian College                1
#143      1245 Christ the King Catholic School (Owairak    Christ The King School (Mt Roskill)                1
#150      1256            Cornwall Park District School                   Cornwall Park School                1
#211      1360       Marist Catholic School (Herne Bay)              Marist School (Herne Bay)                1
#270      1500     St Leo's Catholic School (Devonport)             St Leos School (Devonport)                1
#297      1588 St Francis Xavier Catholic School (Whang   St Francis Xavier School (Whangarei)                1
#305      1650                  Drummond Primary School Central Southland Rural Primary School                1
#314      1678                   Te Kura o Waikaremoana                 Te Kura O Waikaremoana                1
#335      1744              Horahora School (Cambridge)                        Horahora School                1
#389      1991                  Tauranga Primary School                        Tauranga School                1
#511      2424                Parkland School (P North)                        Parkland School                1
#587      2663                 Reignier Catholic School             Reignier School (Taradale)                1
#627      2841        Fergusson Intermediate (Trentham)                 Fergusson Intermediate                1
#771      3213               Parklands School (Motueka)                       Parklands School                1
#956      3801               Pine Hill School (Dunedin)                       Pine Hill School                1
```

There are four schools that have very different names in the dataset: 82, 266, 429 and 1650. They may just have changed names or something could be wrong. At this point one may choose to drop them from any analysis; up to you. We then just rename the second variable to school.name and save the file to csv (available here [standards.csv](/assets/uploads/standards.csv) for your enjoyment).

```r
names(standards)[2] <- 'school.name'
write.csv(standards, 'standards.csv', 
          row.names = FALSE, quote = FALSE)
```

Now we should try to merge any other economic and social information available in Statistics New Zealand.

**Note 2012-09-26:** I have updated data and added a few plots [in this post](/2012/09/25/updating-and-expanding-new-zealand-school-data/).
