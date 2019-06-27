suppressMessages(suppressWarnings(library(tidyverse)))
## This script handles the imputation and modification of data

## Does not have bootcamp information
## Requires more work

## This is the last year this indexing system will work for
## Next year the int index will exceed the capacity of int32's 
## This year the size of the data set will stretch into the next year index as well

df19 <- s19 %>% mutate(YearsCode = case_when(grepl("^Less", YearsCode) ~ 0,
                                             TRUE ~ suppressWarnings(as.numeric(as.character(YearsCode)))
                                             # TRUE ~ NA_character_
                                             ),
                       YearsCodePro = case_when(grepl("^Less", YearsCodePro) ~ 0,
                                               TRUE ~ suppressWarnings(as.numeric(as.character(YearsCodePro)))
                                               # TRUE ~ NA_character_
                                               )) %>% 
  mutate(
  id = 2019E5 + seq.int(nrow(s19)), year= 2019,
  Student = case_when(grepl("^N",   Student) ~ "no",
                      grepl("full", Student) ~ "full-time",
                      grepl("part", Student) ~ "part-time",
                      TRUE ~ NA_character_),
  
  Employment = case_when(grepl("part", Employment) ~ "part-time",
                         grepl("full", Employment) ~ "full-time",
                         grepl("^Ind", Employment) ~ "freelance",
                         grepl("but",  Employment) ~ "looking",
                         grepl("not",  Employment) ~ "unemployed",
                         grepl("^Ret", Employment) ~ "retired",
                         TRUE ~ NA_character_),
  
  Education = case_when(grepl("^Ba",   EdLevel) ~ "Bachelor's",
                        grepl("^Assoc",EdLevel) ~ "Associate's",
                        grepl("^So",   EdLevel) ~ "Post-secondary",
                        grepl("^Mas",  EdLevel) ~ "Master's",
                        grepl("^Sec",  EdLevel) ~ "Secondary",
                        grepl("^Prof", EdLevel) ~ "Professional",
                        grepl("^Oth",  EdLevel) ~ "Doctoral",
                        grepl("^Pri",  EdLevel) ~ "Primary",
                        grepl("never", EdLevel) ~ "None",
                        TRUE ~ NA_character_),
  
  Undergrad = case_when(grepl("^Math",    UndergradMajor) ~ "Math",
                        grepl("natur",    UndergradMajor) ~ "Natural Science",
                        grepl("^Comp",    UndergradMajor) ~ "CompSci",
                        grepl("^Fine",    UndergradMajor) ~ "Art",
                        grepl("^Inf",     UndergradMajor) ~ "IT",
                        grepl("civil",    UndergradMajor) ~ "Engineering",
                        grepl("business", UndergradMajor) ~ "Business",
                        grepl("social",   UndergradMajor) ~ "Social Science",
                        grepl("^Web",     UndergradMajor) ~ "WebDev",
                        grepl("human",    UndergradMajor) ~ "Humanities",
                        grepl("never",    UndergradMajor) ~ "Undeclared",
                        grepl("health",   UndergradMajor) ~ "Health Science",
                        TRUE ~ NA_character_),
  
  ## Block them to align with previous year formats
  YearsCoding = case_when(YearsCode <= 2 ~ "0-2",
                          YearsCode <= 5 ~ "3-5",
                          YearsCode <= 8 ~ "6-8",
                          YearsCode <= 11 ~ "9-11",
                          YearsCode <= 14 ~ "12-14",
                          YearsCode <= 17 ~ "15-17",
                          YearsCode <= 20 ~ "18-20",
                          YearsCode <= 23 ~ "21-23",
                          YearsCode <= 26 ~ "24-26",
                          YearsCode <= 29 ~ "2-19",
                          YearsCode >29 ~ "30 or more",
                          TRUE ~ NA_character_),
                          
  
  YearsCodingProf = case_when(YearsCodePro <= 2 ~ "0-2",
                              YearsCodePro <= 5 ~ "3-5",
                              YearsCodePro <= 8 ~ "6-8",
                              YearsCodePro <= 11 ~ "9-11",
                              YearsCodePro <= 14 ~ "12-14",
                              YearsCodePro <= 17 ~ "15-17",
                              YearsCodePro <= 20 ~ "18-20",
                              YearsCodePro <= 23 ~ "21-23",
                              YearsCodePro <= 26 ~ "24-26",
                              YearsCodePro <= 29 ~ "2-19",
                              YearsCodePro >29 ~ "30 or more",
                              TRUE ~ NA_character_),
  
  JobSearchStatus = case_when(grepl("open",     JobSeek) ~ "Open",
                              grepl("interest", JobSeek) ~ "Uninterested",
                              grepl("job$",     JobSeek) ~ "Active",
                              TRUE ~ NA_character_),
  
  JobYear = case_when(grepl("^L",    LastHireDate) ~ "<1",
                      grepl("^1",    LastHireDate) ~ "1-2",
                      grepl("^3",    LastHireDate) ~ "2-4",
                      grepl("^More", LastHireDate) ~ "4+",
                      TRUE ~ NA_character_
                      ),
  
  ### Match "data scientist or machine learning specialist"
  ###       "Data or business analyst"
  ### NOT "database administrator"
  DataScientist = grepl("(machine)|(analyst)",DevType),
  
  ## To align with previous years' format
  Age = case_when(Age < 18 ~ "Under 18 Years",
                  Age < 25 ~ "18 - 24 Years",
                  Age < 35 ~ "25 - 34 Years",
                  Age < 45 ~ "35 - 44 Years",
                  Age < 55 ~ "45 - 54 Years",
                  Age < 65 ~ "55 - 64 Years",
                  Age >= 65 ~ "65+ Years",
                  TRUE ~ NA_character_
                  ),
  
  EducationParents = NA_character_,
  # EducationParents = case_when(grepl("^Ba",   EducationParents) ~ "Bachelor's",
  #                              grepl("^Assoc",EducationParents) ~"Associate's",
  #                              grepl("^So",   EducationParents) ~ "Post-secondary",
  #                              grepl("^Mas",  EducationParents) ~ "Master's",
  #                              grepl("^Sec",  EducationParents) ~ "Secondary",
  #                              grepl("^Prof", EducationParents) ~ "Professional",
  #                              grepl("^I",    EducationParents) ~ "None",
  #                              grepl("^Oth",  EducationParents) ~ "Doctoral",
  #                              TRUE ~ NA_character_),
  
  Sex = case_when(grepl("^Man$",   Gender) ~ "Male",
                  grepl("^Woman$", Gender) ~ "Female",
                  TRUE ~ NA_character_),
  
  TimeAfterBootcamp = NA_character_,
  # TimeAfterBootcamp = case_when(grepl("^Imm",       TimeAfterBootcamp) ~ "Immediate",
  #                               grepl("already",    TimeAfterBootcamp) ~ "Before",
  #                               grepl("^Six",       TimeAfterBootcamp) ~ "6-12 Months",
  #                               grepl("^Four",      TimeAfterBootcamp) ~ "4-6 Months",
  #                               grepl("^One",       TimeAfterBootcamp) ~ "1-3 Months",
  #                               grepl("^Less",      TimeAfterBootcamp) ~ "<1 Month",
  #                               grepl("^Long",      TimeAfterBootcamp) ~ ">1 Year",
  #                               grepl("haven",      TimeAfterBootcamp) ~ "Searching",
  #                               TRUE ~ NA_character_),
  Salary = round(as.numeric(ConvertedComp),
                 )
  
  
  
  
) %>% 
  select(id, year,
         Country, Student, Education, Undergrad, Employment, YearsCoding, YearsCodingProf, 
         JobYear, JobSearchStatus,TimeAfterBootcamp, DataScientist,
         DevType, Language =  LanguageWorkedWith, Platform = PlatformWorkedWith, Database = DatabaseWorkedWith, Framework = WebFrameWorkedWith,
         Salary, #ConvertedSalary, SalaryType, 
         EducationParents, Age, Sex)

