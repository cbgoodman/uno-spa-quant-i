* ==================================
* Created: 	February 14, 2017
* Modified: February 06, 2019			
* ==================================

clear all
set more off

* ==================================
* Example 1
bcuse wage1, clear
reg wage female educ exper tenure
reg wage female

* ==================================
* Example 2
bcuse jtrain, clear
keep if year==1988
reg hrsemp grant lsales lemploy

* ==================================
* Example 3
bcuse hprice1, clear
reg lprice llotsize lsqrft bdrms colonial

* ==================================
* Example 4
bcuse wage1, clear
reg lwage i.female##c.educ c.exper##c.exper c.tenure##c.tenure
margins, dydx(female educ)

* Results for the un-interacted model are almost identical
* to the marginal effects of the interacted model
reg lwage i.female educ c.exper##c.exper c.tenure##c.tenure

* ==================================
* Example 5
bcuse gpa3, clear
reg cumgpa i.female##(c.sat c.hsperc c.tothrs) if term==2
contrast i.female female#c.sat female#c.hsperc female#c.tothrs, overall

reg cumgpa c.sat c.hsperc c.tothrs if term==2

* ==================================
* Example 6
bcuse mroz, clear
reg inlf nwifeinc educ c.exper##c.exper age kidslt6 kidsge6
margins, at(educ=(0(1)17) nwifeinc=(50) exper=(5) age=(30) kidslt6=(1) kidsge6=(0))
marginsplot

* ==================================
* Example 7
bcuse jtrain, clear
reg lscrap grant lsales lemploy if d88==1

* ==================================
* Example 8
bcuse loanapp, clear
gen nonwhite = (race==3) | (race==4)
reg approve nonwhite appinc netw mortg
reg approve appinc netw mortg unem c.obrat##i.nonwhite
