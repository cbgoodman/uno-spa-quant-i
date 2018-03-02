* ==================================
* Created: 	February 28, 2017
* Modified: March 2, 2018			
* ==================================

capture log close
clear all
set more off

global datadir "~/data"
global logdir "~/data/log"


log using "$logdir\hw_3.log", replace

* ==================================
* Part 1
* ==================================

/* See http://fmwww.bc.edu/ec-p/data/wooldridge/kielmc.des */
/* for description of the kielmc dataset */
bcuse kielmc, clear

/* Generate a series of binomial variables */	
/* Stata evaluates the statement in the parentheses */
/* if true, then assign a 1 if false then 0 */

gen bath_1=(baths==1)
gen bath_2=(baths==2)
gen bath_3=(baths==3)
gen bath_4=(baths==4)

/* Similarly we could use the tab and gen commands */

drop bath_*
tab bath, gen(bath_)

/* Equivalently we could let Stata do the work for us */
/* Notice that STATA omits one of the groups automatically */
 
* Include i.baths in your model

replace land=land/43560
label variable land `"lot acreage"' 
replace cbd=cbd/5280
label variable cbd `"dist to cent. bus dist., mi"'
replace intst=intst/5280
label variable intst `"dist to interstate, mi"'
replace dist=dist/5280
label variable dist `"dist from house to incin., mi"'
replace ldist=ln(dist)

reg lrprice baths rooms area land cbd intst age y81
reg lrprice i.baths rooms area land cbd intst age y81

* ==================================
* Part 2
* ==================================
* Create interaction
reg lrprice baths rooms area land cbd intst age y81
* Respecify preferred model below


* ==================================
* Part 3
* ==================================
* You'll need to respecify the model with distance and log(distance)
regress lrprice dist baths rooms area land cbd intst age y81


* ==================================
* Part 4
* ==================================

/* See http://fmwww.bc.edu/ec-p/data/wooldridge/injury.des */
/* for description of the injury dataset */
bcuse injury, clear

reg ldurat i.afchnge##i.highearn if ky==1

* Add a full set of control variables to the above DD model


* Estimate the original equation for the state of Michican


log close
