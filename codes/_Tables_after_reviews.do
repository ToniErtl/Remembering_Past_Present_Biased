* Pathway of using the data
global DATA "/Users/antalertl/Desktop/r_projects/remembering_past_present_biases/data/data_cleaned/"
* Pathway of outputs
global OUT "/Users/antalertl/Desktop/r_projects/remembering_past_present_biases/output/Tables_outputs/"


//----------------------------------------------------------------------
// Table 1 : Average Correct remembrance of earlier choices

clear all

use "${DATA}data_clean_working.dta"

		// Filters:	 
	drop if no_switching_point == 1




* Here are all the calculations needed to create the table:



* Present-biased group (First Visit)
ci mean total_remember if treatment == 0 & Present_bias_dummy == 1
* Time-consistent group (First Visit)
ci mean total_remember if treatment == 0 & timecons == 1
* Not Present-biased (First Visit)
ci mean total_remember if treatment == 0 & Present_bias_dummy == 0
* NEW: Future-biased (First visit)
ci mean total_remember if treatment == 0 & fb_dummy == 1 

gen pb_timecons =.
replace pb_timecons = 0 if treatment == 0 & Present_bias_dummy == 1
replace pb_timecons = 1 if treatment == 0 & timecons == 1

* NEW
gen fb_pb =.
replace fb_pb = 0 if treatment == 0 & fb_dummy == 1
replace fb_pb = 1 if treatment == 0 & Present_bias_dummy == 1

* ranksum (1) vs (2)
ranksum total_remember if treatment == 0, by(pb_timecons)
* ranksum (1) vs (3) 
ranksum total_remember if treatment == 0 , by(Present_bias_dummy)
* ranksum: future biased vs present biased
ranksum total_remember if treatment == 0, by(fb_pb)



//second part of the table:

* Present-biased group (Second Visit)
ci mean total_remember if treatment == 1 & Present_bias_dummy == 1
* Time-consistent group (Second Visit)
ci mean total_remember if treatment == 1 & timecons == 1
* Not Present-biased (Second Visit)
ci mean total_remember if treatment == 1 & Present_bias_dummy == 0
* NEW: Future-biased (First visit)
ci mean total_remember if treatment == 1 & fb_dummy == 1 


gen pb_timecons2 =.
replace pb_timecons2 = 0 if treatment == 1 & Present_bias_dummy == 1
replace pb_timecons2 = 1 if treatment == 1 & timecons == 1

* NEW
gen fb_pb2 =.
replace fb_pb2 = 0 if treatment == 1 & fb_dummy == 1
replace fb_pb2 = 1 if treatment == 1 & Present_bias_dummy == 1

* ranksum (1) vs (2)
ranksum total_remember if treatment == 1, by(pb_timecons2)
* ranksum (1) vs (3) 
ranksum total_remember if treatment == 1 , by(Present_bias_dummy)
* ranksum: future biased vs present biased
ranksum total_remember if treatment == 1, by(fb_pb2)



/// New comparisons: comparing first and second visits

* (1) Compare present biased: first vs second visit
gen pb_first_second =.
replace pb_first_second = 0 if treatment == 0 & Present_bias_dummy == 1
replace pb_first_second = 1 if treatment == 1 & Present_bias_dummy == 1

ranksum total_remember if Present_bias_dummy == 1, by(pb_first_second)


* (2) Compare time consistent: first vs second visit
gen tc_first_second =.
replace tc_first_second = 0 if treatment == 0 & timecons == 1
replace tc_first_second = 1 if treatment == 1 & timecons == 1

ranksum total_remember if timecons == 1, by(tc_first_second)


* (3) Compare NOT present biased: first vs second visit

gen nopb_first_second =.
replace nopb_first_second = 0 if treatment == 0 & Present_bias_dummy == 0
replace nopb_first_second = 1 if treatment == 1 & Present_bias_dummy == 0

ranksum total_remember if Present_bias_dummy == 0, by(nopb_first_second)


* (4) Compare Future-biased: first vs second visit

