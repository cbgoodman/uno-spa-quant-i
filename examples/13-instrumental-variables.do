* ==================================
* Created: 	April 11, 2017
* Modified: April 11, 2017
* ==================================

clear all
set more off

* ==================================
* Example 1

bcuse mroz, clear

* OLS
reg lwage educ
est store OLS

* Instrument z=fatheduc
reg educ fatheduc
predict z_hat, xb

* IV Regression
reg lwage z_hat
est store IV

est table OLS IV, b se stats(N r2) b(%7.3f)

* ==================================
* Example 2
bcuse wage2, clear

* OLS
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
bcuse bwght, clear 

* OLS
reg lbwght packs
est store OLS

* Instrument z=cigprice
reg packs cigprice
predict z_hat, xb

* IV Regression
reg lbwght z_hat
est store IV

est table OLS IV, b se stats(N r2) b(%7.3f)

* All in one step
ivregress 2sls lbwght (packs=cigprice), first

* ==================================
* Example 3 - Multiple Instruments

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
