* ==================================
* Created: 	February 28, 2017
* Modified: February 13, 2019
* ==================================

clear all
set more off

* ==================================
* Example 1
bcuse wage1, clear
reg lwage educ c.exper##c.exper
testparm c.exper##c.exper

reg lwage educ c.exper##c.exper, robust
testparm c.exper##c.exper

* ==================================
* Example 2 -- Heteroskedasticity Testing
bcuse hprice1, clear

* Regress price on covariates
reg price lotsize sqrft bdrms
predict u_hat, resid
predict y_hat, xb
gen u_hat_sq = u_hat^2
reg u_hat_sq lotsize sqrft bdrms

* Breusch-Pagan F-test
disp "F = " ((e(r2)/e(df_m))/((1-e(r2))/(e(N)-e(df_m)-1))) _newline "Prob > F = " Ftail(e(df_m),e(df_r),((e(r2)/e(df_m))/((1-e(r2))/(e(N)-e(df_m)-1))))

* Breusch-Pagan LM-test
disp "LM = " e(r2)*e(N) _newline "Prob > chi2 = " chi2tail(e(df_m),e(r2)*e(N))

* White LM test
reg u_hat_sq c.lotsize##c.lotsize c.sqrft##c.sqrft c.bdrms##c.bdrms c.lotsize#c.sqrft c.lotsize#c.bdrms c.sqrft#c.bdrms
disp "LM = " e(r2)*e(N) _newline "Prob > chi2 = " chi2tail(e(df_m),e(r2)*e(N))

* Alternate White LM test
reg u_hat_sq c.y_hat##c.y_hat
disp "LM = " e(r2)*e(N) _newline "Prob > chi2 = " chi2tail(e(df_m),e(r2)*e(N))

drop u_hat* y_hat

* Regress log(price) on log(covariates)
reg lprice llotsize lsqrft bdrms
predict u_hat, resid
predict y_hat, xb
gen u_hat_sq = u_hat^2
reg u_hat_sq llotsize lsqrft bdrms

* Breusch-Pagan F-test
disp "F = " ((e(r2)/e(df_m))/((1-e(r2))/(e(N)-e(df_m)-1))) _newline "Prob > F = " Ftail(e(df_m),e(df_r),((e(r2)/e(df_m))/((1-e(r2))/(e(N)-e(df_m)-1))))

* Breusch-Pagan LM-test
disp "LM = " e(r2)*e(N) _newline "Prob > chi2 = " chi2tail(e(df_m),e(r2)*e(N))

* White LM-test
reg u_hat_sq c.llotsize##c.llotsize c.lsqrft##c.lsqrft c.bdrms##c.bdrms c.llotsize#c.lsqrft c.llotsize#c.bdrms c.lsqrft#c.bdrms
disp "LM = " e(r2)*e(N) _newline "Prob > chi2 = " chi2tail(e(df_m),e(r2)*e(N))

* Alternate White LM test
reg u_hat_sq c.y_hat##c.y_hat
disp "LM = " e(r2)*e(N) _newline "Prob > chi2 = " chi2tail(e(df_m),e(r2)*e(N))

drop u_hat* y_hat

reg price lotsize sqrft bdrms
hettest, fstat
hettest, iid
imtest, white

reg lprice llotsize lsqrft bdrms
hettest, fstat
hettest, iid
imtest, white

* ==================================
* Example 3 -- WLS
bcuse saving, clear
reg sav inc
gen yt = sav/sqrt(inc)
gen xt = inc/sqrt(inc)
reg yt xt, noconst
reg sav inc [aw=1/inc], noconst

* ==================================
* Example 4 -- WLS
bcuse 401ksubs, clear
gen age25_sq = (age-25)^2

qui reg nettfa inc if fsize==1, robust
est store OLS_1
qui reg nettfa inc if fsize==1 [aw=inc]
est store WLS_1
qui reg nettfa inc age25_sq male e401k if fsize==1, robust
est store OLS_2
qui reg nettfa inc age25_sq male e401k if fsize==1 [aw=1/inc]
est store WLS_2

est table OLS_1 WLS_1 OLS_2 WLS_2, b se stats(N r2) b(%7.3f)

* ==================================
* Example 5 -- FGLS
bcuse smoke, clear
reg cigs lincome lcigpric educ c.age##c.age restaurn
estat hettest

predict u_hat, resid
gen lu_hat_sq = ln(u_hat^2)
reg lu_hat_sq lincome lcigpric educ c.age##c.age restaurn
predict y_hat, xb
gen y_hat_exp = exp(y_hat)
reg cigs lincome lcigpric educ c.age##c.age restaurn [aw=1/y_hat_exp]
