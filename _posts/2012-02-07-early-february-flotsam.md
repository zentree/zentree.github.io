---
id: 800
title: 'Early-February flotsam'
date: '2012-02-07T23:27:03+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=800'
permalink: /2012/02/07/early-february-flotsam/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - aleph
    - statistics
---

Mike Croucher at Walking Randomly points out an interesting [difference in operator precedence](http://www.walkingrandomly.com/?p=4154) for several mathematical packages to evaluate a simple operation `2^3^4`. It is pretty much a divide between Matlab and Excel (does the later qualify as mathematical software?) on one side with result 4096 (or `(2^3)^4`) and Mathematica, R and Python on the other, resulting on 2417851639229258349412352 (or `2^(3^4)`). Remember your parentheses…

Corey Chivers, aka Bayesian Biologist, uses R to help students understand the [Monty Hall problem](http://bayesianbiologist.com/2012/02/03/monty-hall-by-simulation/). I think a large part of the confusion to grok it stems from a convenient distraction: opening doors. The problem could be reframed as: i- you pick a door (so probability of winning the prize is 1/3) and Monty gets the other two doors (probability of winning is 2/3), ii- Monty is offering to switch all his doors for yours, so switching increases the probability of winning, iii- Monty will never open a winning door to entice the switch, so we should forget about them.

To make the point clearer, let’s imagine now that instead of 3 doors the game has 10 doors. You pick one (probability of winning 1/10) and Monty keeps 9 (probability of winning 9/10). Would you switch one door for nine? Of course! The fact that Monty will open 8 non-winning doors rather than all of his doors does not make a difference in the deal.

```r
# Number of games and doors
n.games <- 10000
n.doors <- 10

# Assign prize to door for each game. Remember:
# Monty keeps all doors not chosen by player
prize.door <- floor(runif(n.games, 1, n.doors + 1))
player.door <- floor(runif(n.games, 1, n.doors + 1))

# If prize.door and player.door are the same
# and player does not switch
are.same <- prize.door == player.door
cat('Probability of winning by not switching', 
    sum(are.same)/n.games, '')
cat('Probability of winning by switching', 
    (n.games - sum(are.same))/n.games, '')
```

Pierre Lemieux reminds us that "a dishonest statistician is an outliar".

If you want to make dulce de leche using condensed milk—but lack a pressure cooker—use an autoclave for 50 to 60 minutes. HT: Heidi Smith. Geeky and one needs an autoclave worth thousands of dollars, but that's what universities are for.

[Lesser and Pearl inform us](https://web.archive.org/web/20130307054507/http://www.amstat.org/publications/jse/v16n3/lesser.html) that there are at least 20 modalities for making statistics fun in "Functional Fun in Statistics Teaching: Resources, Research and Recommendations". HT: Chelsea Heaven. I've used music, videos, cartoons, jokes, striking examples using body parts, quotations, food, juggling, etc.

[An old review](http://www.budsas.org/ebud/ebdha106.htm) of [Buddhism without Beliefs](https://www.librarything.com/work/163051/book/16192666): A Contemporary Guide to Awakening by Stephen Batchelor. I can't see any statistical angle, but I liked that book.