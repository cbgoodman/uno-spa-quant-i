* ==================================
* Created: 	January 24, 2017
* Modified: January 24, 2017			
* ==================================

clear all
set more off

* Example 1
bcuse ceosal1
reg salary roe

* Example 2
bcuse wage1
reg wage educ

* Example 3
bcuse vote1
reg voteA shareA

* Example 4
bcuse wage1
*gen lwage = ln(wage)
reg lwage educ

* Example 5
bcuse ceosal1

reg lsalary lsales
