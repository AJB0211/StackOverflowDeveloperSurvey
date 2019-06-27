suppressMessages(suppressWarnings(library(tidyverse)))
## Concatenate master frame from frames from all years


#yrs <- c(df17,df18)
xFrame <- rbind(df17,df18,df19)
