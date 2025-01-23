*data cleaning

clear all

* Pathway for using and saving the data
global DATA "/Users/antalertl/Desktop/r_projects/remembering_past_present_biases/data/data_cleaned/"

* load data without missing (output of final data merging)
use "${DATA}data_nomissing.dta"



foreach var of varlist _all {
    rename `var' `=lower("`var'")'
}


*** --- DATA CLEANING AND DATA MUNGING


*creating variables
gen female = (gender == "Female")
gen mother_dipl=0
replace mother_dipl=1 if mothereduc=="PhD"
replace mother_dipl=1 if mothereduc=="MA"
replace mother_dipl=1 if mothereduc=="BSC"

*-------
*** *eliminating inconsistent subjects

gen inconsistent1=0

* Loop over the choice1 variables and check the condition
foreach i of numlist 1/11 { 
    local next = `i' + 1
    replace inconsistent1= 1 if choice1_`next' < choice1_`i' & inconsistent1 == 0
}

gen inconsistent2=0

* Loop over the choice2 variables and check the condition
foreach i of numlist 1/11 { 
    local next = `i' + 1
    replace inconsistent2= 1 if choice2_`next' < choice2_`i' & inconsistent2 == 0
}

gen inconsistent3=0

* Loop over the choice3 variables and check the condition
foreach i of numlist 1/11 { // AGAIN, CHANGED
    local next = `i' + 1
    replace inconsistent3= 1 if choice3_`next' < choice3_`i' & inconsistent3 == 0
}

gen inconsistent=0
replace inconsistent=1 if inconsistent1 == 1 | inconsistent2 == 1 | inconsistent3 == 1
//replace inconsistent=1 if inconsistent2 == 1
//replace inconsistent=1 if inconsistent3 == 1


* Drop inconsistent in general ------ DIFFERENT FROM BERTI'S

drop if inconsistent == 1



*--------------------------
* GENERATE SWITCHING POINTS

gen switching_point1 = .
forvalues i = 1/12 {
    replace switching_point1 = `i' if choice1_`i' == 2 & missing(switching_point1)
}

gen switching_point2 = .
forvalues i = 1/12 {
    replace switching_point2 = `i' if choice2_`i' == 2 & missing(switching_point2)
}

gen switching_point3 = .
forvalues i = 1/12 {
    replace switching_point3 = `i' if choice3_`i' == 2 & missing(switching_point3)
}

*----------- # CHANGE COMPARED TO BERTI!
* There are a bunch of people where the switching_point is missing 
* I encode those as switching_pont == 0

replace switching_point1 = 0 if missing(switching_point1)
replace switching_point2 = 0 if missing(switching_point2)
replace switching_point3 = 0 if missing(switching_point3)




* ---------- time-consistent, present-biased, future-biased

* HERE, AGAIN, I CHANGED IT
* previously it was encoded as for example:
*gen timecons=.
*replace timecons=1 if switching_point1 == switching_point2 & !missing(switching_point1) & !missing(switching_point2)
*replace timecons=0 if switching_point1 > switching_point2 & !missing(switching_point1) & !missing(switching_point2)
*replace timecons=0 if switching_point1 < switching_point2 & !missing(switching_point1) & !missing(switching_point2)


gen timecons=.
replace timecons=1 if switching_point1 == switching_point2
replace timecons=0 if switching_point1 > switching_point2 
replace timecons=0 if switching_point1 < switching_point2 

gen pb_dummy = .
replace pb_dummy = 1 if switching_point1 < switching_point2 
replace pb_dummy=0 if switching_point1 > switching_point2 
replace pb_dummy=0 if switching_point1 == switching_point2 

gen fb_dummy=.
replace fb_dummy=1 if switching_point1 > switching_point2  
replace fb_dummy=0 if switching_point1 < switching_point2  
replace fb_dummy=0 if switching_point1 == switching_point2 




* IMPORTANT THING!!!!! WHAT SHOULD WE DO WITH THOSE WHO CONSTANTLY CHOSE THE 2ND IN EVERY CHOICE? THEY ARE IRRATIONAL


* Swithcing point difference:

gen sw_diff= switching_point2-switching_point1

* CONTIONUS PRESENT BIAS AND FUTURE BIAS CALCULATION: 

gen pb_cont=.
replace pb_cont=sw_diff if sw_diff>0
replace pb_cont=0 if sw_diff==0

gen fb_cont=.
replace fb_cont=abs(sw_diff) if sw_diff<0
replace fb_cont=0 if sw_diff==0


* NEW: COMBINE THE TWO TO GET time_pref_cont, where:
* 		- negative values are present biased, and
*		- positive values are future biased, and
* 		- values of 0 are consistent


gen time_pref_cont = -1*pb_cont
replace time_pref_cont = fb_cont if missing(time_pref_cont)





tab timecons
tab pb_dummy
tab pb_cont if pb_cont>0
tab fb_dummy
tab fb_cont if fb_cont>0


* ------ REMEMBERING CHOICES: 

