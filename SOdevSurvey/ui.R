library(shiny)
library(shinydashboard)
library(googleVis)
library(ggplot2)
suppressMessages(suppressWarnings(library(tidyverse)))

shinyUI(dashboardPage(
  
  # Application title
  dashboardHeader(title = "Stack Overflow Developer Survey"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName="Intro",
               menuSubItem("Description",             tabName = "Description"),
               menuSubItem("Data Sets and Variables", tabName = "overset"),
               menuSubItem("Employment",              tabName = "Employment"),
               menuSubItem("Country",                 tabName = "country")
               #menuSubItem("Job Title",               tabName = "jobTitle")
               
              ),
      menuItem("Experience", tabName = "exp"#),
               # menuSubItem("Education",         tabName = "dsEdu"),
               # menuSubItem("Undergrad Major",   tabName = "dsMajor"),
               # menuSubItem("Years Coding",      tabName = "dsYearsCoding"),
               # menuSubItem("Years Coding Professionally", tabName = "dsYearsCodingProf")
               ),
      menuItem("Job Search", tabName = "JobSearch",
               # menuSubItem("Years at Job",        tabName = "dsJobYear"),
               # menuSubItem("Job Search Status",   tabName = "dsSearchStatus"),
               menuSubItem("Time After Bootcamp", tabName = "dsBootcamp")
               ),
      # menuItem("Job Tech", tabName = "jobTech", 
      #          menuItem("Languages",  tabName="sLanguages",
      #                   menuSubItem("R and Python", tabName = "Rpy"),
      #                   menuSubItem("Scala",        tabName = "Scala")
      #                   ),
      #          menuItem("Frameworks", tabName = "dsFrameworks"),
      #          menuItem("Databases",  tabName = "dsDatabases")
      #          ),
      menuItem("Compensation", tabName = "comp",
               menuSubItem("Salary",       tabName = "dsSalary")#,
               # menuItem("Salary by Tech",  tabName = "dsSalTech",
               #          menuSubItem("Salary by Languages Used",   tabName= "dsSalLang"),
               #          menuSubItem("Salary by Frameworkds Used", tabName = "dsSalFw")
               #          )
               ),
      # menuItem("Demographics",     tabName = "demog"),
      menuItem("Future Work",      tabName = "future")
  )),
  
  dashboardBody(
    tabItems(
      #### Intro ####
      tabItem(tabName = "Intro"),
      tabItem(tabName = "Description",
              h2("Project Abstract"),
              p("This project is largely built around exploratory data analysis for experience with the R Shiny framework in line with the New York City Data Science Academy curriculum."),
              p("Relevant source code for this project is hosted in a ", a("Github repository", href="https://github.com/AJB0211/StackOverflowDeveloperSurvey")," while data are stored locally in a SQLite database."),
              h2("Data Set"),
              p("This Shiny app is built around data from the ", a("Stack Overflow Developer Surveys.", href="https://insights.stackoverflow.com/survey/?utm_source=so-owned&utm_medium=blog&utm_campaign=dev-survey-2019&utm_content=launch-blog")),
              p("Currently, the data sets deployed in this project are limited limited to the years 2017 and 2018 with data workup structured for integration of previous and future years."),
              h2("Subsetting"),
              p("This analysis is intended to provide information to prospective data scientists in New York City. As such, later study is done on a subset of relevant data from this study to limit impact on inferences from confounding information. These variables are studied in the following subsections but future sections are limited to the following sub-categories:"),
              tags$div(
                tags$ul(
                  tags$li('Respondents with "Data Scientist", "Machine Learning Specialist", and "Data Analyst" job titles'),
                  tags$li('Respondents who are "full-time" employees'),
                  tags$li('Salary data is limited to USD and to respondents located in the United States')
                )
              )
              
              
              ),
      tabItem(tabName = "overset",
              p("Each Stack Overflow survey covers a wide array of topics, some of which are not consistent between years. Some survey questions are more comical in nature or are not relevant to the aim of this study. As such a limited subset of survey questions are captured in the compiled data set. This section provides an overview of the response types that have been cleaned and aggregated to be respresented in the stored database."),
              fluidRow(box(htmlOutput("yearHist"), height = 500),
                       box(htmlOutput("DSrateBox"))),
              fluidRow(box(htmlOutput("catNA"), height = 550,width=900))
              ),
      
      tabItem(tabName = "Employment",
              h1("Employment Types"),
              p("We see that the majority of respondents are employed full time. Beyond eliminating confounding variables, the Employment type relevant to the interests of this study is full-time so we filter our dataset on this variable"),
              fluidRow(box(htmlOutput("employmentChart"), width=750))
              ),
      tabItem(tabName = "country",
              h1("Country"),
              p("While respondents are drawn from a variety of countries, we subset on US residents who are both in the majority and the subset of interest."),
              fluidRow(box(htmlOutput("countryChart"), width=750)),
              p("Limiting study to respondents in Data Science fields, we see that they are largely distributed similarly to the full sample. We make no further study of the subsubsample distribution deviating from the full sample at this time."),
              p("Of note, we have reason to believe that the sample deviates significantly from the true population. This is motivated by large quantities of machine learning research out of Canada and China which are likely to be under-represented by this survey"),
              fluidRow(box(htmlOutput("DScountries"), width=750))
              ),

      
      #### Experience ####
      tabItem(tabName = "exp",
              "Education, undergrad, yearscoding, yearscodingprof"),
      
      #### Job Search ####
      tabItem(tabName = "hire"),
      tabItem(tabName = "dsJobYear"),
      tabItem(tabName = "dsJobSearch"),
      tabItem(tabName = "dsBootcamp",
              h1("Time After Bootcamp Until Hire"),
              fluidRow(box(p("Many bootcamp attendees have a job before entering the bootcamp. Of those that do not, a large proportion are found to be hired within the first month after graduation."),
                           p("This may be due to more proactive bootcamp attendees post on a resource like Stack Overflow")),
                       box(htmlOutput("dsBootRateBox"))),
              fluidRow(box(htmlOutput("dsBootcamp"), width = 750))
              ),
      
      
      
      #### Job Tech ####
      tabItem(tabName = "jobTech",
              "Languages, platforms, databases, and frameworks"),
      tabItem(tabName = "Languages",
              "Language Plot here"),
      tabItem(tabName = "Rpy",
              "R and python stuff here"),
      tabItem(tabName = "Scala",
              "Scala stuff here"),
      
      
      #### Compensation #### 
      tabItem(tabName = "comp",
              "Salary, currency and the correlations"),
      tabItem(tabName = "dsSalary",
              h1("Salary of Data Scientists Compared to Subsample"),
              p("Data Scientists make more than the average respondent by about $10k on average"),
              p("Note that there was some filtering involved in achieving this answer due to irregularities in a lot of responses. Possible reasons include incorrect currency type, prorating incomplete year employment, and graduate students."),
              fluidRow(box(htmlOutput("meanSal"))),
              fluidRow(box(htmlOutput("dsMeanSal"))),
              fluidRow(box(htmlOutput("salpval"))),
              p("Red is population, blue is data scientists"),
              box(plotOutput("salaryDensity"), width = 500, height = 500)
              ),
      
      
      
      
      #### Demographics ####
      tabItem(tabName = "demog",
              "EducationParents, Sex, Country, Age"),
      
      
      #### Future Work ####
      tabItem(tabName = "future",
              h1("Immediate Work"),
              p("Work outlined by the current structure of the Shiny App"),
              tags$div(
                tags$ul(
                  tags$li("About section to describe the data structure and workup"),
                  tags$li("Integration of blog post"),
                  tags$li("Demographics Section (may be eliminated)"),
                  tags$li("Further analysis of languages, such as common groupings"),
                  tags$li("Grouping of language and tech (eg Scala and Spark)"),
                  tags$li("Cleaning, annotating, and beautifying")
              )),
              h1("General data exploration"),
              p("Further exploration of already included response types such as:"),
              tags$div(
                tags$ul(
                  tags$li('Currency'),
                  tags$li('Salary'),
                  tags$li('Undergrad major'),
                  tags$li('Time after bootcamp'),
                  tags$li('Variation of responses with respect to year'),
                  tags$li('Statistical difference between the jobs subset as data science roles as compared to the general sample population')
                )),
              h1("Data to be integrated"),
              tags$div(
                tags$ul(
                  tags$li('Prior years 2011-2015'),
                  tags$li('Year 2016, which is in a similar format to included years 2017 and 2018'),
                  tags$li('Year 2019, to be released in May 2019'),
                  tags$li('Age and other demographics'),
                  tags$li('Desired tech, a benchmark for the direction of industry tool adoption'),
                  tags$li('Ethic questions, particularly for topics that directly pertain to Data Science jobs such as advertising data'),
                  tags$li('Efficacy questions: time until productive in a job role, feeling of skill with tools'),
                  tags$li('Bonus questions: do aliens exist? do you prefer cats or dogs"?')
                ))
              
              
              )
    )
    
    
    
  )
  

  )
)
