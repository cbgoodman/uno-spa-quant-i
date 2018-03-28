* ==================================
* Created: 	March 28, 2018
* Modified: March 28, 2018
* ==================================

clear all
set more off
* ==================================
* Example 1 -- Pooled Independent Cross Sections Over Time
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/fertil1.des */
/* for description of the fertil1 dataset */
bcuse fertil1

* Explore the data
tab year

* Has the fertility rate changed over time?
reg kids educ c.age##c.age black east northcen west farm othrural smcity y74 y76 y78 y80 y82 y84

* What is the interpretation of the year dummies?
* Are our errors consistent across time and observations

hettest, fstat
hettest, iid
imtest, white

* Let's try this again
reg kids educ c.age##c.age black east northcen west farm othrural smcity y74 y76 y78 y80 y82 y84, robust

* ==================================
* Example 2 -- Pooled Independent Cross Sections Over Time
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/cps78_85.des */
/* for description of the cps78_85 dataset */
bcuse cps78_85, clear

* Explore the data
tab year

* Has the effect of education on wage changed over time?
* Has the wage gap between men and women widened over time?
reg lwage i.year##c.educ c.exper##c.exper union i.year##i.female 

* How do we interpret this?
lincom educ + 85.year#c.educ
lincom 1.female + 85.year#1.female

* ==================================
* Example 3 -- Two-Period Panel Data Analysis
/* See http://fmwww.bc.edu/ec-p/data/wooldridge/crime2.des */
/* for description of the crime2 dataset */
bcuse crime2, clear
egen city = group(area)

tsset city year, delta(5)

* Remember back
reg crmrte unem if d87==1

* Does this result make any sense?
* Pooled OLS
reg crmrte unem i.year

* This didn't help
* It's likely unemployment is correlated with a_i

* How should we estimate this as a panel?
reg crmrte unem i.city i.year
areg crmrte unem i.year, absorb(city)
xtreg crmrte unem i.year, fe

* First differencing? What's that?
reg d.crmrte d.unem

* ==================================
* Example 4 -- Wide v. Long Data Formats

* Long format
bcuse rental, clear

* Wide format
bcuse slp75_81, clear 

* Going from wide to long
help reshape

* We need an individual identifier
gen indiv = _n

* Reshape
reshape long age educ gdhlth marr slpnap totwrk yngkid, i(indiv) j(year)

* What's happening here?

reshape wide

* Going from long to wide 
bcuse rental, clear
reshape wide pop enroll-y90, i(city) j(year)

reshape long
