---
title: 'Paring down web presence'
layout: post
tags:
    - meta
---

Following last year's [migration](/2023/01/31/migration/) and site integration
I was happy with hosting most of my writing under a single, self-hosted
Wordpress installation. 
However, lately I have been feeling the need to further simplify my setup.
Getting rid of Wordpress and relying on someone else hosting my static pages
sounded like a good idea: a proper Christmas-New Year project.

I exported the whole Wordpress site to Markdown 
using the Jekyll Exporter WordPress plugin. It mostly did a good job, 
although it was tripped a few times by the `pre + code` block.
As I had to check and correct some of the export, 
I used the time to update the links, both within my site
and *mostly* to external web sites.
I hadn't noticed that my previous integration had broken
a few internal links. However, the real problem was link rot;
the farther back I went, the worse the situation was.
Posts from ten years ago had 50% of dead links. Fifteen years ago,
75% of the links were gone. I managed to rescue some of the links
via the [Internet Archive](https://archive.org). Long live the Archive!

Then came figuring out Jekyll. I chose it, 
instead of more modern systems (like Hugo), 
because it is the tool of choice for free hosting in GitHub.
I can even post directly from GitHub when travelling.
I think it could also work with Gitlab.
A few things I learnt:

* Using remote templates
* `Liquid` so I could modify the templates
* How to add `mathjax` to the site
* Moving back the domain servers from my hosting to the name registrar,
  so I could do email forwarding, and adding `A` and `CNAME` records,
  leaving part of the old site still working (`A`)
  and moving the rest to GitHub (`CNAME`).

Everything seems to be working properly, but for a couple of to dos:

* I *have* to get favicons working, and
* Figuring out something about figure captions.

Small fries to finish.



