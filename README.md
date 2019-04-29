# StackOverflowDeveloperSurvey
This analysis explores the annual Stack Overflow Developer survey data published by the popular resource [Stack Overflow](https://insights.stackoverflow.com/survey/?utm_source=so-owned&utm_medium=blog&utm_campaign=dev-survey-2019&utm_content=launch-blog), one of the largest surveys of those who work with software. Emphasis is placed on topics data scientists including languages, salaries, platforms, and their relationship with other job types listed in these surveys. 

The file `workup.R` is the master file for data processing that sources other scripts contained in the library. To use this repo, edit the directory to reflect the local directory the repo is cloned to and uncomment `source("download.R")`. Then run `source("workup.R")`.


## v2.0
  * Pushed to shinyapp.io

## v1.8
  * Included SQL information in languages tab
  * Fixed critical typo in "Data Analyst" role cleaning
  * Transferred graphs from gVis to ggplot
  * Added US census data for degree levels

## v1.7
  * Added notes for usability
  * Cleared out loading then immediately cleaning up unused data sets

## v1.6
  * Added some notes for sharing
  * Removed local cache files from repo

## v1.5
  * Added frameworks
  * Presentation version

## v1.4
  * Fixed bad SQL query to define "data scientists", increasing quantity in subset
  * Added language frequencies
  * Added platforms table to database

## v1.3
  * Narrowed scope to US, full-time employment, and data science jobs
  * Populated shiny app tabs with first graphs
  * Truncated tabs for submission deadline
  * Launched first version on `shinyapps.io` - deploy failed. 

## v1.2
  * Finished collecting 2017, 2018 data sets into SQLite database
  * Structured Shiny interface

## v1.1
  * Updated README format
  * Further cleaning for year 2017
  * Removed variables from 2017,2018
    + add in further update
    + Dropped age (found in 2018, not 2017)

## v1.0
  * Built repository
  * Acquired data
  * Data import for years 2016,2017,2018
  * Data cleaning for 2018, 2017
