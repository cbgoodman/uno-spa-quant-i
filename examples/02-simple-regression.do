* ==================================
* Created: 	January 24, 2017
* Modified: January 16, 2019
* ==================================

clear all
set more off

* Example 1
bcuse ceosal1, clear
reg salary roe

* Example 2
bcuse wage1, clear
reg wage educ

* Example 3
bcuse vote1, clear
reg voteA shareA

* Example 4
bcuse wage1, clear
drop lwage

gen lwage = ln(wage)
reg lwage educ

* Example 5
bcuse ceosal1, clear

reg lsalary lsales
