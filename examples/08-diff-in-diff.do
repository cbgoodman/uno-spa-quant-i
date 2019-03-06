* ==================================
* Created: 	March 6, 2019
* Modified: March 6, 2019
* ==================================

clear all
set more off

* Replace this with wherever you want
* to put the Excel file created below
cd "~/Dropbox/Teaching/UNO/Quant I/"

* From A&P's website -- http://masteringmetrics.com/resources/
use "http://masteringmetrics.com/wp-content/uploads/2015/01/deaths.dta"

* Regression DD Estimates of MLDA-Induced Deaths among 18-20 Year Olds, from 1970-1983
reg mrate legal

* death cause: 1=all, 2=MVA, 3=suicide, 6=internal
foreach i in 1 2 3 6{

* no trends, no weights
reg mrate legal i.state i.year if year <= 1983 & agegr == 2 & dtype == `i', cluster(state)
outreg2 legal using "table52.xls", replace bdec(2) sdec(2) excel noaster cttop("`i'") cttop(" no tr, no w")

* time trends, no weights
reg mrate legal i.state##c.year i.year if year <= 1983 & agegr == 2 & dtype == `i', cluster(state)
outreg2 legal using "table52.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop(" tr, no w")

* no trends, weights
reg mrate legal i.state i.year if year <= 1983 & agegr == 2 & dtype == `i' [aw=pop], cluster(state)
outreg2 legal using "table52.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop(" no tr, w")

* time trends, weights
reg mrate legal i.state##c.year i.year if year <= 1983 & agegr == 2 & dtype == `i' [aw=pop], cluster(state)
outreg2 legal using "table52.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop(" tr, w")
}
