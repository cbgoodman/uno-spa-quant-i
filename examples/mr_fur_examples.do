* ==================================
* Created: 	February 14, 2017
* Modified: February 14, 2017			
* ==================================

clear all
set more off

* ==================================
* Example 1
bcuse wage1
reg wage c.exper##c.exper

* Marginal effect of experience
margins,dydx(exper) at(exper=(1))

* Graph quadratic 
margins, at(exper=(1(1)51))
marginsplot, noci

* Find maximum
disp _b[c.exper]/(2*_b[c.exper#c.exper])

* ==================================
* Example 2
bcuse hprice2, clear
gen ldist = log(dist)

reg lprice lnox ldist c.rooms##c.rooms stratio

* Marginal effect of rooms
margins,dydx(rooms) at(rooms=(1))

* Graph quadratic 
quietly margins, at(rooms=(3.56(0.1)8.78))
marginsplot, noci
marginsplot, noci addplot(scatter lprice rooms)

* Find minimum
disp _b[c.rooms]/(2*_b[c.rooms#c.rooms])

* Marginal effect of rooms
margins,dydx(rooms) at(rooms=(5))
margins,dydx(rooms) at(rooms=(6))

* ==================================
* Example 3
bcuse ceosal2, clear
reg salary sales mktval ceoten
predict yhatlevels, xb

reg lsalary lsales lmktval ceoten
predict lyhat, xb
gen yhatwrong = exp(lyhat)
gen yhatnormal = exp(lyhat)*exp(0.5*e(rmse)^2)
quietly predict uhat, resid
gen expuhat = exp(uhat)
quietly sum expuhat
generate yhatduan = r(mean)*exp(lyhat)

sum salary yhatwrong yhatnormal yhatduan yhatlevels

