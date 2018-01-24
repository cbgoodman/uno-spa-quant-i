* ==================================
* Created: 	January 31, 2017
* Modified: January 24, 2018			
* ==================================

capture log close
clear all
set more off

/* Section #1 reads data, calculates detailed means,            */
/* a table of education and gender with mean wages as cells 	*/
/* and estimates two, simple, one-variable regressions		    */

/* Section #2 bootstraps the mean and writes				    */
/* Bootstrap estimates to a separate data set				    */

/* Section #3 adds two different error terms 				    */
/* to the dep. var. and estimates each regression			    */

global datadir "~/data"
global logdir "~/data/log"

* Section 1
bcuse wage1
log using "$logdir\homework_1.log", replace

sum wage educ, d

histogram wage /* creates a histogram of wage for question 1 */

format wage %9.2f /* this simply formats to two decimal places */

table educ female, c(mean wage) /*creates a table of average wages by education and gender */

list wage female if educ>17 /* lists wage and gender for if education is greater than 17 years */

regress wage educ  /* regression of education on wage */
regress lwage educ /* regression of education on the log of wage */

* Section 2

bootstrap "summarize wage" wagebs=r(mean), reps(50) saving($datadir/bs.dta) replace noisily

use "$datadir/bs.dta", clear

summarize, d

* Section 3
bcuse wage1, clear 

gen error1 = invnorm(uniform()) /* random number generator with mean of zero and st.dev of 1 */
gen error2 = 5+100*invnorm(uniform()) /* random number generator with mean of five and st.dev of 100 */

gen wage1 = wage+2
gen wage2 = wage+error1
gen wage3 = wage+error2

summarize error1 error2 wage wage1 wage2 wage3

regress wage educ
regress wage1 educ
regress wage2 educ
regress wage3 educ

log close
