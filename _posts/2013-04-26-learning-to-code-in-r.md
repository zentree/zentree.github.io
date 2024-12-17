---
id: 1725
title: 'Learning to code in R'
date: '2013-04-26T16:14:45+12:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=1725'
permalink: /2013/04/26/learning-to-code-in-r/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
tags:
    - programming
---

It used to be that the one of the first decisions to make when learning to program was between compiled (e.g. C or FORTRAN) and interpreted (e.g. Python) languages. In my opinion these days one would have to be a masochist to *learn* with a compiled language: the extra compilation time and obscure errors are a killer when learning.

Today the decision would be between using a generic interpreted language (e.g. Python) and an interpreted domain specific language (DSL) like R, MATLAB, etc. While [some people](http://www.johndcook.com/blog/) prefer generic languages, I’d argue that immediate feedback and easy accomplishment of useful tasks are a great thing when one is learning something for the first time.

As an example, a while ago my son asked me what I was doing in the computer and I told him that I was programming some analyses in R. I showed that the program was spitting back some numbers and plots, a fact that he found totally unremarkable and uninteresting. I searched in internet and I found [Scratch](http://scratch.mit.edu/), a visual programming language, that let’s the user moves blocks representing code around and build interactive games: now my son was sold. Together we are learning about loops, control structures and variables, drawing characters, etc. We are programming because the problems are i- much more interesting for him and ii- achievable in a short time frame.

![An example scratch script.](/assets/images/scratch.jpeg)

Learning to program for statistics, or other scientific domains for that matter, is not that different from being a kid and learning programming. Having to do too much to get even a mildly interesting result is frustrating and discouraging; it is not that the learner is dumb, but that he has to build too many functions to get a meager reward. This is why I’d say that you should use whatever language already has a large amount of functionality (‘batteries included’ in Python parlance) for your discipline. Choose rightly and you are half-way there.

‘But’ someone will say, R is not a real language. Sorry, but it is a real [language](/2012/01/r-is-a-language/) (Turing complete and the whole shebang) with oddities, as any other language, granted. As with human languages, the more you study the easier it gets to learn a new language. In fact, the syntax for many basic constructs in R is highly similar to alternatives:

```r
# This is R code
# Loop
for(i in 1:10){
    print(i)
}
#[1] 1
#[1] 2
#[1] 3
#[1] 4
#[1] 5
#[1] 6
#[1] 7
#[1] 8
#[1] 9
#[1] 10

# Control
if(i == 10) {
    print('It is ten!')
}

#[1] "It is ten!"
```

```python
# This is Python code
# Loop
for i in range(1,11): # Python starts indexing from zero
    print(i)

#1
#2
#3
#4
#5
#6
#7
#8
#9
#10

# Control
if i == 10:
    print("It is ten!")

#It is ten!
```

By the way, I formatted the code to highlight similarities. Of course there are plenty of differences between the languages, but many of the building blocks (the core ideas if you will) are shared. You learn one and the next one gets easier.

How does one start learning to program? If I look back at 1985 (yes, last millennium) I was struggling to learn how to program in [BASIC](https://en.wikipedia.org/wiki/BASIC) when, suddenly, I had an epiphany. The sky opened and I heard an orchestra playing [György Ligeti’s Atmosphères](https://www.youtube.com/watch?v=cW_o-T1CVrY) (from 2001: a Space Odyssey, you know) and then I realized: we are only breaking problems in little pieces and dealing with them one at the time. I’ve been breaking problems into little pieces since then. What else did you expect? Anyhow, if you feel that you want to learn how to code in R, or whatever language is the best option for your problems, start small. Just a few lines will do. Read other people’s code but, again, only small pieces that are supposed to do something small. At this stage is easy to get discouraged because everything is new and takes a lot of time. Don’t worry: everyone has to go through this process.

Many people struggle vectorizing the code so it runs faster. Again, don’t worry at the beginning if your code is slow. Keep on writing and learning. Read Noam Ross’s [FasteR! HigheR! StongeR! — A Guide to Speeding Up R Code for Busy People](http://www.noamross.net/blog/2013/4/25/faster-talk.html). The guide is very neat and useful, although you don’t need super fast code, not yet at least. You need working, readable and reusable code. You may not even need code: actually, try to understand the problem, the statistical theory, before you get coding like crazy. Programming will help you understand your problem a lot better, but you need a helpful starting point.

Don’t get distracted with the politics of research and repeatability and trendy things like git (noticed that I didn’t even link to them?). You’ll learn them in time, once you got a clue about how to program.

P.S. The code used in the examples could be shortened and sped up dramatically (e.g. `1:10` or `range(1, 11)`) but it is not the point of this post.  
P.S.2. A while ago I wrote [R is a language](/2012/01/r-is-a-language/), which could be useful connected to this post.