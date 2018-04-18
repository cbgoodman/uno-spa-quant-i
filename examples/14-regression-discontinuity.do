* ==================================
* Created: 	April 18, 2018
* Modified: April 18, 2018
* ==================================

clear all
set more off

* ==================================
* Example 1 -- Sharp RD
* From A&P's website -- http://masteringmetrics.com/resources/
use https://github.com/cbgoodman/uno-spa-quant-i/raw/master/data/AEJfigs.dta

* Create D_a
gen age = agecell - 21
gen over21 = agecell >= 21

* Run our regression discontunity 
reg all age over21
predict allfitlin

reg all age over21 over_age
predict allfitlini

label variable all       "Mortality rate from all causes (per 100,000)"
label variable allfitlin "Mortality rate from all causes (per 100,000)"

twoway (scatter all agecell) (line allfitlin agecell if age < 0,  lcolor(black)     lwidth(medthick)) ///
                             (line allfitlin agecell if age >= 0, lcolor(black red) lwidth(medthick medthick)), legend(off) xline(21)

* Nonlinearity				 
gen age2 = age^2
gen over_age = over21*age
gen over_age2 = over21*age2

reg all age age2 over21
predict allfitq

* Gives separate slopes for either side of the discontinuity
reg all age age2 over21 over_age over_age2
predict allfitqi

label variable allfitqi  "Mortality rate from all causes (per 100,000)"

twoway (scatter all agecell) (line allfitlin allfitqi agecell if age < 0,  lcolor(red black) lwidth(medthick medthick) lpattern(dash)) ///
                             (line allfitlin allfitqi agecell if age >= 0, lcolor(red black) lwidth(medthick medthick) lpattern(dash)), legend(off) xline(21)

* "Motor Vehicle Accidents" on linear, and quadratic on each side
reg mva age over21
predict exfitlin
reg mva age age2 over21 over_age over_age2
predict exfitqi

* "Internal causes" on linear, and quadratic on each side
reg internal age over21
predict infitlin
reg internal age age2 over21 over_age over_age2
predict infitqi

label variable mva  "Mortality rate (per 100,000)"
label variable infitqi  "Mortality rate (per 100,000)"
label variable exfitqi  "Mortality rate (per 100,000)"

* figure 4.5
twoway (scatter mva internal agecell) (line exfitqi infitqi agecell if agecell < 21) ///
                                       (line exfitqi infitqi agecell if agecell >= 21), ///
									   legend(off) text(28 20.1 "Motor Vehicle Fatalities") ///
									               text(17 22 "Deaths from Internal Causes") xline(21)