gen fb_first_second =.
replace fb_first_second = 0 if treatment == 0 & fb_dummy == 1
replace fb_first_second = 1 if treatment == 1 & fb_dummy == 1

ranksum total_remember if fb_dummy == 1, by(fb_first_second)




//----- 
* Appendix: Table C.7 : no sign-restriction
//------



clear all

use "${DATA}data_clean_working.dta"

		// Filters:	 
//	drop if no_switching_point == 1




* Here are all the calculations needed to create the table:



* Present-biased group (First Visit)
ci mean total_remember if treatment == 0 & Present_bias_dummy == 1
* Time-consistent group (First Visit)
ci mean total_remember if treatment == 0 & timecons == 1
* Not Present-biased (First Visit)
ci mean total_remember if treatment == 0 & Present_bias_dummy == 0
* NEW: Future-biased (First visit)
ci mean total_remember if treatment == 0 & fb_dummy == 1 

gen pb_timecons =.
replace pb_timecons = 0 if treatment == 0 & Present_bias_dummy == 1
replace pb_timecons = 1 if treatment == 0 & timecons == 1

* NEW
gen fb_pb =.
replace fb_pb = 0 if treatment == 0 & fb_dummy == 1
replace fb_pb = 1 if treatment == 0 & Present_bias_dummy == 1

* ranksum (1) vs (2)
ranksum total_remember if treatment == 0, by(pb_timecons)
* ranksum (1) vs (3) 
ranksum total_remember if treatment == 0 , by(Present_bias_dummy)
* ranksum: future biased vs present biased
ranksum total_remember if treatment == 0, by(fb_pb)



//second part of the table:

* Present-biased group (Second Visit)
ci mean total_remember if treatment == 1 & Present_bias_dummy == 1
* Time-consistent group (Second Visit)
ci mean total_remember if treatment == 1 & timecons == 1
* Not Present-biased (Second Visit)
ci mean total_remember if treatment == 1 & Present_bias_dummy == 0
* NEW: Future-biased (First visit)
ci mean total_remember if treatment == 1 & fb_dummy == 1 


gen pb_timecons2 =.
replace pb_timecons2 = 0 if treatment == 1 & Present_bias_dummy == 1
replace pb_timecons2 = 1 if treatment == 1 & timecons == 1

* NEW
gen fb_pb2 =.
replace fb_pb2 = 0 if treatment == 1 & fb_dummy == 1
replace fb_pb2 = 1 if treatment == 1 & Present_bias_dummy == 1

* ranksum (1) vs (2)
ranksum total_remember if treatment == 1, by(pb_timecons2)
* ranksum (1) vs (3) 
ranksum total_remember if treatment == 1 , by(Present_bias_dummy)
* ranksum: future biased vs present biased
ranksum total_remember if treatment == 1, by(fb_pb2)










//----------------------------------------------------------------------
// Regression Tables
//----------------------------------------------------------------------


// Regression Table 1: Main results, First visit vs Second visit, Present Bias Intensity

* GENERAL NOTE:
* For each regression, I start from scratch and load the data again, then filter out observations



clear all
use "${DATA}data_clean_working.dta"

drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1


reg Misremembering_dummy Present_bias_dummy , robust
outreg2 using "${OUT}regression_tables1.xls", replace tex(frag pr land) label sortvar(Present_bias_dummy)



clear all
use "${DATA}data_clean_working.dta"


drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

reg Misremembering_intensity Present_bias_dummy , robust
outreg2 using "${OUT}regression_tables1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)





clear all
use "${DATA}data_clean_working.dta"


drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

reg Misremembering_dummy Present_bias_dummy , robust
outreg2 using "${OUT}regression_tables1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)




clear all
use "${DATA}data_clean_working.dta"
drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

reg Misremembering_intensity Present_bias_dummy , robust
outreg2 using "${OUT}regression_tables1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)





//----------------------------------------------------------------------
// Regression Table 2: Main results, First visit vs Second visit, Present Bias Intensity


clear all
use "${DATA}data_clean_working.dta"

drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1


reg Misremembering_dummy Present_bias_intensity , robust
outreg2 using "${OUT}regression_tables2.xls", replace tex(frag pr land) label sortvar(Present_bias_intensity)



