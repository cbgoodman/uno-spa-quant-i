* ==================================
* Created: 	April 11, 2017
* Modified: April 11, 2018
* ==================================

clear all
set more off

* ==================================
* Example 1 -- Estimating the returns to education for married women
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/mroz.des */
/* for description of the morz dataset */
bcuse mroz, clear

* Estimate OLS regression
* We think this is biased due to endogeneity (omitted ability)
reg lwage educ
est store OLS

* Instrument z=fatheduc
reg educ fatheduc
predict z_hat, xb

* IV Regression
reg lwage z_hat
est store IV

* Once we take omitted ability into account,
* the returns to education are roughly half
est table OLS IV, b se stats(N r2) b(%7.3f)

* ==================================
* Example 2 -- Estimating the returns to education for men
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/wage2.des */
/* for description of the wage2 dataset */
bcuse wage2, clear

* Estimate OLS regression
reg lwage educ
est store OLS

* Instrument z=sibs
reg educ sibs
predict z_hat, xb

* IV Regression
reg lwage z_hat
est store IV

est table OLS IV, b se stats(N r2) b(%7.3f)

* ==================================
* Example 3 -- Poor Instrument
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/bwght.des */
/* for description of the bwght dataset */
bcuse bwght, clear 

* OLS
reg lbwght packs
est store OLS

* Instrument z=cigprice
* Note: cigprice has little to no influence on packs smoked
* i.e. A poor instrument
reg packs cigprice
predict z_hat, xb

* IV Regression
* What happened here? Does this result make any sense?
reg lbwght z_hat
est store IV

est table OLS IV, b se stats(N r2) b(%7.3f)

* All in one step
ivregress 2sls lbwght (packs=cigprice), first


* ==================================
* Example 4 - Multiple Instruments
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/mroz.des */
/* for description of the mroz dataset */
bcuse mroz, clear

* OLS
reg lwage educ exper expersq

* First Stage
reg educ exper expersq motheduc fatheduc
predict z_hat, xb 

* IV
reg lwage z_hat exper expersq

* All in one step
ivregress 2sls lwage exper expersq (educ = motheduc fatheduc), first

* ==================================
* Example 5 - Overidentification Tests
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/mroz.des */
/* for description of the mroz dataset */
bcuse mroz, clear

* IV in one step
ivreg2 lwage exper expersq (educ = motheduc fatheduc), first

* Whoa, that's a lot of stuff
* What is important here?

* ==================================
* Example 6 - IV with Pooled OLS
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/fertil1.des */
/* for description of the fertil1 dataset */
bcuse fertil1, clear

* Explore the data
tab year

* Has the fertility rate changed over time?
reg kids educ c.age##c.age black east northcen west farm othrural smcity y74 y76 y78 y80 y82 y84, robust
ivreg2 kids (educ = meduc feduc) age agesq black east northcen west farm othrural smcity y74 y76 y78 y80 y82 y84, robust first

* ==================================
* Example 7 - IV with FD
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/jtrain.des */
/* for description of the jtrain dataset */
bcuse jtrain, clear

tsset fcode year, yearly

* Estimate the first difference regression
reg d.lscrap d.hrsemp if year!=1989

* IV
ivreg2 d.lscrap (d.hrsemp = d.grant) if year!=1989, first
