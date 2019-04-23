library(shiny)
library(shinydashboard)
library(googleVis)
library(ggplot2)

shinyUI(dashboardPage(
  
  # Application title
  dashboardHeader(title = "Stack Overflow Developer Survey"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName="Intro",
               menuSubItem("Description",             tabName = "Description"),
               menuSubItem("Data Sets and Variables", tabName = "overset"),
               menuSubItem("Employment",              tabName = "Employment"),
               menuSubItem("Country",                 tabName = "country")#,
               #menuSubItem("Job Title",               tabName = "jobTitle")
               
              ),
      menuItem("Experience", tabName = "exp",
               menuSubItem("Education",         tabName = "dsEdu"),
               menuSubItem("Undergrad Major",   tabName = "dsMajor")#,
               # menuSubItem("Years Coding",      tabName = "dsYearsCoding"),
               # menuSubItem("Years Coding Professionally", tabName = "dsYearsCodingProf")
               ),
      menuItem("Job Search", tabName = "JobSearch",
               # menuSubItem("Years at Job",        tabName = "dsJobYear"),
               # menuSubItem("Job Search Status",   tabName = "dsSearchStatus"),
               menuSubItem("Time After Bootcamp", tabName = "dsBootcamp")
               ),
      menuItem("Job Tech", tabName = "jobTech",
               menuSubItem("Languages",  tabName="Languages"),
               menuSubItem("ML Frameworks", tabName = "MLfw")),
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
      menuItem("Future Work",      tabName = "future"),
      menuItem("About",            tabName = "about",
               menuSubItem("About Me", tabName = "aboutme"),
               menuSubItem("Database Structure", tabName = "dbstruct"))
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
              fluidRow(box(htmlOutput("catNA"), height = 550))
              ),
      
      tabItem(tabName = "Employment",
              h1("Employment Types"),
              p("We see that the majority of respondents are employed full time. Beyond eliminating confounding variables, the Employment type relevant to the interests of this study is full-time so we filter our dataset on this variable"),
              fluidRow(box(htmlOutput("employmentChart")))
              ),
      tabItem(tabName = "country",
              h1("Country"),
              p("While respondents are drawn from a variety of countries, we subset on US residents who are both in the majority and the subset of interest."),
              fluidRow(box(htmlOutput("countryChart"), height=775)),
              p("Limiting study to respondents in Data Science fields, we see that they are largely distributed similarly to the full sample. We make no further study of the subsubsample distribution deviating from the full sample at this time."),
              p("Of note, we have reason to believe that the sample deviates significantly from the true population. This is motivated by large quantities of machine learning research out of Canada and China which are likely to be under-represented by this survey"),
              fluidRow(box(htmlOutput("DScountries"), height=775))
              ),

      
      #### Experience ####
      tabItem(tabName = "exp",
              "Education, undergrad, yearscoding, yearscodingprof"),
      tabItem(tabName = "dsEdu",
              h1("Degree"),
              fluidRow(box(htmlOutput("dsEduChart"), width = 750,height = 800))),
      tabItem(tabName = "dsMajor",
              h1("Major"),
              fluidRow(box(htmlOutput("dsMajorChart"), width = 750,height = 500))),
      
      #### Job Search ####
      tabItem(tabName = "hire"),
      tabItem(tabName = "dsJobYear"),
      tabItem(tabName = "dsJobSearch"),
      tabItem(tabName = "dsBootcamp",
              h1("Time After Bootcamp Until Hire"),
              fluidRow(box(p("Many bootcamp attendees have a job before entering the bootcamp. Of those that do not, a large proportion are found to be hired within the first month after graduation. The next largest proportion are hired in the first three months after graduation."),
                           p("This may be due to more proactive bootcamp attendees posting on a resource like Stack Overflow.")),
                       box(htmlOutput("dsBootRateBox"))),
              fluidRow(box(htmlOutput("dsBootcamp")))
              ),
      
      
      
      #### Job Tech ####
      tabItem(tabName = "jobTech",
              "Languages, platforms, databases, and frameworks"),
      tabItem(tabName = "Languages",
              h1("Language Frequencies for Data Scientists"),
              p("Python is by far the most common language followed by R, however a dominant quantity of data scientists who use R also use Python while the converse is not true. Scala lags behind both other languages observed for data science use"),
              fluidRow(box(htmlOutput("langBar"),height=500))),
      tabItem(tabName = "MLfw",
              h1("Machine Learning Frameworks"),
              p("Interestingly, nothing was included referencing Amazon's Sagemaker and Microsoft's Azure Machine Learning. Additionally, Theano and Keras were not mentioned nor were the significant libraries in SKlearn included. Spark has some native ML capabilities as well."),
              p("The chart below shows TensorFlow is far preferred to Pytorch, with most Pytorch users also knowing TensorFlow anyways."),
              fluidRow(box(htmlOutput("mlBar"), height = 500))
      ),
      
      
      #### Compensation #### 
      tabItem(tabName = "comp",
              "Salary, currency and the correlations"),
      tabItem(tabName = "dsSalary",
              h1("Salary of Data Scientists Compared to Subsample"),
              p("Data Scientists make more than the average respondent by about $4k on average"),
              p("Note that there was some filtering involved in achieving this answer due to irregularities in a lot of responses. Possible reasons include incorrect currency type, prorating incomplete year employment, and graduate students."),
              p("The distribution for data scientists is bimodal, skew right while the overall population is trimodal. It is possible t-tests are not valid for these distributions."),
              fluidRow(box(htmlOutput("meanSal"))),
              fluidRow(box(htmlOutput("dsMeanSal"))),
              fluidRow(box(htmlOutput("salpval"))),
              p("Red is population, blue is data scientists"),
              ## DECORATE WITH PROPER ANNOTATIONS
              fluidRow(box(plotOutput("salaryDensity"), width = 500, height = 500))
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
                  tags$li("Multivariate analysis of already presented response types"),
                  tags$li("Integration of blog post"),
                  tags$li("Model building"),
                  tags$li("SQL language and databases"),
                  #tags$li("Demographics Section (may be eliminated)"),
                  #tags$li("Further analysis of languages, such as common groupings"),
                  #tags$li("Grouping of language and tech (eg Scala and Spark)"),
                  tags$li("Cleaning, annotating, and beautifying")
              )),
              h1("General data exploration"),
              p("Further exploration of already included response types such as:"),
              tags$div(
                tags$ul(
                  tags$li('Currency'),
                  tags$li('Salary'),
                  #tags$li('Undergrad major'),
                  #tags$li('Time after bootcamp'),
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
              
              
              ),
      
      #### About ####
      tabItem(tabName="about"),
      tabItem(tabName="aboutme"),
      tabItem(tabName="dbstruct",
              h1("Database Structure"),
              h3("Input Data"),
              p("Data sets can be readily downloaded by year from Stack Overflow. Each year may have over 100 columns representing many more variables. Consequently, these data frames reflect the structure of the survey rather than being organized in tidy data. Of particular interest to this study: programming languages, platforms, database types, and job roles tend to be contained in single semicolon-separated strings that are not conducive to workup."),
              h3("Indexing"),
              p("In order for these response types to be operated on rapidly with join and filter operations they need to be separated into multiple tables in a database. Consistency between tables requires a consistent ID to relate different respondents within years. The input data sets include unique `respondent` identifiers but they may not be unique between years."),
              p("Consequently an `id` column is imputed where the first 4 digits are the year and the following 5 digits are a unique integer. This is unique for data sets smaller than 1E6 respondents and will likely not be resilient to the expected size of the 2019 data set. Additionally going to the next order of magnitude will exceed the max(Int32) so a new indexing solution will be applied when integrating the 2019 data set."),
              h3("Simple columns"),
              p("Response values are filtered for relevance within each year and cleaned for consistency between values between years. Categorical variable that may take on multiple values per respondent are split off into separate tables while all 'simple' response values are stored in a table named 'master'."),
              h3("Mutlicategorical Variables"),
              p("Responses such as languages respondents work with often take on a variable number of values between respondent. One option for storing these values would be to expand them into booleans over many columns, greatly increasing the dimensions of the master data frame. Additionally, this method is not scalable to introduction of new response categories with the addition of future survey years. This method would require a significant amount of manual data cleaning."),
              p("Storing these response types in their own data tables, indexed by the imputed respondent id supports both scalability and rapid querying using SQL join operations. The format of this data base is SQLite."),
              p("Consequently these values are stored in the following tables:"),
              tags$div(
                tags$ul(
                  tags$li("languages  - programming languages"),
                  tags$li("frameworks - frameworks for working with data such as tensorflow or AWS"),
                  tags$li("platforms  - physical platforms such as Windows Desktops or Gaming Consoles"),
                  tags$li("databases  - SQL, MongoDB, Hive...")
                ))
              )
    ))
  

))
