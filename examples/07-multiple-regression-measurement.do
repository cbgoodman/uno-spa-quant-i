* ==================================
* Created: 	March 7, 2017
* Modified: February 21, 2018
* ==================================

clear all
set more off

* ==================================
* Example 1 - RESET
bcuse hprice1, clear

reg price lotsize sqrft bdrms
predict y_hat, xb
reg price lotsize sqrft bdrms c.y_hat#c.y_hat##c.y_hat 
test (c.y_hat#c.y_hat=0) (c.y_hat#c.y_hat#c.y_hat=0)
drop y_hat

reg lprice llotsize lsqrft bdrms
predict y_hat, xb
reg lprice llotsize lsqrft bdrms c.y_hat#c.y_hat c.y_hat#c.y_hat#c.y_hat 
test (c.y_hat#c.y_hat=0) (c.y_hat#c.y_hat#c.y_hat=0)
drop y_hat

reset price lotsize sqrft bdrms
reset lprice llotsize lsqrft bdrms

* ==================================
* Example 2 - Specification
reg price lotsize sqrft llotsize lsqrft bdrms
test (lotsize=0) (sqrft=0)
test (llotsize=0) (lsqrft=0)

* Davidson MacKinnon Test
reg price llotsize lsqrft bdrms
predict y_invhat, xb
reg price lotsize sqrft bdrms y_invhat

* ==================================
* Example 3 - Proxy Variables
bcuse wage2, clear

reg lwage educ exper tenure married south urban black
est store lwage1
reg lwage educ exper tenure married south urban black IQ
est store lwage2
reg lwage exper tenure married south urban black c.IQ##c.educ
est store lwage3

est table lwage1 lwage2 lwage3, b stats(N r2) b(%7.3f) star

* ==================================
* Example 3 - Lagged DV
bcuse crime2, clear

reg lcrmrte unem llawexpc if d87==1
est store crmrte
reg lcrmrte unem llawexpc lcrmrt_1 if d87==1
est store crmrte_1

est table crmrte crmrte_1, b se stats(N r2) b(%7.3f)

* ==================================
* Example 4 - Measurement Error
bcuse wage1, clear

* Dependent variable
gen error1 = invnorm(uniform()) 
gen error2 = 5+100*invnorm(uniform())

gen wage1 = wage+2
gen wage2 = wage+error1
gen wage3 = wage+error2

reg wage educ exper
est store wage
reg wage1 educ exper
est store wage1
reg wage2 educ exper
est store wage2
reg wage3 educ exper
est store wage3

est table wage wage1 wage2 wage3, b se stats(N r2) b(%7.3f)

* Independent variable
gen educ1 = educ+2
gen educ2 = educ+error1
gen educ3 = educ+error2

reg wage educ exper
est store educ
reg wage educ1 exper
est store educ1
reg wage educ2 exper
est store educ2
reg wage educ3 exper
est store educ3

est table educ educ1 educ2 educ3, b se stats(N r2) b(%7.3f)


* ==================================
* Example 5 - Outliers
bcuse rdchem, clear 

reg rdintens sales profmarg
browse if sales>30000
drop if _n==10
reg rdintens sales profmarg
