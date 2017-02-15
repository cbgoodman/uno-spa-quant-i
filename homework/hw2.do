* ==================================
* Created: 	February 14, 2017
* Modified: February 15, 2017			
* ==================================

capture log close
clear all
set more off

/* Section #1 reads data, calculates means, 		      			*/
/* estimates a regression, calculates the variance inflation 		*/
/* conducts joint tests of significance, and then tests the     	*/
/* residuals to determine if they are normally distributed       	*/

global datadir "~/data"
global logdir "~/data/log"


* Section #1
log using "$logdir\hw_2.log", replace

bcuse lawsch85, clear 

* question a
gen cost1000 = 
label variable  cost1000 `"law school cost, $1000s"'

regress lsalary cost1000 LSAT GPA libvol age studfac rank clsize faculty

* question b
sum
sum if lsalary != .

* question d
vif

* question e
regress lsalary cost1000 LSAT GPA libvol age studfac rank faculty
regress lsalary cost1000 LSAT GPA libvol age studfac rank clsize

* question f
regress lsalary cost1000 LSAT GPA libvol age studfac rank clsize faculty
test clsize=faculty=0 			
test clsize-faculty=0
test clsize+faculty=0

* question g
regress lsalary cost1000 LSAT GPA libvol age studfac rank				
regress lsalary cost1000 LSAT GPA libvol age studfac rank clsize faculty

regress lsalary cost LSAT GPA libvol age studfac rank clsize faculty 
regress lsalary cost LSAT GPA libvol age studfac rank 

gen clplus = clsize+faculty		
gen clminus = clsize-faculty

* test 2
regress lsalary cost LSAT GPA libvol age studfac rank clsize clplus		

* test 3 
regress lsalary cost LSAT GPA libvol age studfac rank clsize clminus

* question h
predict sal_resid, resid
predict sal_hat

sum sal_resid sal_hat, d

kdensity sal_resid, normal
kdensity sal_hat,normal

* question i
sktest sal_resid sal_hat

* question j
regress salary cost1000 LSAT GPA libvol age studfac rank clsize faculty
predict yhatlevels, xb

regress lsalary cost1000 LSAT GPA libvol age studfac rank clsize faculty

quietly predict uhat, resid
gen expuhat = exp(uhat)
quietly sum expuhat
generate yhatduan = r(mean)*exp(lyhat)

sum yhatlevels yhatduan
