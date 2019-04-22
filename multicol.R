suppressMessages(suppressWarnings(library(tidyverse)))
## This script manages columns where data is stored in a concatenated string over multiple values


#### Language ####
l17 <- df17 %>% select(id,year,Language) %>% separate_rows(Language,sep=";")
l18 <- df18 %>% select(id,year,Language) %>% separate_rows(Language,sep=";")

langFrame <- rbind(l17,l18)


#### Developer Type ####
dev17 <- df17 %>% select(id,year,DevType) %>% separate_rows(DevType,sep=";")
dev18 <- df18 %>% select(id,year,DevType) %>% separate_rows(DevType,sep=";")

devFrame <- rbind(dev17,dev18)

#### Framework ####
fw17 <- df17 %>% select(id,year,Framework) %>% separate_rows(Framework,sep=";")
fw18 <- df18 %>% select(id,year,Framework) %>% separate_rows(Framework,sep=";")

fwFrame <- rbind(fw17,fw18)


#### Database ####
db17 <- df17 %>% select(id,year,Database) %>% separate_rows(Database,sep=";")
db18 <- df18 %>% select(id,year,Database) %>% separate_rows(Database,sep=";")

dbFrame <- rbind(db17,db18)

#### Drop Columns fixed here ####
df17 <- df17 %>% select(-c(Language,DevType,Database,Framework,Platform))
df18 <- df18 %>% select(-c(Language,DevType,Database,Framework,Platform))



#### Clean ####
rm(fw17,fw18,l17,l18,dev17,dev18,db17,db18)