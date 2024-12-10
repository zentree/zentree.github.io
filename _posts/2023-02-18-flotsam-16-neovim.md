---
id: 3927
title: 'Flotsam 16: neovim'
date: '2023-02-18T23:10:34+13:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=3927'
permalink: /2023/02/18/flotsam-16-neovim/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2023/02/neovim.jpg
tags:
    - programming
---

Just to remember where things are in my neovim installation in MacOS:

```
" Configuration file
~/.config/nvim/init.vim

" Using vim-plug for managing plugins
~.local/share/nvim/site/autoload
" Location of plugins
~/.local/share/nvim/plugged
```

The init file follows the structure presented in here: <https://github.com/junegunn/vim-plug> pointing to the location of the plugins as:

```
call plug#begin('~/.local/share/nvim/plugged')
```

![Just neovim.](/assets/images/neovim.jpg)