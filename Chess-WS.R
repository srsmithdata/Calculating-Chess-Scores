---
title: "Chess Tournament Calculator"
author: "S Richard Smith"
date: "February 21, 2016"
output: 
  html_document:
    keep_md: true
    theme: flatly
    highlight: pygment
    code_folding: hide
    toc: true
    toc_depth: 2

---

```{r echo=F, warning=F, message=F}
# Init packages needed for subsequent code - please remove '#' before the install line if you need to install that referenced package

# install.packages('devtools',repos = "http://lib.stat.cmu.edu/R/CRAN/")
# install_github('rstudio/rmarkdown')
# install.packages('knitr', repos = c('http://rforge.net', 'http://cran.rstudio.org'), type = 'source')
# install.packages("RMySQL")
# install.packages("DBI")
require(DBI)
require(devtools)
require(rmarkdown)
require(knitr)
require(DBI)
require(xtable)
require(stringr)
require(XML)
require(RCurl)
require(tau)
require(graphics)
require(RMySQL)
---

