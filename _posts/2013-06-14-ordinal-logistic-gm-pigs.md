---
id: 1907
title: 'Ordinal logistic GM pigs'
date: '2013-06-14T23:15:22+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1907'
permalink: /2013/06/14/ordinal-logistic-gm-pigs/
classic-editor-remember:
    - block-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2013/06/ORPlot1.png
tags:
    - breeding
    - stats
---

This week another ‘scary GMO cause disease’ story was doing the rounds in internet: *A long-term toxicology study on pigs fed a combined genetically modified (GM) soy and GM maize diet*. [Andrew Kniss](https://bsky.app/profile/wyoweeds.bsky.social), a non-smokable weeds expert, mentioned that the statistical analyses in the study appeared to be kind of dodgy.

Curious, I decided to have a quick look and I was surprised, first, by the points the authors decide to highlight in their results, second, by the pictures and captioning used in the article and, last, by the way of running the analysis. As I’m in the middle of marking assignments and exams I’ll only have a quick go at part of the analysis. As I see it, the problem can be described as ‘there is a bunch of pigs who were fed either non-GM feed or GM feed. After some time (approximately 23 weeks) they were killed and went through a CSI-like autopsy’, where part of the exam involved the following process:

1. Write down the type of feed the pig had during his/her life;
2. Assess the condition of the stomach and put it in one of four boxes labeled ‘Nil’, ‘Mild’, ‘Moderate’ and ‘Severe’.

All this data is summarized in Table 3 of [the paper](http://gmojudycarman.org/wp-content/uploads/2013/06/The-Full-Paper.pdf) (PDF). How would I go about the analysis? As I see it, we have a categorical response variable—which can take one of four mutually exclusive values—and a categorical predictor (diet). In addition, there is a natural order to the inflammation response variable in that Severe &gt; Moderate &gt; Mild &gt; Nil.

Andrew Kniss wrote [a post](http://weedcontrolfreaks.com/2013/06/gmo-pig/) trying to reproduce the published results. Instead, I present the first approach I would try with the data: ordinal logistic regression. Not only that, but instead of using a hippie statistical software like R<sup>†</sup>, I will use industrial-grade-business-like SAS:

```
/*
Testing SAS web editor fitting pigs data
Luis A. Apiolaza - School of Forestry
*/

*Reading data set;
data pigs;
  input inflam $ diet $ count;
  datalines;
  Nil Non-GMO 4
  Mild Non-GMO 31
  Moderate Non-GMO 29
  Severe Non-GMO 9
  Nil GMO 8
  Mild GMO 23
  Moderate GMO 18
  Severe GMO 23
  ;
run;

*Showing data set;
proc print data = pigs;
  run;

*El quicko analysis;
ods graphics on;
proc logistic data = pigs order = data;
  freq count;
  class inflam (ref = "Nil") diet (ref = "Non-GMO") / param = ref;
  model inflam = diet / link = glogit;
  oddsratio diet;
run;

```

This produces a simple table with the same data as the paper and some very non-exciting results, which are better summarized in a single graph:

```
/*
Obs	inflam   diet   count
1	Nil      Non-GMO  4
2	Mild     Non-GMO 31
3	Moderate Non-GMO 29
4	Severe   Non-GMO  9
5	Nil      GMO      8
6	Mild     GMO     23
7	Moderate GMO     18
8	Severe   GMO     23
*/

```

![Odd ratios for the different levels of stomach inflammation.](/assets/images/orplot1.png)

The odd ratios would be 1 for no difference between the treatments. The graph shows that the confidence limits for all levels of inflammation include 1, so move on, nothing to see. In fact, GMO-fed pigs *tend* to have less inflammation for most disease categories.

P.S. There are many ways of running an analysis for this data set, but I’m in favor of approaches that take the whole problem in one go rather than looking at one class at the time. In an ideal situation we would have a *continuous* assessment for inflammation and the analysis would be a one-way ANOVA. I understand that for practical reasons one may prefer to split the response in four classes.

P.S.2 2013-06-15 I often act as a reviewer for scientific journals. In the case of this article some of my comments would have included: the analysis does not use the structure of the data properly, the photographs of the damaged organs should include both types of diet for each inflammation class (or at least include the most representative diet for the class), and the authors should highlight that there are no significant differences between the two diets for animal health; that is, the trial provides evidence for no difference between feeds. I still feel that the authors should be more forthcoming on terms of disclosing potential conflicts of interest too, but that’s their decision.

P.S.3 2013-07-04 I expand on aspects of the general research process [in this post](/2013/06/gm-fedpigs-chance-and-how-research-works/).

<small><sup>†</sup>Tongue-in-cheek, of course, and with reference to weeds. This blog mostly uses R, but I’m pushing myself to use lots of different software to ‘keep the language’. Now if I could only do this with Spanish.</small>