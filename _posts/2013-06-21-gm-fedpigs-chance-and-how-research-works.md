---
id: 1975
title: 'GM-fed pigs, chance and how research works'
date: '2013-06-21T14:53:54+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1975'
permalink: /2013/06/21/gm-fedpigs-chance-and-how-research-works/
classic-editor-remember:
    - block-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2013/06/ORPlot1.png
tags:
    - breeding
    - stats
---

Following [my post](/2013/06/ordinal-logistic-gm-pigs/) on GM-fed pigs I received several comments, mostly through Twitter. Some people liked having access to an alternative analysis, while others replied with typical anti-GM slogans, completely ignoring that I was posting about the technical side of the paper. This post is not for the slogan crowd (who clearly are not interested in understanding), but for people that would like to know more about how one would evaluate claims from a scientific article. While I refer to the pig paper, most issues apply to any paper that uses statistics.

In general, researchers want to isolate the effect of the treatments under study (diets in this case) from any other extraneous influence. We want *control* over the experimental conditions, so we can separate the effects of interest from all other issues that could create differences between our experimental units (pigs in this case). What could create ‘noise’ in our results? Animals could have different genetic backgrounds (for example with different parents), they could be exposed to different environmental conditions, they could be treated differently (more kindly or harshly), etc.

Once we control those conditions as much as possible, we would *randomly assign* animals to each of the treatments (diets). The rationale behind random allocation is easy to follow. Let’s say that we can see that some animals are healthier than others before starting the trial. If I had a pro-GM agenda, I could assign the healthiest animals to the GM-diet and we would not be able to separate the effect of the treatment from the initial difference. To avoid this, we could have many labels in a hat, shake the hat, and for each pig take a label that randomly assigns the pig to a diet so the comparison is fair.

Researchers also like to have a *baseline* of the conditions *before* the treatments are applied. This way we can ‘adjust’ the results by any pre-existing differences. For example, there could be measurable differences on health, size, etc. I normally work with trees in experiments and we routinely assess the height of the trees just planted, so we can establish a baseline.

Finally, we often have a ‘default’ treatment which represents the status quo and acts as a *comparison point* for the new treatments. In the GM pig case, the default is a non-GM diet and the new treatment is the GM-diet.

The paper on GM fed pigs states that they tried to have as much control as possible of the growing conditions and that they used random allocation to the two feeding treatments. I have no problems with the paper up to this point.

When doing research it is good manners to state one’s expectations before the start of the trial. Doing this provides the experimenter with guidance about how to proceed with the evaluation of the experiment:

1. What are the characteristics under study? Both the response variables (in the past called ‘dependent variables’) and the predictors (old name ‘independent variables’).
2. What is the magnitude of the differences between groups that we would consider practically significant? Put another way, what would be the size of the difference that one would care about? For example, if we have two groups of pigs and the difference on weight between them is 1 g (0.035 ounces for people with funny units), who cares? If the difference was 5 kg (11 pounds, funny units again) then, perhaps, we are in to something.
3. What level of statistical significance we consider appropriate? Even if we assume that truly there is no difference between the two diets, we would expect to see small differences between the two groups just by chance. Big differences are more unlikely. It is common in research to state that a difference is statistically significant if the probability of observing the difference is smaller than, say, 0.05 (or 1 in 20). There is nothing sacred about the number but just a convention.

By this stage one would expect a researcher to state one or more hypotheses to be tested. For example, ‘I expect that the GM diet will increase \[condition here\] by \[number here\] percent’. One can run an experiment ignoring ‘good manners’, but (and this is a big but) an informed reader will become suspicious if suddenly one starts testing hypotheses like there is no tomorrow. Why? Because if one conducts too many tests one is bound to find statistically significant results even when there are none.

The comic below presents a brief example with jelly beans assuming that we claim significance for an event occurring with probability 0.05 (1 in 20) or less. Notice that the scientists use 20 colors of jelly beans and find that green ones ’cause’ acne. Running so many tests—without [adjusting down](https://en.wikipedia.org/wiki/Multiple_comparisons) the probability of the event that we would call significant, so p needs to be much smaller than 0.05 to be significant—results in wrong conclusions.

![XKCD explaining significance. p refers to the probability of observing that result if jelly beans have no effect on acne.](/assets/images/significant.png) ([original here](https://xkcd.com/882/))

In the pig paper there are 8 tests in Table 2, 18 (or 15 with some value) in Table 3, 8 in Table 4 and 17 in Table 5 for a total of 49 (or 46 with some testable values). In fact **one would expect to find a couple of significant results** (at 0.05 or 1 in 20) by chance even if there are absolutely no differences in reality.

Add to this that many of the tests are unnecessary, because they are performing the wrong type of analysis. For example, there are four separate analyses for stomach inflammation; however, the analysis ignores the type of variable one is testing as I point out [in a previous post](/2013/06/ordinal-logistic-gm-pigs/).

This is why, if I were Monsanto, I would use the paper as evidence supporting the idea that there is no difference between the two diets:

1. the paper was ‘independent’ (although the authors have a clear anti-GM bias) and
2. when running proper analyses (accounting for the type of variable and the number of tests that one is running) no difference is statistically significant.

**P.S. 2013-06-21. 15:38 [NZST](http://www.timeanddate.com/library/abbreviations/timezones/pacific/nzst.html)** *A footnote about data availability:* it is becoming increasingly common to make both the data and code used to analyze the data available when publishing (part of [Open Science](https://en.wikipedia.org/wiki/Open_science)). I would expect that a paper that is making bold claims that could have policy implications would provide those, which does not happens in this case. However, the publication does include part of the data in results Tables 3 &amp; 4, in the counts of pigs under different classes of inflammation.