suppressMessages(suppressWarnings(library(tidyverse)))
## This script handles the imputation and modification of data

df17 <- s17 %>% mutate(
  id = 2017E5 + seq.int(nrow(s17)), year= 2017,
  Student = case_when(grepl("^N",   University) ~ "no",
                      grepl("full", University) ~ "full-time",
                      grepl("part", University) ~ "part-time",
                      TRUE ~ NA_character_),
  
  Employment = case_when(grepl("part", EmploymentStatus) ~ "part-time",
                         grepl("full", EmploymentStatus) ~ "full-time",
                         grepl("^Ind", EmploymentStatus) ~ "freelance",
                         grepl("but",  EmploymentStatus) ~ "looking",
                         grepl("not",  EmploymentStatus) ~ "unemployed",
                         grepl("^Ret", EmploymentStatus) ~ "retired",
                         TRUE ~ NA_character_),
  
  
  Education = case_when(grepl("^Ba",   FormalEducation) ~ "Bachelor's",
                        grepl("^Assoc",FormalEducation) ~ "Associate's",
                        grepl("^So",   FormalEducation) ~ "Post-secondary",
                        grepl("^Mas",  FormalEducation) ~ "Master's",
                        grepl("^Sec",  FormalEducation) ~ "Secondary",
                        grepl("^Prof", FormalEducation) ~ "Professional",
                        grepl("^Doc",  FormalEducation) ~ "Doctoral",
                        grepl("never", FormalEducation) ~ "None",
                        TRUE ~ NA_character_),     
  
  EducationParents = case_when(grepl("^So",           HighestEducationParents) ~ "Post-secondary",
                               grepl("bach",    HighestEducationParents) ~ "Bachelor's",
                               #grepl("^Assoc",  HighestEducationParents) ~ "Associate's",
                               grepl("^So",           HighestEducationParents) ~ "Post-secondary",
                               grepl("mas",           HighestEducationParents) ~ "Master's",
                               grepl("^High",         HighestEducationParents) ~ "Secondary",
                               grepl("prof",          HighestEducationParents) ~ "Professional",
                               grepl("doc",           HighestEducationParents) ~ "Doctoral",
                               grepl("know",          HighestEducationParents) ~ "Unknown",
                               grepl("^Prim",         HighestEducationParents) ~ "Primary",
                               grepl("^No",           HighestEducationParents) ~ "None",
                               TRUE ~ NA_character_),     
  
  
  Undergrad = case_when(grepl("^Math",                  MajorUndergrad) ~ "Math",
                        grepl("natur",                  MajorUndergrad) ~ "Natural Science",
                        grepl("^Comp",                  MajorUndergrad) ~ "CompSci",
                        grepl("^Fine",                  MajorUndergrad) ~ "Art",
                        grepl("^Inf",                   MajorUndergrad) ~ "IT",
                        grepl("non-computer-focused",   MajorUndergrad) ~ "Engineering",
                        grepl("business",               MajorUndergrad) ~ "Business",
                        grepl("social",                 MajorUndergrad) ~ "Social Science",
                        grepl("Web",                    MajorUndergrad) ~ "WebDev",
                        grepl("human",                  MajorUndergrad) ~ "Humanities",
                        grepl("never",                  MajorUndergrad) ~ "Undeclared",
                        grepl("else",                   MajorUndergrad) ~ "Other",
                        grepl("^Man",                   MajorUndergrad) ~ "Management",
                        grepl("health",                 MajorUndergrad) ~ "Health Science",
                        TRUE ~ NA_character_),        
  
  
  YearsCoding = case_when(grepl("^[L12]\\D",  YearsProgram,perl=T) ~ "0-2",
                          grepl("^[345]\\D",  YearsProgram,perl=T) ~ "3-5",
                          grepl("^[678]\\D",  YearsProgram,perl=T) ~ "6-8",
                          grepl("10|11",      YearsProgram,perl=T) ~ "9-11",
                          grepl("13|14",      YearsProgram,perl=T) ~ "12-14",
                          grepl("16|17",      YearsProgram,perl=T) ~ "15-17",
                          grepl("19|20",      YearsProgram,perl=T) ~ "18-20",
                          grepl("years",      YearsProgram,perl=T) ~ "20+",
                          TRUE ~ NA_character_),
  
  YearsCodingProf = case_when(grepl("^[L12]\\D",  YearsCodedJob,perl=T) ~ "0-2",
                              grepl("^[345]\\D",  YearsCodedJob,perl=T) ~ "3-5",
                              grepl("^[678]\\D",  YearsCodedJob,perl=T) ~ "6-8",
                              grepl("10|11",      YearsCodedJob,perl=T) ~ "9-11",
                              grepl("13|14",      YearsCodedJob,perl=T) ~ "12-14",
                              grepl("16|17",      YearsCodedJob,perl=T) ~ "15-17",
                              grepl("19|20",      YearsCodedJob,perl=T) ~ "18-20",
                              grepl("years",      YearsCodedJob,perl=T) ~ "20+",
                              TRUE ~ NA_character_),
  
  
  TimeAfterBootcamp = case_when(grepl("^Imm",       TimeAfterBootcamp) ~ "Immediate",
                                grepl("comple",     TimeAfterBootcamp) ~ "Immediate",
                                grepl("already",    TimeAfterBootcamp) ~ "Before",
                                grepl("^Six",       TimeAfterBootcamp) ~ "6-12 Months",
                                grepl("^Four",      TimeAfterBootcamp) ~ "4-6 Months",
                                grepl("^One",       TimeAfterBootcamp) ~ "1-3 Months",
                                grepl("^Less",      TimeAfterBootcamp) ~ "<1 Month",
                                grepl("^Long",      TimeAfterBootcamp) ~ ">1 Year",
                                grepl("haven",      TimeAfterBootcamp) ~ "Searching",
                                TRUE ~ NA_character_),
  
  Sex = case_when(grepl("Male",   Gender) ~ "Male",
                  grepl("Female", Gender) ~ "Female",
                  TRUE ~ NA_character_),
  
  JobYear = case_when(grepl("^L",         LastNewJob) ~ "<1",
                      grepl("^Between 1", LastNewJob) ~ "1-2",
                      grepl("^Between 2", LastNewJob) ~ "2-4",
                      grepl("^More",      LastNewJob) ~ "4+",
                      TRUE ~ NA_character_),
  
  JobSearchStatus = case_when(grepl("open",     JobSeekingStatus) ~ "Open",
                              grepl("interest", JobSeekingStatus) ~ "Uninterested",
                              grepl("job$",     JobSeekingStatus) ~ "Active",
                              TRUE ~ NA_character_),
  
  Salary=round(as.numeric(Salary))
  
) %>% 
  select(id,year,
         Country, Student, Education, Undergrad, Employment, YearsCoding, YearsCodingProf,
         JobYear, JobSearchStatus, TimeAfterBootcamp,
         DevType = DeveloperType, Language = HaveWorkedLanguage, #NonDevType = NonDeveloperType,  
         Platform = HaveWorkedPlatform, Database = HaveWorkedDatabase, Framework = HaveWorkedFramework,
         Salary, Currency,
         EducationParents, Sex)


