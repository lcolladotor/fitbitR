
## ----setup, include=FALSE, cache=FALSE-----------------------------------
# set global chunk options
library(knitr)
opts_chunk$set(fig.path='fig-', fig.align='center', fig.show='hold', fig.width=7, fig.height=7, out.width='.8\\linewidth', echo=FALSE, message=FALSE, warning=FALSE)
options(width=70)


## ----preamble------------------------------------------------------------
## Libs used in this report
library(fitbitR)
library(ggplot2)
library(gridExtra)
library(xtable)

## Load and preprocess the data
data <- preprocess(fitbitData)


## ----eda, fig.cap="Exploratory plots of the number of steps (nSteps) for a specific individual along a two month period with data binned by 5 minute intervals. Top plot shows the data by Interval and Date separated by whether the day is a weekday or not. The activity peaks (light blue) are more consistent for weekdays while weekends seem more variable. Missing observations (gray) are clearly visible only in this plot. The bottom plot shows the data in a in 24 hour clock where we can clearly notice that this individual is regularly mostly active from 6 am to 7 pm on weekends and 8 am to 9 pm on weekends.", fig.pos="H"----

p <- ggplot(data, aes(x=Interval, y=nSteps, group=Date, colour=Day, alpha=nSteps)) + geom_point(na.rm=TRUE)  + coord_polar() + facet_grid(~Weekend)
p2 <- ggplot(data, aes(y = Date, x = Interval, colour = nSteps)) + geom_point(na.rm=TRUE) + facet_grid(~Weekend)
grid.arrange(p2, p)


## ----q1, results='asis'--------------------------------------------------
## Complete predictions
types <- c("lm", "poisson", "means", "overall-mean")
datap <- lapply(types, function(x) {
    fitbitPred(data, method = x)
})

## All data
all <- c(list(data), datap)
names(all) <- c("original", types)

q1.aa <- lapply(all, function(x) {
    y <- q1(x, method = "auto.arima", acf = FALSE)
    y$Estimate
})
q1 <- do.call(rbind, q1.aa)
print(xtable(q1, caption="Estimated average number of steps taken per day using an ARIMA(3, 0, 3) model on the interval data (not binned). The estimate, standard error and 95 percent confidence intervals (based on the t-distribution) are shown for fitting the ARIMA(3, 0, 3) model to the original data with missing observations as well as the completed data using the four prediction methods previously described.", lab="tab1"))


## ----q23, fig.keep="none"------------------------------------------------
q2.gam <- q2(data, "gam")
q3.weekend <- q3(data, "weekend")


## ----qtwoThree, fig.cap="Average activity pattern over time (within a day). Top plot uses all the data while the bottom plot separates the data by whether it's a weekend or a weekday. Blue curves are GAM models fitted for the quasipoisson family using cubic spline basis on the interval time of day.", fig.pos="H"----

grid.arrange(q2.gam$plot, q3.weekend$plot)


## ----q3, echo=FALSE------------------------------------------------------
coef <- (q3.weekend$fit$coef["WeekendWeekend"])
ci <- coef + c(-1, 1) * qt(0.975, df=q3.weekend$fit$df.null) * sqrt(vcov(q3.weekend$fit)["WeekendWeekend", "WeekendWeekend"])
finalCI <- paste0("(", round(ci[1], 3), ", ", round(ci[2], 3), ")")

## Test statistics and p-value, no longer reported
ts <-  coef / sqrt(vcov(q3.weekend$fit)["WeekendWeekend", "WeekendWeekend"])
pval <- pt(ts, q3.weekend$fit$df.null, lower=FALSE) * 2


## ----format, echo=FALSE--------------------------------------------------
options(scipen = 10, digits = 4)


## ----qtwoMean, fig.cap="Average activity pattern over time (within a day) using the naive mean method.", fig.pos="H"----
q2.mean <- q2(data, "mean")


## ----shiny, echo=TRUE, eval=FALSE----------------------------------------
## library(fitbitR)
## fitbitShine()