clear all
use "${DATA}data_clean_working.dta"


drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

reg Misremembering_intensity Present_bias_intensity , robust
outreg2 using "${OUT}regression_tables2.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)




clear all
use "${DATA}data_clean_working.dta"


drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

reg Misremembering_dummy Present_bias_intensity , robust
outreg2 using "${OUT}regression_tables2.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)



clear all
use "${DATA}data_clean_working.dta"
drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

reg Misremembering_intensity Present_bias_intensity , robust
outreg2 using "${OUT}regression_tables2.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)














// ---------------------

// We added a discussion part in the paper, and included a comprehensive table
// for other specifications.
// The following codes replicate these.







//-----------------------------------------------------------------




// TABLE 4 

// Table 4 is a combination of three large regression tables
// These were combined manually in the __Master_all_results.xlsx" table



// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------






//-----------------------------------------------------------------

* Part 1 of Table 4


* future biased individuals also present
* FB and PB controlled for separately
* Mismerembering intensity -> ABS. Misremembering intensity	
	
	
clear all
use "${DATA}data_clean_working.dta"

*drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_dummy Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_pb_fb_signrestricted.xls", replace tex(frag pr land) label sortvar(Present_bias_dummy)



clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_intensity_abs Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_pb_fb_signrestricted.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)





clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_dummy Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_pb_fb_signrestricted.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)






clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_intensity_abs Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_pb_fb_signrestricted.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)




clear all
use "${DATA}data_clean_working.dta"

*drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_dummy Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_pb_fb_signrestricted.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)



clear all
use "${DATA}data_clean_working.dta"


*drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_intensity_abs Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_pb_fb_signrestricted.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)




clear all
use "${DATA}data_clean_working.dta"


*drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_dummy Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_pb_fb_signrestricted.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)



clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1


gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_intensity_abs Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_pb_fb_signrestricted.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)









// ---------------------
//  
// PART 2 of TABLE 4:


// Y variable: Either correct remembering or not remembering towards the non-motivated direction

// Future biased individuals included

// ---------------------


* Future biased individuals also included
	
	
clear all
use "${DATA}data_clean_working.dta"

*drop if fb_dummy == 1
drop if Misremembering_intensity>0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)


reg Misremembering_dummy Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_nonmotivated_1.xls", replace tex(frag pr land) label sortvar(Present_bias_dummy)



clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
drop if Misremembering_intensity>0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

reg Misremembering_intensity_abs Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_nonmotivated_1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)




clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
drop if Misremembering_intensity>0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

reg Misremembering_dummy Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_nonmotivated_1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)






clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
drop if Misremembering_intensity>0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

reg Misremembering_intensity_abs Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_nonmotivated_1.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)




clear all
use "${DATA}data_clean_working.dta"

*drop if fb_dummy == 1
drop if Misremembering_intensity>0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1


recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 


reg Misremembering_dummy Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_nonmotivated_1.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)


clear all
use "${DATA}data_clean_working.dta"


*drop if fb_dummy == 1
drop if Misremembering_intensity>0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 



reg Misremembering_intensity_abs Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_nonmotivated_1.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)



clear all
use "${DATA}data_clean_working.dta"


*drop if fb_dummy == 1
drop if Misremembering_intensity>0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 



reg Misremembering_dummy Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_nonmotivated_1.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)


clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
drop if Misremembering_intensity>0
drop if treatment == 0
drop if no_switching_point == 1


gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1


recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 


reg Misremembering_intensity_abs Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_nonmotivated_1.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)








// End of Part 2 of Table 4

//---------------------------------------------------------

//--------
//--------
//--------



// Part 3 of Table 4:

* Robustness test: no restrictions used: 


* future biased individuals also present
* FB and PB controlled for separately
* Mismerembering intensity -> ABS. Misremembering intensity	
	
	
clear all
use "${DATA}data_clean_working.dta"

*drop if fb_dummy == 1
*drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 


reg Misremembering_dummy Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_norestriction.xls", replace tex(frag pr land) label sortvar(Present_bias_dummy)



clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
*drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

reg Misremembering_intensity_abs Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_norestriction.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)





clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
*drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_dummy Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_norestriction.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)






clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
*drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)

reg Misremembering_intensity_abs Present_bias_dummy fb_dummy, robust
test Present_bias_dummy = fb_dummy
outreg2 using "${OUT}NEW_regr_norestriction.xls", append tex(frag pr land) label sortvar(Present_bias_dummy)




clear all
use "${DATA}data_clean_working.dta"

*drop if fb_dummy == 1
*drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1


recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 


reg Misremembering_dummy Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_norestriction.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)



clear all
use "${DATA}data_clean_working.dta"


*drop if fb_dummy == 1
*drop if Misremembering_intensity<0
drop if treatment == 1
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1


recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 


reg Misremembering_intensity_abs Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_norestriction.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)




clear all
use "${DATA}data_clean_working.dta"


*drop if fb_dummy == 1
*drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1

gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1


recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_dummy Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_norestriction.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)



clear all
use "${DATA}data_clean_working.dta"
*drop if fb_dummy == 1
*drop if Misremembering_intensity<0
drop if treatment == 0
drop if no_switching_point == 1


gen Misremembering_intensity_abs = abs(Misremembering_intensity)
gen Time_bias_intensity = 0
replace Time_bias_intensity = Present_bias_intensity if Present_bias_dummy == 1
replace Time_bias_intensity = Future_bias_intensity if fb_dummy == 1

recode Present_bias_intensity . = 0 
recode Future_bias_intensity . = 0 

reg Misremembering_intensity_abs Present_bias_intensity Future_bias_intensity, robust
test Present_bias_intensity = Future_bias_intensity
outreg2 using "${OUT}NEW_regr_norestriction.xls", append tex(frag pr land) label sortvar(Present_bias_intensity)







// End of Part 3 of Table 4

















	
	
	
		
//----------------------------------------------------------------------
// Appendix B table: Randomization	
		
clear all
use "${DATA}data_clean_working.dta"

// Again, the only filter we used was we dropped subjects with inconsistent choices (i.e. multiple switching points)

		
*creating variables
gen female = (gender == "Female")
gen mother_dipl=0
replace mother_dipl=1 if mothereduc=="PhD"
replace mother_dipl=1 if mothereduc=="MA"
replace mother_dipl=1 if mothereduc=="BSC"



*randomization table contents:
prtest female, by(treatment)

prtest mother_dipl, by(treatment)


ttest Social_rank, by(treatment)
ranksum Social_rank, by(treatment)

ttest Math, by(treatment)
ranksum Math, by(treatment)

ttest Trust, by(treatment)
ranksum Trust, by(treatment)

ttest Risk, by(treatment)
ranksum Risk, by(treatment)	









//----------------------------------------------------------------------
// Appendix table: Table C6 Switching point Matrix:

clear all
use "${DATA}data_clean_working.dta"


		// Filters: dropping inconsistent ones 
drop if inconsistent == 1
drop if Switching_point1 == 0
drop if Switching_point2 == 0



* Create a transition matrix
tabulate Switching_point1 Switching_point2, matcell(Freq) row

* Calculate percentages manually and store in matrix
matrix Pct = Freq
forvalues i = 1/`=rowsof(Pct)' {
    scalar row_sum = 0
    forvalues j = 1/`=colsof(Pct)' {
        scalar row_sum = row_sum + Freq[`i', `j']
    }
    forvalues j = 1/`=colsof(Pct)' {
        matrix Pct[`i', `j'] = 100 * Freq[`i', `j'] / row_sum
    }
}

