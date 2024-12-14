---
id: 2519
title: 'Back of the envelope look at school decile changes'
date: '2014-11-27T14:11:07+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=2519'
permalink: /2014/11/27/back-of-the-envelope-look-at-school-decile-changes/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - politics
    - stats
---

Currently there is some discussion in New Zealand about the effect of the reclassification of schools in socioeconomic deciles. An interesting aspect of the funding system in New Zealand is that state and state-integrated schools with poorer families receive substantially more funding from the government than schools that receive students from richer families (see [this page](http://www.minedu.govt.nz/NZEducation/EducationPolicies/Schools/SchoolOperations/Resourcing/OperationalFunding/Deciles/RecalculationQuestionAndAnswers.aspx) in the Ministry of Education’s website).

One thing that I haven’t noticed before is that funding decisions are more granular than simply using deciles, as deciles 1 to 4 are split into 3 steps each. For example, for *Targeted Funding for Educational Achievement* in 2015 we get the following amounts per student for decile: 1 (A: $905.81, B: $842.11, C: $731.3), 2 (D: $617.8, E: 507.01, F: 420.54), 3 (G: $350.25, H: $277.32, I: $220.59), 4 (J: $182.74, K: $149.99, L: $135.12), 5 ($115.76), 6 ($93.71), 7: ($71.64), 8 ($46.86), 9 ($28.93) and 10 ($0).

The Ministry of Education states that 784 schools ‘have moved to a higher decile rating’ while 800 ‘have moved to a lower decile rating’ (800 didn’t move). They do not mean that those numbers of schools changed deciles, but that information also includes *changes of steps within deciles*. Another issue is that it is not the same to move one step at the bottom of the scale (e.g. ~$63 from 1A to 1B) or at the top (~$29 from 9 to 10); that is, the relationship is not linear.

I assume that the baseline to measure funding changes is to calculate how much would a school would get per student in 2015 without any change of decile/step. That is, funding assuming that the previous step within decile had stayed constant. Then we can calculate how a student will get with the new decile/step for the school. I have limited this ‘back of the envelope’ calculation to *Targeted Funding for Educational Achievement*, which is not the only source of funding linked to deciles. There are other things like *Special Education Grant* and *Careers Information Grant*, but they have much smaller magnitude (maximum $73.94 &amp; $37.31 per student) and the maximum differences between deciles 1 and 10 are 2:1.

```R
options(stringsAsFactors = FALSE)
library(ggplot2)

# School directory
direc <- read.csv('directory-school-current.csv', skip = 3)

# Decile changes
dc <- read.csv('DecileChanges_20142015.csv', skip = 2)
dc <- subset(dc, select = c(Inst.., X2014.Decile, X2015.Decile, X2014.Step, X2015..Step, Decile.Change,
             Step.Change))
names(dc) <- c('School.ID', 'deci2014', 'deci2015', 'step2014', 'step2015', 'decile.change', 'step.change')

# Getting read of missing value
dc$step2014 <- with(dc, ifelse(step2014 == '', NA, step2014))
dc$step2015 <- with(dc, ifelse(step2015 == '', NA, step2015))
```

Steps are in capital letters and need to be translated into money. Once we get that we can calculate differences at both student level and school level:

```R
steps <- c(LETTERS[1:17], 'Z')
money <- c(905.81, 842.11, 731.3, 617.8, 507.01, 420.54, 350.25, 277.32,
  220.59, 182.74, 149.99, 135.12, 115.76, 93.71, 71.64, 46.86, 28.93, 0)

dc = within(dc, {
sm2014 = sapply(step2014, function(x) money[match(x, steps)])
sm2015 = sapply(step2015, function(x) money[match(x, steps)])
# Change per student
funding.change = sm2015 - sm2014
})

summary(dc$funding.change)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.
#-812.100  -22.070    0.000   -3.448   22.070  707.000

# Merging with school directory data
dc = merge(dc, direc[, c('School.ID', 'Total.School.Roll')],
           by = 'School.ID', all.x = TRUE)

# Calculating total change at school level
# considering roll in thousands of dollars
dc$school.level.change = with(dc, funding.change*Total.School.Roll/1000)
summary(dc$school.level.change)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.
#-137.100   -2.820    0.000    2.689    3.627  413.100
```

If we look at the 50% of the schools in the middle of the distribution they had fairly small changes, approximately +/- $22 per student per year or at the school level +/- 3,000 dollars per year.

An interesting, though not entirely surprising, graph is plotting changes of funding on the size of the school. Large schools are much more stable on deciles/step than small ones.

```R
# At student level
qplot(Total.School.Roll, funding.change, data = dc, alpha = 0.8,
xlab = 'Total School Roll', ylab = 'Funding change per student (NZ$)') +
theme_bw() + theme(legend.position = 'none')

# At school level
qplot(Total.School.Roll, school.level.change, data = dc, alpha = 0.8,
      xlab = 'Total School Roll', ylab = 'Funding change per school (NZ$ 000)') +
theme_bw() + theme(legend.position = 'none')
```

![Change of funding per student per year (NZ$) on size of the school (number of students).](/assets/images/funding_change_per_student.png)

Overall, there is a small change of the total amount of money for <em>Targeted Funding for Educational Achievement</em> used in the reclassified school system versus using the old deciles ($125M using 2014 deciles versus $132M using 2015 deciles) and for most schools the changes do not seem dramatic. There is, however, a number of schools (mostly small ones) who have had substantial changes to their funding. Very small schools will tend to display the largest changes, as the arrival or departure of only few pupils with very different socioeconomic backgrounds would have a substantial effect. An example would be Mata School in the Gisborne area, which moved 13 steps in decile funding (from A to N) with a roll of 11 kids. How to maintain a more steady funding regime seems to be a difficult challenge in those cases.

One consequence of the larger variability in small schools is that rural areas will be more affected by larger changes of funding. While overall 34% of the schools had no changes to their decile/step classification in rural areas that reduces to 22%; on top of that, the magnitude of the changes for rural schools is also larger.

### Footnote

Data files used for this post: [decile_changes_20142015](/assets/uploads/decile_changes_20142015.csv)</a> and [directory_school_current](/assets/uploads/directory_school_current.csv)

Operational school funding is [much more complex](http://www.minedu.govt.nz/NZEducation/EducationPolicies/Schools/SchoolOperations/Resourcing/ResourcingHandbook/Chapter1/Appendices/Appendix1OperationalFundingRates.aspx) than deciles, as it includes allocations depending on number of students, use of Maori language, etc.

P.S. Stephen Senn highlights an obvious problem with the language the Ministry uses: there are 9 deciles (the points splitting the distribution into 10 parts). We should be talking about tenths, a much simpler word, instead of deciles.</p>
