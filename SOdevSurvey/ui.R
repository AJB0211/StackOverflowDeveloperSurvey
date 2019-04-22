library(shiny)
library(shinydashboard)
library(googleVis)
suppressMessages(suppressWarnings(library(tidyverse)))

shinyUI(dashboardPage(
  
  # Application title
  dashboardHeader(title = "Stack Overflow Developer Survey"),
  
  dashboardSidebar(
    menuItem("Experience", tabName = "exp"),
    menuItem("Hiring", tabName = "hire"),
    menuItem("Job Tech", tabName = "jobTech"),
    menuItem("Compensation", tabName = "comp"),
    menuItem("Demographics", tabName = "demog"),
    menuItem("Future Work", tabName = "future")
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "exp",
              "Education, undergrad, yearscoding, yearscodingprof"),
      tabItem(tabName = "hire",
              "JobYear, JobsearchStatus, TimeAfterBootcamp"),
      tabItem(tabName = "jobTech",
              "Languages, platforms, databases, and frameworks"),
      tabItem(tabName = "comp",
              "Salary, currency and the correlations"),
      tabItem(tabName = "demog",
              "EducationParents, Sex, Country, Age"),
      tabItem(tabName = "future",
              "description of future goals")
      
    )
    
    
    
  )
  

  )
)