* Calculate the total counts for each row
matrix Totals = J(`=rowsof(Freq)', 1, .)
forvalues i = 1/`=rowsof(Freq)' {
    scalar row_sum = 0
    forvalues j = 1/`=colsof(Freq)' {
        scalar row_sum = row_sum + Freq[`i', `j']
    }
    matrix Totals[`i', 1] = row_sum
}

* Combine counts and totals
matrix CountsWithTotals = J(`=rowsof(Freq)', `=colsof(Freq)+1', .)
forvalues i = 1/`=rowsof(Freq)' {
    forvalues j = 1/`=colsof(Freq)' {
        matrix CountsWithTotals[`i', `j'] = Freq[`i', `j']
    }
    matrix CountsWithTotals[`i', `=colsof(Freq)+1'] = Totals[`i', 1]
}

* Combine percentages and totals
matrix PercentagesWithTotals = J(`=rowsof(Pct)', `=colsof(Pct)+1', .)
forvalues i = 1/`=rowsof(Pct)' {
    forvalues j = 1/`=colsof(Pct)' {
        matrix PercentagesWithTotals[`i', `j'] = Pct[`i', `j']
    }
    matrix PercentagesWithTotals[`i', `=colsof(Pct)+1'] = Totals[`i', 1]
}

* Export the counts matrix with totals to Excel
putexcel set "transition_matrix.xlsx", sheet("Counts") replace
putexcel A1 = matrix(CountsWithTotals), names

* Export the percentages matrix with totals to Excel
putexcel set "transition_matrix.xlsx", sheet("Percentages") modify
putexcel A1 = matrix(PercentagesWithTotals), names











// ---------------------



// Added a correlation table (Appendix C.4., Table C.8.)


clear all
use "${DATA}data_clean_working.dta"

* --- data exclusion: only those with no switching points

*drop if Present_bias_dummy == 1
*drop if Misremembering_intensity<0
*drop if treatment == 1
drop if no_switching_point == 1


gen Misremembering_intensity_abs = abs(Misremembering_intensity)


pwcorr Misremembering_dummy Misremembering_intensity_abs Switching_point1 Switching_point2 fb_dummy Present_bias_dummy Female Math Social_rank Trust Risk, star(.05)






//----------------------------------------------------------------------
// Appendix tables: Regression results with background variables

// 1)  	Table C9: Dependent variable: motivated misremembering dummy

clear all
use "${DATA}data_clean_working.dta"


		// FILTERS:
		drop if fb_dummy == 1
		drop if Misremembering_intensity<0
		drop if no_switching_point == 1
				
// Generate interaction terms in order to use all data in the same regression		

gen Second_visit=treatment
gen presentbdummy_secondvisit = Present_bias_dummy * Second_visit
gen presentb_secondvisit = Present_bias_intensity * Second_visit

label var Second_visit "Second Visit"
label var presentbdummy_secondvisit "P. Bias x Second Visit"
label var presentb_secondvisit "P. Bias Intensity x Second Visit"


reg Misremembering_dummy Present_bias_dummy Second_visit, robust
outreg2 using "${OUT}regr_c5.xls", replace tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_dummy Second_visit presentbdummy_secondvisit, robust
outreg2 using "${OUT}regr_c5.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_dummy Second_visit presentbdummy_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk, robust
outreg2 using "${OUT}regr_c5.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)


reg Misremembering_dummy Present_bias_intensity Second_visit, robust
outreg2 using "${OUT}regr_c5.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_intensity Second_visit presentb_secondvisit, robust
outreg2 using "${OUT}regr_c5.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_dummy Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk, robust
outreg2 using "${OUT}regr_c5.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)




// 2) 	Table C10: Dependent variable: motivated misremembering intensiity



reg Misremembering_intensity Present_bias_dummy Second_visit, robust
outreg2 using "${OUT}regr_c6.xls", replace tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_dummy Second_visit presentbdummy_secondvisit, robust
outreg2 using "${OUT}regr_c6.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_dummy Second_visit presentbdummy_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk, robust
outreg2 using "${OUT}regr_c6.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)


reg Misremembering_intensity Present_bias_intensity Second_visit, robust
outreg2 using "${OUT}regr_c6.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_intensity Second_visit presentb_secondvisit, robust
outreg2 using "${OUT}regr_c6.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)

reg Misremembering_intensity Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk, robust
outreg2 using "${OUT}regr_c6.xls", append tex(frag pr land) label sortvar(Present_bias_intensity Second_visit presentb_secondvisit Female Mother_has_diploma Social_rank Math Trust Risk)