*remembering correctly earlier choices
forvalues i = 1/12 {
    * Generate initial missing value for each rem1 variable
    gen rem1_`i' = .
   
    * Set rem1_`i` to 1 if treatment equals 0 and choice1_`i` equals choice3_`i`
    replace rem1_`i' = 1 if treatment == 0 & choice1_`i' == choice3_`i'
   
    * Set rem1_`i` to 0 if treatment equals 0 and choice1_`i` does not equal choice3_`i`
    replace rem1_`i' = 0 if treatment == 0 & choice1_`i' != choice3_`i'
}

egen total_rem1 = rowtotal(rem1_1 rem1_2 rem1_3 rem1_4 rem1_5 rem1_6 rem1_7 rem1_8 rem1_9 rem1_10 rem1_11 rem1_12)

tab total_rem1 pb_dummy if treatment==0, exact

*remembering correctly later choices
forvalues i = 1/12 {
    * Generate initial missing value for each rem2 variable
    gen rem2_`i' = .
   
    * Set rem2_`i` to 1 if treatment equals 0 and choice2_`i` equals choice3_`i`
    replace rem2_`i' = 1 if treatment == 1 & choice2_`i' == choice3_`i'
   
    * Set rem2_`i` to 1 if treatment equals 0 and choice2_`i` does not equal choice3_`i`
    replace rem2_`i' = 0 if treatment == 1 & choice2_`i' != choice3_`i'
}


egen total_rem2 = rowtotal(rem2_1 rem2_2 rem2_3 rem2_4 rem2_5 rem2_6 rem2_7 rem2_8 rem2_9 rem2_10 rem2_11 rem2_12)

gen total_remember = max(total_rem1,total_rem2)




*------ ALTERNATIVE: misrememebering

gen diff13=.
replace diff13=switching_point1-switching_point3 if treatment==0

gen diff23=.
replace diff23=switching_point2-switching_point3 if treatment==1


* AGAIN, I CHANGED SOME: I CALCULATE MISREMEMBERING FOR FUTURE BIASED STUDENTS AS WELL,
* SO: FOR DUMMY VARIABLES, IF DIFFERENCE != 0, YOU MISREMEMBERING
* (and later, this could be dropped from the analysis for filtering out future-biased individuals)

gen misrem1_dummy=.
*replace misrem1_dummy=1 if treatment==0 & diff13>0 & inconsistent1==0 & inconsistent3==0 & !missing(diff13)
replace misrem1_dummy=1 if treatment==0 & diff13!=0 & inconsistent1==0 & inconsistent3==0 & !missing(diff13)
replace misrem1_dummy=0 if treatment==0 & diff13==0 & inconsistent1==0 & inconsistent3==0 & !missing(diff13)

gen misrem2_dummy=.
replace misrem2_dummy=1 if treatment==1 & diff23!=0 & inconsistent2==0 & inconsistent3==0 & !missing(diff23)
replace misrem2_dummy=0 if treatment==1 & diff23==0 & inconsistent2==0 & inconsistent3==0 & !missing(diff23)


gen misrem_dummy = misrem1_dummy
replace misrem_dummy = misrem2_dummy if missing(misrem_dummy)

* AGAIN: calculate misremembering intensity, with a negative value for 
* unexpected sign; essentially I just comment out the last criterium

gen misrem1_int=.
*repace misrem1_int=diff13 if treatment==0 & inconsistent1==0 & inconsistent3==0 & diff13>-0.1

replace misrem1_int=diff13 if treatment==0 & inconsistent1==0 & inconsistent3==0 //& diff13>-0.1

gen misrem2_int=.
replace misrem2_int=diff23 if treatment==1 & inconsistent2==0 & inconsistent3==0 //& diff23>-0.1

gen Misremembering_intensity = misrem1_int
replace Misremembering_intensity = misrem2_int if missing(Misremembering_intensity)

gen no_switching_point = 0
replace no_switching_point=1 if switching_point1==0
replace no_switching_point=1 if switching_point2==0




// AFTER ALL THESE CALCULATIONS, KEEP ONLY THE VARIABLES WHICH MATTER


keep gender mothereduc math socialrank_1 trust risk timepref_control patience_days treatment female mother_dipl inconsistent switching_point1 switching_point2 switching_point3 no_switching_point timecons pb_dummy fb_dummy sw_diff pb_cont fb_cont time_pref_cont total_remember misrem_dummy Misremembering_intensity


rename female Female
rename mother_dipl Mother_has_diploma
rename socialrank Social_rank
rename math Math
rename trust Trust
rename risk Risk
rename pb_dummy Present_bias_dummy
rename pb_cont Present_bias_intensity
rename fb_cont Future_bias_intensity
rename sw_diff Switching_point_difference
rename misrem_dummy Misremembering_dummy
*rename time_pref_cont Time_pref_cont


rename switching_point1 Switching_point1
rename switching_point2 Switching_point2
rename switching_point3 Switching_point3



label var total_remember "Total Decisions Remembered"
label var time_pref_cont "Time Preferences"
label var Misremembering_intensity "Intensity of Misremembering"
label var Misremembering_dummy "Dummy of Misremembering"
label var Present_bias_intensity "Intensity of Present Bias"
label var inconsistent "Being Inconsistent in at least one of the three choices"
label var Switching_point_difference "Difference between Remembered and Actual Switching Point"
label var Future_bias_intensity "Intensity of Future Bias"
label var treatment "Second Visit"
label var no_switching_point "No Switching points at either first or second visit"


save "${DATA}data_clean_working.dta", replace

















