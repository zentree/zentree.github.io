---
id: 322
title: 'Covariance structures'
date: '2011-10-27T05:00:20+13:00'
author: Luis
layout: post
mathjax: true
guid: 'http://www.quantumforest.com/?p=322'
permalink: /2011/10/27/covariance-structures/
classic-editor-remember:
    - classic-editor
    - classic-editor
cybocfi_hide_featured_image:
    - 'yes'
image: /wp-content/uploads/2011/10/arar.png
tags:
    - asreml
    - stats
---

In most mixed linear model packages (e.g. asreml, lme4, nlme, etc) one needs to specify only the model equation (the bit that looks like `y ~ factors...`) when fitting simple models. We *explicitly* say nothing about the covariances that complete the model specification. This is because most linear mixed model packages assume that, in absence of any additional information, the covariance structure is the product of a scalar (a variance component) by a design matrix. For example, the residual covariance matrix in simple models is **R** = **I** σ<sub>e</sub><sup>2</sup>, or the additive genetic variance matrix is **G** = **A** σ<sub>a</sub><sup>2</sup> (where **A** is the numerator relationship matrix), or the covariance matrix for a random effect **f** with incidence matrix **Z** is **Z**‘ **Z** σ<sub>f</sub><sup>2</sup>.

However, there are several situations when analyses require a more complex covariance structure, usually a [direct sum](http://en.wikipedia.org/wiki/Direct_sum_of_matrices#directsum) or a [Kronecker product](http://en.wikipedia.org/wiki/Kronecker_product) of two or more matrices. For example, an analysis of data from several sites might consider different error variances for each site, that is **R** = Σd **R**<sub>i</sub>, where Σd represents a direct sum and **R**<sub>i</sub> is the residual matrix for site *i*.

Other example of a more complex covariance structure is a multivariate analysis in a single site (so the same individual is assessed for two or more traits), where both the residual and additive genetic covariance matrices are constructed as the product of two matrices. For example, **R** = **I** ⊗ **R**<sub>0</sub>, where **I** is an identity matrix of size number of observations, ⊗ is the Kronecker product (do not confuse with a plain matrix multiplication) and **R**<sub>0</sub> is the error covariance matrix for the traits involved in the analysis. Similarly, **G** = **A** ⊗ **G**<sub>0</sub> where all the matrices are as previously defined and **G**<sub>0</sub> is the additive covariance matrix for the traits.

Some structures are easier to understand (at least for me) if we express a covariance matrix (**M**) as the product of a correlation matrix (**C**) pre- and post-multiplied by a diagonal matrix (**D**) containing standard deviations for each of the traits (**M** = **D** **C** **D**). That is:

\\(  
M = \\left \[  
\\begin{array}{cccc}  
v\_{11}&amp; c\_{12}&amp; c\_{13}&amp; c\_{14} \\\\  
c\_{21}&amp; v\_{22}&amp; c\_{23}&amp; c\_{24} \\\\  
c\_{31}&amp; c\_{32}&amp; v\_{33}&amp; c\_{34} \\\\  
c\_{41}&amp; c\_{42}&amp; c\_{43}&amp; v\_{44}  
\\end{array}  
\\right \]\\)  
\\(  
C = \\left \[  
\\begin{array}{cccc}  
1&amp; r\_{12}&amp; r\_{13}&amp; r\_{14} \\\\  
r\_{21}&amp; 1&amp; r\_{23}&amp; r\_{24} \\\\  
r\_{31}&amp; r\_{32}&amp; 1&amp; r\_{34} \\\\  
r\_{41}&amp; r\_{42}&amp; r\_{43}&amp; 1  
\\end{array}  
\\right \]\\)  
\\(  
D = \\left \[  
\\begin{array}{cccc}  
s\_{11}&amp; 0&amp; 0&amp; 0 \\\\  
0&amp; s\_{22}&amp; 0&amp; 0 \\\\  
0&amp; 0&amp; s\_{33}&amp; 0 \\\\  
0&amp; 0&amp; 0&amp; s\_{44}  
\\end{array}  
\\right \]\\)

where the $$v$$ are variances, the $$r$$ correlations and the $$s$$ standard deviations.

If we do not impose any restriction on **M**, apart from being positive definite (p.d.), we are talking about an unstructured matrix (`us()` in asreml-R parlance). Thus, **M** or **C** can take any value (as long as it is p.d.) as it is usual when analyzing multiple trait problems.

There are cases when the *order* of assessment or the *spatial* location of the experimental units create patterns of variation, which are reflected by the covariance matrix. For example, the breeding value of an individual *i* observed at time *j* (a<sub>ij</sub>) is a function of genes involved in expression at time *j – k* (a<sub>ij-k</sub>), plus the effect of genes acting in the new measurement (α<sub>j</sub>), which are considered independent of the past measurement a<sub>ij</sub> = ρ<sub>jk</sub> a<sub>ij-k</sub> + α<sub>j</sub>, where ρ<sub>jk</sub> is the additive genetic correlation between measures *j* and *k*.

Rather than using a different correlation for each pair of ages, it is possible to postulate mechanisms which model the correlations. For example, an autoregressive model (ar() in asreml-R lingo), where the correlation between measurements *j* and *k* is r<sup>|j-k|</sup>. In this model **M** = **D** **C**<sub>AR</sub> **D**, where **C**<sub>AR</sub> (for equally spaced assessments) is:  
\\(  
C\_{AR} = \\left \[  
\\begin{array}{cccc}  
1 &amp; r^{|t\_2-t\_1|} &amp; \\ldots &amp; r^{|t\_m-t\_1|}\\\\  
r^{|t\_2-t\_1|} &amp; 1 &amp; \\ldots &amp; r^{|t\_m-t\_2|}\\\\  
\\vdots &amp; \\vdots &amp; \\ddots &amp; \\vdots \\\\  
r^{|t\_m-t\_1|} &amp; r^{|t\_m-t\_2|} &amp; \\ldots &amp; 1  
\\end{array}  
\\right \]\\)

Assuming three different autocorrelation coefficients (0.95 solid line, 0.90 dashed line and 0.85 dotted line) we can get very different patterns with a few extra units of lag, as shown in the following graph:

![Autocorrelation model in one dimension.](/assets/images/autoregressive-plot.png)

A model including this structure will certainly be more parsimonious (economic on terms of number of parameters) than one using an unstructured approach. Looking at the previous pattern it is a lot easier to understand why they are called ‘structures’. A similar situation is considered in [spatial analysis](/2011/10/21/spatial-correlation-in-designed-experiments/ "Spatial correlation in designed experiments"), where the ‘independent errors’ assumption of typical analyses is relaxed. A common spatial model will consider the presence of autocorrelated residuals in both directions (rows and columns). Here the level of autocorrelation will depend on distance between trees rather than on time. We can get an idea of how separable processes look like using this code:

```r
# Separable row col autoregressive process
car2 <- function(dim, rhor, rhoc) {
  M <- diag(dim)
  rhor^(row(M) - 1) * rhoc^(col(M) - 1)
}

library(lattice)
levelplot(car2(20, 0.95, 0.85))
```

![Autocorrelation in two dimensions.](/assets/images/arar.png)

This correlation matrix can then be multiplied by a spatial residual variance to obtain the covariance and we can add up a spatially independent residual variance.

Much more detail on code notation for covariance structures can be found, for example, in the [ASReml-R User Guide](http://www.vsni.co.uk/downloads/asreml/release3/asreml-R.pdf) (PDF, chapter 4), for nlme in Pinheiro and Bates's [Mixed-effects models in S and S-plus](http://books.google.com/books?id=y54QDUTmvDcC&printsec=frontcover&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false) (link to Google Books, chapter 5.3) and in Bates's [draft book](http://lme4.r-forge.r-project.org/book/) for lme4 in chapter 4.