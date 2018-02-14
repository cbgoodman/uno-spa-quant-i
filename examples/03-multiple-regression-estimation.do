* ==================================
* Created: 	January 31, 2017
* Modified: January 24, 2018			
* ==================================

clear all
set more off

* Examples of Multiple Regression
bcuse wage1, clear
reg lwage educ exper

bcuse saving, clear
reg cons c.inc##c.inc

bcuse ceosal2, clear
reg lsalary lsales c.ceoten##c.ceoten

* Example 1: Partialling out
bcuse wage1, clear
reg lwage educ exper

reg educ exper
predict resid, resid
reg lwage resid

* Example 2
bcuse crime1, clear
reg narr86 pcnv ptime86 qemp86
reg narr86 pcnv avgsen ptime86 qemp86

* Example 4: Irrelevant Variables
bcuse wage1, clear 
reg lwage educ exper
gen noise = rnormal()
reg lwage educ exper noise

* Example 4: Omitted Variable Bias
bcuse wage2, clear
reg lwage educ
reg lwage educ IQ
reg IQ educ

* OVB = _b[educ]_short - _b[educ]_long
disp .0598392-.0391199

* OVB =  _b[educ in IQ reg]*_b[IQ in long]
disp 3.533829*.0058631
