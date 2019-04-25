
setwd("~/Documents/NYCDSA/projects/R_shiny/")

# Download data sets for reproducability
# source("download.R")


## This file sources other data workup procedures and produces and SQLite database for use by Shiny
source("import.R")
rm(s17,s18,s16,ex18,ex17)

#source("impute.R")

source("multicol.R")
rm(fw17,fw18,l17,l18,dev17,dev18,db17,db18,p17,p18)


source("concat.R")

source("export.R")
rm(xFrame,langFrame,devFrame,dbFrame,fwFrame,platFrame,conn)

