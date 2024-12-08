---
id: 3925
title: 'Anyone using other than RStudio?'
date: '2023-04-11T20:35:05+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=3925'
permalink: /2023/04/11/anyone-using-other-than-rstudio/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2023/02/neovim.jpg
tags:
    - programming
    - stats
---

I asked both in Mastodon and Twitter “Anyone using other than [\#RStudio](https://twitter.com/hashtag/RStudio?src=hashtag_click) as their main [\#rstats](https://twitter.com/hashtag/rstats?src=hashtag_click) IDE?” and—knowing that some programmers are literal and would probably reply ‘Yes’—I added “What is it?”

Of course I got a few replies like “I only have used RStudio” (Why reply?) or “I use RStudio but in docker containers” (Still RStudio). I also received mostly helpful answers, with some of the usual suspects and a more esoteric option:

- The most popular alternative was [Visual Studio Code](https://code.visualstudio.com/) using the `R Extension for Visual Studio Code` plugin together with the `languageserver` R package.
- [Neovim](https://neovim.io/) together with the [Nvim-R](https://github.com/jalvesaq/Nvim-R) plugin.
- [Emacs](https://www.gnu.org/software/emacs/) (or one of its [variants](https://emacsformacosx.com/)) + [ESS](https://ess.r-project.org/) (Emacs Speaks Statistics).

On the esoteric side [Spacemacs](https://www.spacemacs.org/) (Emacs + layers of configuration), or an unholy combination of Emacs with Vim keybindings.

Any of these options will let you use Rmarkdown or Quarto if you are into that.

P.S. I focused on crossplatform options (I tend to move a lot), but a comment in Mastodon mentioned a Windows-only option that could be useful for a few people: [Notepad++](https://mmeredith.net/blog/2022/NppToR.htm) together with the `NppToR` utility.

![Neovim, one of the alternatives](/assets/images/neovim.jpg)