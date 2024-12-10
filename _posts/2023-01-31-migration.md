---
id: 3792
title: Migration
date: '2023-01-31T12:01:55+13:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=3792'
permalink: /2023/01/31/migration/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2023/01/IMG_20221108_175034.jpg
tags:
    - meta
---

I was thinking that I have six domain names (including the .net and .com for my surname), posts spread all over the place and that I should focus my attention in fewer projects. On top of that I was annoyed with `Hugo`—the static site compiler, not a person—as for whatever reason small changes broke compilation of my `luis.apiolaza.net` site. This site had a long and distinguished history of running under different tools, from artisan-level writing HTML by hand in a text editor, to wiki systems.

In parallel, I’ve been running a blog since 2003, also with a bunch of different software, different subdomains and domains to the current `QuantumForest.com` using WordPress.

In a moment of total annoyance I decided to merge the site and blog under one roof. Thus, I wiped out the `luis.apiolaza.net` files, except for the uploads folder which contains PDF copies of my articles. Installed WordPress and imported the blog contents. The old site HTML pages will become WordPress pages, and the odd HTML posts will be imported as WordPress posts.

I will then redirect all Quantum Forest posts to this site and, very slowly, check for broken links. Expect major catastrophes that will, very slowly, be fixed. At least that’s the theory. In practice most everything will be in a state of disarray.

P.S. The 301 permanent redirect seems to be working OK. Added these lines to the top of the `.htaccess` file in the `QuantumForest.com` domain.

```
Options +FollowSymLinks 
RewriteEngine on 
RewriteRule (.*) https://luis.apiolaza.net/$1 [R=301,L] 
```

P.S.2. Can’t figure out how to set a favicon in the fancy block-theme in WordPress. Goes to the too-hard basket until I sort out **all** other issues. A couple of days later this item is sorted.

P.S.3. Completed merging the two domains. Now looking for other small sources of posts.

![Posts passing by like subway carriages.](/assets/images/subway.jpg)