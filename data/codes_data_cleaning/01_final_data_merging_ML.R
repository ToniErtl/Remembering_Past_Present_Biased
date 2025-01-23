rm(list=ls())

library(tidyverse)
library(readxl)
library(stringdist)

# read in questionaires, and merge them by ID


q1 <- readxl::read_xlsx("../data_raw/final_questionaires_raw.xlsx", sheet ="choices_1") %>% 
  select(-StartDate,
         - EndDate,
         -  Status,
         - IPAddress,
         -  Progress,
         -  "Duration (in seconds)",
         -  Finished,
         -  RecordedDate,
         -  ResponseId,
         -  RecipientLastName,
         -  RecipientFirstName,
         -  RecipientEmail,
         -  ExternalReference,
         -  LocationLatitude,
         -  LocationLongitude,
         -  DistributionChannel,
         -  UserLanguage) %>% 
  rename(Choice1_1 = 'Choice 1',
         Choice1_2 = 'Choice 2',
         Choice1_3 = 'Choice 3',
         Choice1_4 = 'Choice 4',
         Choice1_5 = 'Choice 5',
         Choice1_6 = 'Choice 6',
         Choice1_7 = 'Choice 7',
         Choice1_8 = 'Choice 8',
         Choice1_9 = 'Choice 9',
         Choice1_10 = 'Choice 10',
         Choice1_11 = 'Choice 11',
         Choice1_12 = 'Choice 12'
  ) %>% 
  # remove duplicate rows: 
  distinct(Neptun, .keep_all = TRUE) %>% 
  # The original questionaire was conducted in Hungarian: in the following code,
  # I recode the values to English.
  mutate(gender = case_when(gender=="Nő"~"Female",
                            TRUE~"Male"),
         mothereduc = case_when(mothereduc=="Általános Iskola"~"Primary School",
                                mothereduc=="Főiskola"~"BSC",
                                mothereduc=="Egyetem"~"MA",
                                mothereduc=="Érettségi"~"High School Graduation",
                                mothereduc=="Szakiskola"~"Vocational School",
                                mothereduc=="PhD"~"PhD",
         )) %>% 
  #FILTER OUT TRIALS
  filter(Neptun!="jjhgjhhjg")
  
  
  
q1$Neptun=toupper(stringr::str_extract(q1$Neptun, "^.{6}"))

q2 <- readxl::read_xlsx("../data_raw/final_questionaires_raw.xlsx", sheet ="choices_2") %>% 
  select(-StartDate,
         - EndDate,
         -  Status,
         - IPAddress,
         -  Progress,
         -  "Duration (in seconds)",
         -  Finished,
         -  RecordedDate,
         -  ResponseId,
         -  RecipientLastName,
         -  RecipientFirstName,
         -  RecipientEmail,
         -  ExternalReference,
         -  LocationLatitude,
         -  LocationLongitude,
         -  DistributionChannel,
         -  UserLanguage) %>% 
  # remove duplicate rows: 
  distinct(Neptun, .keep_all = TRUE) %>% 
  rename(Choice2_1 = 'Choice 1',
         Choice2_2 = 'Choice 2',
         Choice2_3 = 'Choice 3',
         Choice2_4 = 'Choice 4',
         Choice2_5 = 'Choice 5',
         Choice2_6 = 'Choice 6',
         Choice2_7 = 'Choice 7',
         Choice2_8 = 'Choice 8',
         Choice2_9 = 'Choice 9',
         Choice2_10 = 'Choice 10',
         Choice2_11 = 'Choice 11',
         Choice2_12 = 'Choice 12'
  )  %>% 
  #FILTER OUT TRIALS
  filter(Neptun!="bertipróba" & Neptun!="poiuuh" & Neptun!="ghjgjjkhkkjhjk"  )

q2$Neptun=toupper(stringr::str_extract(q2$Neptun, "^.{6}"))



q3 <- readxl::read_xlsx("../data_raw/final_questionaires_raw.xlsx", sheet ="choices_3_combined") %>% 
  select(-StartDate,
         - EndDate,
         -  Status,
         - IPAddress,
         -  Progress,
         -  "Duration (in seconds)",
         -  Finished,
         -  RecordedDate,
         -  ResponseId,
         -  RecipientLastName,
         -  RecipientFirstName,
         -  RecipientEmail,
         -  ExternalReference,
         -  LocationLatitude,
         -  LocationLongitude,
         -  DistributionChannel,
         -  UserLanguage) %>% 
  
  # remove duplicate rows: 
  distinct(Neptun, .keep_all = TRUE) %>% 
  rename(Choice3_1 = 'Choice 1',
         Choice3_2 = 'Choice 2',
         Choice3_3 = 'Choice 3',
         Choice3_4 = 'Choice 4',
         Choice3_5 = 'Choice 5',
         Choice3_6 = 'Choice 6',
         Choice3_7 = 'Choice 7',
         Choice3_8 = 'Choice 8',
         Choice3_9 = 'Choice 9',
         Choice3_10 = 'Choice 10',
         Choice3_11 = 'Choice 11',
         Choice3_12 = 'Choice 12'
  ) 

q3$Neptun=toupper(stringr::str_extract(q3$Neptun, "^.{6}"))




# MATCHING

# Set distance parameter:

Distance_Parameter = 0.25

method_text = "jaccard"

