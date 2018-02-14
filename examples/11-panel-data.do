* ==================================
* Created: 	April 4, 2017
* Modified: April 4, 2017
* ==================================

clear all
set more off

* Example 1
bcuse jtrain, clear

tsset fcode year, yearly

reg lscrap d88 d89 grant grant_1 i.fcode
areg lscrap d88 d89 grant grant_1, absorb(fcode)
reghdfe lscrap d88 d89 grant grant_1, absorb(fcode)
xtreg lscrap d88 d89 grant grant_1, fe

* Example 2
bcuse wagepan, clear

tsset nr year, yearly

reg lwage educ black hisp exper expersq married union d81-d87
est store pooled
xtreg lwage educ black hisp exper expersq married union d81-d87, fe
est store fixed
xtreg lwage educ black hisp exper expersq married union d81-d87, re
est store random

est table pooled fixed random, drop(d81-d87)

* Example 2.5 -- How to chose?

* If statistically significant, use FE
hausman fixed random 

* Testing for random effects
xtreg lwage educ black hisp exper expersq married union d81-d87, re
xttest0

* Testing for heteroskedasticity in FE models
xtreg lwage educ black hisp exper expersq married union d81-d87, fe
xttest3

* Testing for Serial Autocorrelation
xtserial lwage educ black hisp exper expersq married union d81-d87

* What to do if you find heteroskedasticity or autocorrelation?
xtreg lwage educ black hisp exper expersq married union d81-d87, fe robust
xtreg lwage educ black hisp exper expersq married union d81-d87, fe cluster(nr)

* What to do if you find autocorrelation?
xtregar lwage educ black hisp exper expersq married union d81-d87, fe
