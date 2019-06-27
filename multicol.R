suppressMessages(suppressWarnings(library(tidyverse)))
## This script manages columns where data is stored in a concatenated string over multiple values

#### Language ####
l17 <- df17 %>% select(id,year,Language) %>% separate_rows(Language,sep=";")
l18 <- df18 %>% select(id,year,Language) %>% separate_rows(Language,sep=";")
l19 <- df19 %>% select(id,year,Language) %>% separate_rows(Language,sep=";")

langFrame <- rbind(l17,l18,l19)
langFrame <- langFrame %>% mutate(Language = str_trim(Language)) %>% 
  mutate(Language = case_when(
    grepl("Shell", Language) ~ "Shell",
    TRUE ~ Language
  ))


#### Developer Type ####
dev17 <- df17 %>% select(id,year,DevType) %>% separate_rows(DevType,sep=";")
dev18 <- df18 %>% select(id,year,DevType) %>% separate_rows(DevType,sep=";")
dev19 <- df19 %>% select(id,year,DevType) %>% separate_rows(DevType,sep=";")

devFrame <- rbind(dev17,dev18,dev19)
devFrame <- devFrame %>% mutate(DevType = str_trim(DevType)) %>%
            mutate(DevType = case_when(
              grepl("Embed",        DevType) ~ "Embedded Devices developer",
              grepl("^Mob",         DevType) ~ "Mobile Developer",
              grepl("^Desk",        DevType) ~ "Destop Application developer",
              grepl("Data [Ss]c",   DevType) ~ "Data Scientist",
              grepl("statist",      DevType) ~ "Developer with Math Background",
              grepl("learnin",      DevType) ~ "Machine Learning Engineer",
              grepl("Database",     DevType) ~ "Database Administrator",
              grepl("(^Qual)|(QA)", DevType) ~ "Quality Assurance Engineer",
              grepl("suite",        DevType) ~ "C suite",
              grepl("analyst",      DevType) ~ "Data Analyst",
              TRUE ~ DevType
            ))

#### Framework ####
fw17 <- df17 %>% select(id,year,Framework) %>% separate_rows(Framework,sep=";")
fw18 <- df18 %>% select(id,year,Framework) %>% separate_rows(Framework,sep=";")
fw19 <- df19 %>% select(id,year,Framework) %>% separate_rows(Framework,sep=";")

fwFrame <- rbind(fw17,fw18,fw19)
fwFrame <- fwFrame %>% mutate(Framework = str_trim(Framework)) %>% 
          mutate(Framework = case_when(
            grepl("Torch",   Framework) ~ "Pytorch",
            grepl("Angul",   Framework) ~ "Angular",
            TRUE ~ Framework
          ))


#### Database ####
db17 <- df17 %>% select(id,year,Database) %>% separate_rows(Database,sep=";")
db18 <- df18 %>% select(id,year,Database) %>% separate_rows(Database,sep=";")
db19 <- df19 %>% select(id,year,Database) %>% separate_rows(Database,sep=";")

dbFrame <- rbind(db17,db18,db19)
dbFrame <- dbFrame %>% mutate(Database = str_trim(Database)) %>% 
          mutate(Database =case_when(
            grepl("Azure", Database) ~ "Microsoft Azure",
            TRUE ~ Database
          ))

#### Platform ####
p17 <- df17 %>% select(id,year,Platform) %>% separate_rows(Platform,sep=";")
p18 <- df18 %>% select(id,year,Platform) %>% separate_rows(Platform,sep=";")
p19 <- df19 %>% select(id,year,Platform) %>% separate_rows(Platform,sep=";")

platFrame <- rbind(p17,p18,p19)
platFrame <- platFrame %>% mutate(Platform = str_trim(Platform)) %>% 
              mutate(Platform = case_when(
                grepl("AWS",    Platform) ~ "AWS",
                grepl("Azure",  Platform) ~ "Azure",
                grepl("Linux",  Platform) ~ "Linux",
                grepl("Google Cloud", Platform) ~ "Google Cloud",
                grepl("Mac", Platform) ~ "Mac OS",
                grepl("(Windows$)|(Windows Desk)", Platform) ~ "Windows",
                grepl("Other", Platform) ~ "Other",
                TRUE ~ Platform
              ))


#### Drop Columns fixed here ####
df17 <- df17 %>% select(-c(Language,DevType,Database,Framework,Platform))
df18 <- df18 %>% select(-c(Language,DevType,Database,Framework,Platform))
df19 <- df19 %>% select(-c(Language,DevType,Database,Framework,Platform))



