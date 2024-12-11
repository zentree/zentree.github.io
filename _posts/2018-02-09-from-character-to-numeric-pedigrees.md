---
id: 3257
title: 'From character to numeric pedigrees'
date: '2018-02-09T11:30:05+13:00'
author: Luis
layout: post
guid: 'http://www.quantumforest.com/?p=3257'
permalink: /2018/02/09/from-character-to-numeric-pedigrees/
classic-editor-remember:
    - classic-editor
cybocfi_hide_featured_image:
    - ''
image: /wp-content/uploads/2018/02/P1150354.jpg
tags:
    - programming
    - breeding
---

In quantitative genetic analyses we often use a pedigree to represent the relatedness between individuals, so this is accounted in the analyses, because the observations are not independent of each other. Often this pedigree contains alphanumeric labels, and most software can cope with that.

Sometimes, though, we want to use numeric identities because we would like to make the data available to third parties (other researchers, publication), and there is commercial sensitivity about them. Or just want to use a piece of software that can’t deal with character identities.
  
Last night put together an El quicko<sup>\*</sup> function to *numberify* identities, which returns a list with a numeric version of the pedigree and a key to then go back to the old identities.

```R
numberify <- function(pedigree) {
  ped_key <- with(pedigree, 
                  unique(c(as.character(mother), as.character(father), 
                           as.character(tree_id))))
  numeric_pedigree <- pedigree %>%
    mutate(tree_id = as.integer(factor(tree_id, levels = ped_key)),
           mother = as.integer(factor(mother, levels = ped_key)),
           father = as.integer(factor(father, levels = ped_key)))
  
  return(list(ped = numeric_pedigree, key = ped_key))
}

new_ped <- numberify(old_ped)

old_id <- new_ped$key[new_ped$ped$tree_id]
```

<sup>\*</sup> It could be generalized to extract the names of the 3 fields, etc.

![Breakdancing changing labels, Ancud.](/assets/images/breakdancing.jpg)