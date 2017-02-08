* ==================================
* Created: 	February 7, 2017
* Modified: February 7, 2017
* ==================================

clear all
set more off

* Example 1
bcuse wage1, clear
reg lwage educ exper tenure

* Example 2
bcuse meap93, clear 
reg math10 totcomp staff enroll
reg math10 ltotcomp lstaff lenroll

* Example 3
bcuse gpa1, clear 
reg colGPA hsGPA ACT skipped

* Example 4
bcuse campus, clear 
reg lcrime lenroll
disp (_b[lenroll]-1)/_se[lenroll]

* Example 5
bcuse rdchem, clear 
reg lrd lsales profmarg 

* Example 6
bcuse mlb1, clear 
* Restricted
reg lsalary years gamesyr 
* Unrestricted
reg lsalary years gamesyr bavg hrunsyr rbisyr
test bavg hrunsyr rbisyr

* Example 7
bcuse hprice1, clear 
reg lprice lassess llotsize lsqrft bdrms
gen restrict = lprice-lassess
reg restrict
test (lassess=1) (llotsize=0) (lsqrft=0) (bdrms=0)
