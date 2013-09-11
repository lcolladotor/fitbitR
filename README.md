fitbitR
=======

JHSPH Biostat qualifying exam 2013 take home re-take: analyzing Fitbit activity data in 5 min intervals. The original version is available [here](https://github.com/russojhsph/fitbitR). This fork is for the re-take since I had to change a few things (mainly in the report).


## Installation instructions

```S
## If needed
install.packages("devtools")

## Pre-requisites from CRAN
install.packages(c("knitr", "markdown", "shiny", "reshape2", "splines", "xts", "randomForest",
	"cvTools", "car", "plyr", "forecast", "mgcv", "gridExtra", "xtable", "ggplot2"))

## GitHub reqs
library(devtools)
install_github(username='jimhester', repo='knitrBootstrap')

## This is the main package.
library(devtools)
install_github("fitbitR", "lcolladotor")
```

## Report (package vignette)

You can either find the report [here](https://github.com/lcolladotor/fitbitR/blob/master/inst/doc/fitbitR-lcolladotor.pdf) hosted by GitHub or you can view it from R by running:


```S
browseVignettes("fitbitR")
```

Viewing the report from R has the advantage of seeing the R code extracted from the vignette.

## Shiny Application


```S
## Either run from fitbitR
library(fitbitR)
fitbitShine()

## Or from the web
library(shiny)
runUrl("https://github.com/lcolladotor/fitbitR/archive/master.zip",
subdir = "inst/fitbitShine")
```
