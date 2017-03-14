* ==================================
* Created: 	March 14, 2017
* Modified: March 14, 2017			
* ==================================

clear all
set more off

* Example 1 -- Static Phillips Curve
bcuse phillips, clear 
reg inf unem

* Example 2
bcuse intdef, clear 

reg i3 inf def

* Example 3 -- Dummy variables
bcuse fertil3, clear 

reg gfr pe ww2 pill

* Example 4 -- Trends
bcuse hseinv, clear 

reg linvpc lprice
reg linvpc lprice t

* Example 5 - Detrending

tsgraph linvpc
tsgraph lprice

reg linvpc t
predict linvpc_detrended, resid

reg lprice t
predict lprice_detrended, resid

reg linvpc lprice t

reg linvpc_detrended lprice
reg linvpc_detrended lprice t

reg linvpc_detrended lprice_detrended

* Example 6 - Seasonality
bcuse barium, clear 

reg chnimp chempi gas rtwex befile6 affile6 afdec6

reg chnimp chempi gas rtwex befile6 affile6 afdec6 feb-dec
test (feb=0) (mar=0) (apr=0) (may=0) (jun=0) (jul=0) (aug=0) (sep=0) (oct=0) (nov=0) (dec=0)

* Example 7 - Serial Correlation (Expectations Augmented Phillips Curve)
bcuse phillips, clear
tsset year, yearly 

reg d.inf unem

predict u_hat, resid
reg u_hat l.u_hat

reg d.inf unem
* d_l is 1.324; d_U is 1.403
estat dwatson

reg d.inf d.unem
estat dwatson

prais inf unem
prais inf unem, corc

newey inf unem, lag(2)
