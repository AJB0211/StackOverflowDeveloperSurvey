
setwd("~/Documents/NYCDSA/projects/R_shiny/")

# Download data sets for reproducability
source("download.R")


## This file sources other data workup procedures and produces and SQLite database for use by Shiny
source("import.R")


print("Running impute_2019.R: data imputation")
source("impute_2019.R")

print("Running impute_2018.R: data imputation")
source("impute_2018.R")

print("Running impute_2017.R: data imputation")
source("impute_2017.R")
rm(s17,s18,s19)
# rm(ex18,ex17,ex19)

#source("impute.R")

print("Running multicol.R: splitting complex columns into unique features")
source("multicol.R")
rm(fw17,fw18,l17,l18,dev17,dev18,db17,db18,p17,p18)
rm(fw19,l19,dev19,db19,p19)

print("Running concat.R: ")
source("concat.R")
rm(df17,df18,df19)

print("Running export.R: writing DataFrames to SQLlite database")
source("export.R")
rm(xFrame,langFrame,devFrame,dbFrame,fwFrame,platFrame,conn)

print("SQLite database is complete")