suppressMessages(suppressWarnings(library(tidyverse)))
## This script handles the imputation and modification of data


df18 <- s18 %>% mutate(
  id = 2018E5 + seq.int(nrow(s18)), year= 2018,
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
  
  Education = case_when(grepl("^Ba",   FormalEducation) ~ "Bachelor's",
                        grepl("^Assoc",FormalEducation) ~ "Associate's",
                        grepl("^So",   FormalEducation) ~ "Post-secondary",
                        grepl("^Mas",  FormalEducation) ~ "Master's",
                        grepl("^Sec",  FormalEducation) ~ "Secondary",
                        grepl("^Prof", FormalEducation) ~ "Professional",
                        grepl("^Oth",  FormalEducation) ~ "Doctoral",
                        grepl("never", FormalEducation) ~ "None",
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
  
  YearsCoding = str_extract(YearsCoding,"^.*(?=\\s)"),
  
  YearsCodingProf = str_extract(YearsCodingProf,"^.*(?=\\s)"),
  
  JobSearchStatus = case_when(grepl("open",     JobSearchStatus) ~ "Open",
                              grepl("interest", JobSearchStatus) ~ "Uninterested",
                              grepl("job$",     JobSearchStatus) ~ "Active",
                              TRUE ~ NA_character_),
  
  JobYear = case_when(grepl("^L",         LastNewJob) ~ "<1",
                      grepl("^Between 1", LastNewJob) ~ "1-2",
                      grepl("^Between 2", LastNewJob) ~ "2-4",
                      grepl("^More",      LastNewJob) ~ "4+",
                      TRUE ~ NA_character_),
  
  DataScientist = grepl("(machine)|(analyst)",DevType), ### Match "data scientist or machine learning specialist"
  ###       "Data or business analyst"
  ### NOT "database administrator"
  Age = str_extract(Age,"^.*(?=\\s)"),
  
  EducationParents = case_when(grepl("^Ba",   EducationParents) ~ "Bachelor's",
                               grepl("^Assoc",EducationParents) ~"Associate's",
                               grepl("^So",   EducationParents) ~ "Post-secondary",
                               grepl("^Mas",  EducationParents) ~ "Master's",
                               grepl("^Sec",  EducationParents) ~ "Secondary",
                               grepl("^Prof", EducationParents) ~ "Professional",
                               grepl("^I",    EducationParents) ~ "None",
                               grepl("^Oth",  EducationParents) ~ "Doctoral",
                               TRUE ~ NA_character_),
  
  Sex = case_when(grepl("Male",   Gender) ~ "Male",
                  grepl("Female", Gender) ~ "Female",
                  TRUE ~ NA_character_),
  
  TimeAfterBootcamp = case_when(grepl("^Imm",       TimeAfterBootcamp) ~ "Immediate",
                                grepl("already",    TimeAfterBootcamp) ~ "Before",
                                grepl("^Six",       TimeAfterBootcamp) ~ "6-12 Months",
                                grepl("^Four",      TimeAfterBootcamp) ~ "4-6 Months",
                                grepl("^One",       TimeAfterBootcamp) ~ "1-3 Months",
                                grepl("^Less",      TimeAfterBootcamp) ~ "<1 Month",
                                grepl("^Long",      TimeAfterBootcamp) ~ ">1 Year",
                                grepl("haven",      TimeAfterBootcamp) ~ "Searching",
                                TRUE ~ NA_character_),
  Salary = round(as.numeric(Salary))
  
  
  
  
) %>% 
  select(id, year,
         Country, Student, Education, Undergrad, Employment, YearsCoding, YearsCodingProf, 
         JobYear, JobSearchStatus,TimeAfterBootcamp,
         DevType, Language =  LanguageWorkedWith, Platform = PlatformWorkedWith, Database = DatabaseWorkedWith, Framework = FrameworkWorkedWith,
         Salary, Currency, #ConvertedSalary, SalaryType, 
         EducationParents, Sex)