q2_tech <- q2
q2_tech$matching <- amatch(q2$Neptun,q1$Neptun, maxDist = Distance_Parameter,
                           method = method_text)

q2_tech <- q2_tech %>% filter(!is.na(matching))
q2_tech$Neptun_q2 = q2_tech$Neptun


new_vars = c("Choice2_1",
             "Choice2_2",
             "Choice2_3",
             "Choice2_4",
             "Choice2_5",
             "Choice2_6",
             "Choice2_7",
             "Choice2_8",
             "Choice2_9" ,
             "Choice2_10",
             "Choice2_11",
             "Choice2_12",
             "Neptun_q2")

q1_ml_matched <- q1


for (x in new_vars) {
  for (i in seq_along(q2_tech$matching)) {
    q1_ml_matched[q2_tech$matching[i], x] <- q2_tech[i, x]
  }
}




# now match q1 with q3

q3_tech <- q3
q3_tech$matching <- amatch(q3$Neptun,q1$Neptun, maxDist = Distance_Parameter,
                           method = method_text)

q3_tech <- q3_tech %>% filter(!is.na(matching))
q3_tech$Neptun_q3 = q3_tech$Neptun

new_vars = c("Neptun_q3",
              "Choice3_1",
             "Choice3_2",
             "Choice3_3",
             "Choice3_4",
             "Choice3_5",
             "Choice3_6",
             "Choice3_7",
             "Choice3_8",
             "Choice3_9" ,
             "Choice3_10",
             "Choice3_11",
             "Choice3_12",
             "Treatment"
             )

for (x in new_vars) {
  for (i in seq_along(q3_tech$matching)) {
    q1_ml_matched[q3_tech$matching[i], x] <- q3_tech[i, x]
  }
}


# Check how different are the matched strings:
neptun_codes <- q1_ml_matched %>% filter(!is.na(Choice3_12)) %>% 
  filter(!is.na(Choice2_12)) %>% 
  filter(!is.na(Neptun)) %>% 
    select(Neptun,Neptun_q2,Neptun_q3)

View(neptun_codes)

q1_ml_matched <- q1_ml_matched %>% 
  mutate(
  # difference between first and second choice
  # this helps calculate time inconsistency
  diff1 = Choice1_1- Choice2_1,
  diff2 = Choice1_2- Choice2_2,
  diff3 = Choice1_3- Choice2_3,
  diff4 = Choice1_4- Choice2_4,
  diff5 = Choice1_5- Choice2_5,
  diff6 = Choice1_6- Choice2_6,
  diff7 = Choice1_7- Choice2_7,
  diff8 = Choice1_8- Choice2_8,
  diff9 = Choice1_9- Choice2_9,
  diff10 = Choice1_10- Choice2_10,
  diff11 = Choice1_11- Choice2_11,
  diff12 = Choice1_12- Choice2_12,
  #Treatment correct remembrance:
  rememb1 = case_when(Choice3_1-Choice1_1 == 0 & Treatment==0 ~1,
                      Choice3_1-Choice2_1 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb2 = case_when(Choice3_2-Choice1_2 == 0 & Treatment==0 ~1,
                      Choice3_2-Choice2_2 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb3 = case_when(Choice3_3-Choice1_3== 0 & Treatment==0 ~1,
                      Choice3_3-Choice2_3 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb4 = case_when(Choice3_4-Choice1_4 == 0 & Treatment==0 ~1,
                      Choice3_4-Choice2_4 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb5 = case_when(Choice3_5-Choice1_5== 0 & Treatment==0 ~1,
                      Choice3_5-Choice2_5 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb6 = case_when(Choice3_6-Choice1_6 == 0 & Treatment==0 ~1,
                      Choice3_6-Choice2_6 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb7 = case_when(Choice3_7-Choice1_7 == 0 & Treatment==0 ~1,
                      Choice3_7-Choice2_7 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb8 = case_when(Choice3_8-Choice1_8 == 0 & Treatment==0 ~1,
                      Choice3_8-Choice2_8 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb9 = case_when(Choice3_9-Choice1_9 == 0 & Treatment==0 ~1,
                      Choice3_9-Choice2_9 == 0 & Treatment==1 ~1,
                      TRUE~0),
  rememb10 = case_when(Choice3_10-Choice1_10 == 0 & Treatment==0 ~1,
                       Choice3_10-Choice2_10 == 0 & Treatment==1 ~1,
                       TRUE~0),
  rememb11 = case_when(Choice3_11-Choice1_11 == 0 & Treatment==0 ~1,
                       Choice3_11-Choice2_11 == 0 & Treatment==1 ~1,
                       TRUE~0),
  rememb12 = case_when(Choice3_12-Choice1_12 == 0 & Treatment==0 ~1,
                       Choice3_12-Choice2_12 == 0 & Treatment==1 ~1,
                       TRUE~0),
)


q1_new_noNA <- q1_ml_matched %>% filter(!is.na(Choice3_12)) %>% 
  filter(!is.na(Choice2_12)) %>% 
  filter(!is.na(Neptun))
  
write.csv(q1_new_noNA,"../data_cleaned/data_nomissing.csv", row.names = FALSE)
foreign::write.dta(q1_new_noNA,"../data_cleaned/data_nomissing.dta")
write.csv(q1_ml_matched,"../data_cleaned/data.csv", row.names = FALSE)
  
