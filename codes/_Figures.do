
clear all


* Pathway of using the data
global DATA "/Users/antalertl/Desktop/r_projects/remembering_past_present_biases/data/data_cleaned/"
* Pathway of outputs
global OUT "/Users/antalertl/Desktop/r_projects/remembering_past_present_biases/output/Figures_outputs/"


use "${DATA}data_clean_working.dta"



//----------------------------------------------------------------------
// FIGURE 2 - Switching point histogram

* load data again from scratch
clear all
use "${DATA}data_clean_working.dta"


	// Filters:
	* no filters were used for this graph - we are just showing the data


	* generate variable:
gen sw_diff12 = Switching_point2-Switching_point1
label var sw_diff12 "Difference in switching points between second and first visit"

	*graph:
histogram sw_diff12 ,discrete width(1) percent color(navy)
graph export "${OUT}Figure_02_switching_point_diff.png",  as(png) replace





//----------------------------------------------------------------------
// FIGURE 3 - Fractional polynomial plot 

* load data again from scratch
clear all
use "${DATA}data_clean_working.dta"


	// Filters:
	* no filters were used for this graph - we are just showing the data


gen total_rem1 =.
replace total_rem1 = total_remember if treatment == 0
gen total_rem2 =.
replace total_rem2 = total_remember if treatment == 1
gen pb_cont = Present_bias_intensity	
	

*Combined graph
twoway (fpfitci total_rem1 pb_cont if treatment==0, lcolor(blue) fcolor(blue%30) lwidth(vvthin)) (fpfit total_rem1 pb_cont if treatment==0, lcolor(blue) lwidth(medium)) (fpfitci total_rem2 pb_cont if treatment==1, lcolor(orange) fcolor(orange%30) lwidth(vvthin)) (fpfit total_rem2 pb_cont if treatment==1, lcolor(orange) lwidth(medium)), xtitle("Intensity of present bias") ytitle("Number of correctly remembered choices") ylabel(1(1)12) yscale(range(1 12)) legend(order(1 4) label(1 "Remembering choices during the first visit") label(4 "Remembering choices during the second visit") pos(6) col(1) ring(0))


graph export "${OUT}combined_nonlinfit_pb_rem_final.png", as(png) replace






//--- Extra figure?


clear all
use "${DATA}data_clean_working.dta"
drop if treatment == 1
drop if no_switching_point == 1

twoway ///
    (scatter Switching_point3 Switching_point1  if Present_bias_dummy == 0 & fb_dummy==0, ///
        msymbol(circle) mcolor(navy) jitter(5)) ///
    (scatter Switching_point3 Switching_point1 if Present_bias_dummy == 1, ///
        msymbol(circle) mcolor(red) jitter(5)) ///
	(scatter Switching_point3 Switching_point1 if fb_dummy == 1, ///
        msymbol(circle) mcolor(orange) jitter(5)) ///
    (function y=x, range(0 12) lcolor(red) lpattern(dash)), ///
    xlabel(0(2)12) ylabel(0(2)12) ///
    ytitle("Switching Point Remembering") xtitle("First Visit Switching Point") ///
    title("") ///
	legend(off)

	
	
	
	

clear all
use "${DATA}data_clean_working.dta"
drop if treatment == 0
drop if no_switching_point == 1

twoway ///
    (scatter Switching_point3 Switching_point2 if Present_bias_dummy == 0 & fb_dummy==0, ///
        msymbol(circle) mcolor(navy) jitter(5)) ///
    (scatter Switching_point3 Switching_point2 if Present_bias_dummy == 1, ///
        msymbol(circle) mcolor(red) jitter(5)) ///
	(scatter Switching_point3 Switching_point2 if fb_dummy == 1, ///
        msymbol(circle) mcolor(orange) jitter(5)) ///
    (function y=x, range(0 12) lcolor(red) lpattern(dash)), ///
    xlabel(0(2)12) ylabel(0(2)12) ///
    ytitle("Switching Point Remembering") xtitle("Second Visit Switching Point") ///
    title("") ///
	legend(off)
	



//----------------------------------------------------------------------
// FIGURE APP C.1: - Distribution of Switching Points

* load data again from scratch

	// Filters:
	* no filters were used for this graph


// I created this graph in R, in the "Figures_R" file. It is in a separate code, however,
// I include the R code here as well:

/*
library(tidyverse)
library(ggplot2)

df <- haven::read_dta("/Users/antalertl/Desktop/r_projects/remembering_past_present_biases/data/data_cleaned/data_clean_working.dta")


df_long <- df %>%
    select(Switching_point1, Switching_point2) %>%
    pivot_longer(cols = c(Switching_point1, Switching_point2),
                 names_to = "Visit",
                 values_to = "Switching_point")
  
g1 <- ggplot(df_long, aes(x = Switching_point, fill = Visit)) +
    geom_bar(aes(y = (..count..)/sum(..count..)),position = "dodge", width =0.75) +
    scale_fill_manual(values = c("navyblue", "orange"), labels = c("First Visit", "Second Visit")) +
  scale_x_continuous(breaks = seq(0, 12, by = 1))+
    labs(
         x = "Switching Point",
         y = "Frequencies",
         fill = NULL) +
    theme_minimal()+
  theme(legend.position = "bottom",
        axis.title=element_text(size=14),
        legend.text = element_text(size = 16),
        axis.text.y = element_text(size=14),
        axis.text.x = element_text(size=14),
        )

ggsave("/Users/antalertl/Desktop/r_projects/remembering_past_present_biases/output/Figures_outputs/combined_hist_swp_density.pdf",
  g1,
  height = 8,
  width = 10)
*/


//----------------------------------------------------------------------
// FIGURE APP C.5:- Histogram of the intensities of misremembering during the first and second visits

// Again, I did this in R with the following code:



/*
df <- haven::read_dta("/Users/antalertl/Desktop/r_projects/remembering_past_present_biases/data/data_cleaned/data_clean_working.dta") %>% 
  filter(fb_dummy!=1) %>% 
  filter(no_switching_point == 0)

g2 <- df %>%  
  mutate(Visit = case_when(treatment==0 ~"First Visit",
                               treatment==1 ~"Second Visit")) %>% 
  count(Misremembering_intensity, Visit) %>% 
  group_by( Visit) %>% 
  mutate( prop = n / sum(n) *100 ) %>% 
ggplot() +
  aes(x = Misremembering_intensity, y = prop, fill = Visit) +
  geom_col(position = "dodge")+
  scale_fill_manual(values = c("navyblue", "orange"), labels = c("First Visit", "Second Visit")) +
  scale_x_continuous(breaks = seq(-12, 12, by = 1))+
  labs(
    x = "Misremembering Intensity",
    y = "Percentage",
    fill = NULL) +
  theme_minimal()+
  theme(legend.position = "bottom",
        axis.title=element_text(size=14),
        legend.text = element_text(size = 16),
        axis.text.y = element_text(size=14),
        axis.text.x = element_text(size=14),
  )
*/


//----------------------------------------------------------------------
