---
id: 3849
title: 'Python code to simulate the Monty Hall problem'
date: '2011-04-24T21:38:00+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=3849'
permalink: /2011/04/24/python-code-to-simulate-the-monty-hall-problem/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2012/08/old-house.jpg
tags:
    - programming
    - stats
---

I always struggled to understand the [Monty Hall Problem](http://en.wikipedia.org/wiki/Monty_Hall_problem), which popped up again in [William Briggs’s](http://wmbriggs.com/blog/?p=438) site. The program assumes that initially the prize is equally likely to be behind one of the three doors. Once the contestant (player in the program) chooses a door, the game host (who knows where is the prize) opens another door that does not contain the prize. The host then offers the contestant the choice between keeping his original choice or switch to the unopened door.

Initially the contestant has 1/3 probability of choosing the door with the prize and 2/3 of choosing the wrong door. If the contestant has chosen the right door, switching means losing; however, 2/3 of the time Monty Hall is in fact offering the prize.

```r
from __future__ import division
from random import randint

# Number of games and game generation
ngames = 10000

prize = [randint(1,3)*x for x in ngames*[1]]
player = [randint(1,3)*x for x in ngames*[1]]

# Evaluating success
default = 0
monty = 0

for game in range(ngames):
    # Keeping decision
    if prize[game] == player[game]: 
        default = default + 1

    # Taking chance with Monty
    if prize[game] == player[game]:
        # Switching means losing
        pass
        # Switching means winning
    else:
        monty = monty + 1
    
print 'Probability of winning (own door)', default/ngames
print 'Probability of winning (switching doors)', monty/ngames
```

The final probabilities should be pretty close to 1/3 and 2/3, depending on the number of games (ngames) used in the simulation.