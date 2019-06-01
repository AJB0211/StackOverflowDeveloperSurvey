suppressMessages(suppressWarnings(library(tidyverse)))
## Concatenate master frame from frames from all years


#yrs <- c(df17,df18)
xFrame <- rbind(df17,df18)

rm(df17,df18)
