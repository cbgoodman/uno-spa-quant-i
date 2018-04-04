* ==================================
* Created: 	April 4, 2017
* Modified: April 4, 2018
* ==================================

clear all
set more off

* ==================================
* Example 1 -- Fixed Effects Regression
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/jtrain.des */
/* for description of the jtrain dataset */
bcuse jtrain, clear

tsset fcode year, yearly

* Explore the data
xtsum scrap
tab grant year if lscrap!=.

* Estimate the fixed effects regression
reg lscrap i.year grant grant_1 i.fcode 
areg lscrap i.year grant grant_1, absorb(fcode)
reghdfe lscrap i.year grant grant_1, absorb(fcode)
xtreg lscrap i.year grant grant_1, fe

* Predict the influence of a grant in 1988
disp (exp(_b[grant_1])-1)*100

* What do the coefficients on the year dummies mean?

* ==================================
* Example 2 -- Fixed Effects Regression
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/wagepan.des */
/* for description of the wagepan dataset */
bcuse wagepan, clear

tsset nr year, yearly

* Explore the data
tab year

* Has the returns to education changed over time
xtreg lwage exper married union educ black hisp i.year, fe

* Uh oh
* How do we get fix this?
xtreg lwage exper married union c.educ##i.year, fe

* Is education significant across the entire time perio?
testparm year#c.educ

* ==================================
* Example 3 -- Fixed Effects Regression
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/wagepan.des */
/* for description of the wagepan dataset */
bcuse wagepan, clear

tsset nr year, yearly

* The three panel methods we know so far
reg lwage educ black hisp exper expersq married union i.year
est store pooled
xtreg lwage educ black hisp exper expersq married union i.year, fe
est store fixed
xtreg lwage educ black hisp exper expersq married union i.year, re
est store random

est table pooled random fixed, drop(i.year) b(%5.3f) se(%5.3f)

* ==================================
* Example 3.5 -- How to chose?

* If statistically significant, use FE
hausman fixed random 

* Testing for random effects
xtreg lwage educ black hisp exper expersq married union i.year, re
xttest0

* Testing for heteroskedasticity in FE models
xtreg lwage educ black hisp exper expersq married union i.year, fe
xttest3

* Testing for Serial Autocorrelation
xtserial lwage educ black hisp exper expersq married union d81-d87

* What to do if you find heteroskedasticity or autocorrelation?
xtreg lwage educ black hisp exper expersq married union i.year, fe robust
est store fixedrobust
xtreg lwage educ black hisp exper expersq married union i.year, fe cluster(nr)
est store fixedcluster

est table fixed fixedrobust fixedcluster, drop(i.year) b(%5.4f) se(%5.4f) modelwidth(12)

* What to do if you find autocorrelation?
* First Differencing is more efficient than fixed effects in the 
* presence of serial autocorrelation
reg d.lwage d.(educ black hisp exper expersq married union)
