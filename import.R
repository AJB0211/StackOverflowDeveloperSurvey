suppressMessages(suppressWarnings(library(tidyverse)))
## This script imports data into workspace

s19 <- read.csv(file.path("data","2019","survey_results_public.csv"))
# ex19 <- read.csv(file.path("data","2019","survey_results_schema.csv"),header=F)

s18 <- read.csv(file.path("data","2018","survey_results_public.csv"))
# ex18 <- read.csv(file.path("data","2018","survey_results_schema.csv"),header=F)

s17 <- read.csv(file.path("data","2017","survey_results_public.csv"))
# ex17 <- read.csv(file.path("data","2017","survey_results_schema.csv"),header=F)



#s16 <- read.csv("./data/2016/2016 Stack Overflow Survey Responses.csv")