library(shiny)
library(shinydashboard)
library(RSQLite)
library(ggplot2)
suppressPackageStartupMessages(library(googleVis))
suppressMessages(suppressWarnings(library(tidyverse)))


shinyServer(function(input, output, session) {
  conn <- dbConnect(drv = SQLite(), dbname = "./SOdevSurvey.db")
  session$onSessionEnded(function(){dbDisconnect(conn)})
  
  
  mainDF <- dbReadTable(conn,"master")
  dsIds <- dbGetQuery(conn,
                      'SELECT id FROM devtypes
	                     GROUP BY id
	                     HAVING DevType = "Data Scientist" or 
                       DevType = "Machine Learning Engineer" or 
                       DevType = "Data Analyst";')
  
  output$yearHist <- renderGvis( mainDF %>% group_by(year) %>% summarize(count = n()) %>% mutate(year = as.character(year)) %>% 
                                   gvisColumnChart("year","count", options = list(
                                     title = "Number of Respondents by Year", vAxis = "{minValue: 0, maxValue: 100000}",
                                     legend = "{position: 'none'}",
                                     height = 500,
                                     #width = 500,
                                     chartArea = "{'width': '70%', 'height':'70%'}"
                                   )))
  
  output$catNA <- renderGvis( mainDF %>% select(-c(year)) %>% summarize_all(funs(sum(is.na(.)))) %>% 
                                gvisBarChart(options = list(title="Number of Missing Values by Category", 
                                                            #vAxis.textPosition = "out", 
                                                            bar.groupWidth = '200%',
                                                            legend = "none",
                                                            height=500,
                                                            #width=500,
                                                            chartArea = "{'width': '90%', 'height':'70%'}"
                                                            #chartArea.width = "90%",
                                                            #chartArea.height = "90%"
                                                            )))
  
  output$employmentChart <- renderGvis( mainDF %>% group_by(Employment) %>% summarize(count = n()) %>% arrange(count) %>% 
                                          gvisColumnChart("Employment","count",options= list(
                                            title = "Employment Types of Respondents",
                                            width = 750,
                                            height = 500,
                                            hAxis.direction = 1,
                                            legend = "none"
                                          )))
  
  output$countryChart <- renderGvis( mainDF %>% group_by(Country) %>% summarize(count = n()) %>% arrange(desc(count)) %>% head(20) %>% 
                                      gvisColumnChart("Country","count",options = list(
                                        title = "Respondent Count by Top 20 Countries",
                                        width = 750,
                                        height = 500,
                                        hAxis.direction = 1,
                                        hAxis.slantedTextAngle = 90,
                                        legend="none"
                                      )))
                      
  
  subDF <- mainDF %>% filter(Employment=="full-time" & Country == "United States")
  
  PythonIds <- as.data.frame(dbGetQuery(conn,
                                        'SELECT id FROM languages
                                         GROUP BY id
                                         HAVING `Language` = "Python"'))
  RIds <- as.data.frame(dbGetQuery(conn,
                                   'SELECT id FROM languages
                                         GROUP BY id
                                         HAVING `Language` = "R"'))
  
  DSframe <- inner_join(mainDF,dsIds,by=c("id","id"))
  
  output$DScountries <- renderGvis( DSframe %>% group_by(Country) %>% summarize(count = n()) %>% arrange(desc(count)) %>% head(20) %>% 
                                      gvisColumnChart("Country","count",options = list(
                                        title = "Respondents in Data Science, Count by Top 20 Countries",
                                        width = 750,
                                        height = 500,
                                        hAxis.direction = 1,
                                        hAxis.slantedTextAngle = 90,
                                        legend="none"
                                      )))
  
  DSsubframe <- inner_join(subDF,dsIds,by=c("id","id"))
  
  isDSframe <- full_join(subDF,DSsubframe %>% mutate(isDS = TRUE), by=c("id","id")) %>% mutate(isDS = !is.na(isDS))
  
  isDSrate <- isDSframe %>% summarize(rDS = mean(isDS))
  
  output$DSrateBox <- renderInfoBox(infoBox("Rate of Data Scientists", isDSrate$rDS, icon=icon("calculator"), fill=F))
  
  DSbootRate <- DSsubframe %>% mutate(isBoot = !is.na(TimeAfterBootcamp)) %>% summarize(bootRate = mean(isBoot),bootCount = sum(isBoot))
  
  output$dsBootRateBox <- renderInfoBox(infoBox("Number of Bootcamp Attendees", DSbootRate$bootCount, icon=icon("calculator"), fill=F))
  
  output$dsBootcamp <- renderGvis( DSsubframe %>% filter(!is.na(TimeAfterBootcamp)) %>% mutate(tot = n()) %>% 
                                     group_by(TimeAfterBootcamp) %>% summarize(count = n(), tot=first(tot)) %>%  
                                     mutate(rate = count/tot) %>% arrange(desc(rate)) %>% 
                                     gvisColumnChart("TimeAfterBootcamp","rate", options = list(
                                       title = "Rate of Time Spent After Bootcamp in Job Search",
                                       legend = "none",
                                       width = 750,
                                       height = 500
                                     )))
  
  #meanSal <- (subDF %>% summarize(meanSal = mean(as.numeric(Salary),na.rm=T)))$meanSal
  #meanDSsal <- (DSsubframe %>% summarize(meanSal = mean(as.numeric(Salary),na.rm=T)))$meanSal
  meanSal <- (subDF %>% filter(Salary > 25000) %>% summarize(meanSal = mean(Salary,na.rm=T)))$meanSal
  meanDSsal <- (DSsubframe %>% filter(Salary > 25000) %>% summarize(meanSal = mean(Salary,na.rm=T)))$meanSal
  salTest <- t.test(x= (subDF %>% filter(Salary > 25000))$Salary, y= (DSsubframe %>% filter(Salary>25000))$Salary)
  #print(salTest)
  
  output$meanSal <- renderInfoBox(infoBox("Mean Salary of Respondents", meanSal, icon=icon("dollar-sign"), fill=F))
  output$dsMeanSal <- renderInfoBox(infoBox("Mean Salary of Data Scientist", meanDSsal, icon=icon("dollar-sign"), fill=F))
  output$salpval <- renderInfoBox(infoBox("p-value of t-test", salTest$p.value, icon=icon("calculator"), fill=F))
  
  output$salaryDensity <- renderPlot( ggplot() + geom_density(data = subDF %>% filter(Salary>25000), aes(x= as.numeric(Salary)), fill="red", alpha=0.7) + 
                                        geom_density(data = DSsubframe %>% filter(Salary>25000),aes(x=as.numeric(Salary)), fill="blue",alpha=0.5) + xlim(0,3E5)+
                                        ggtitle("Salary Density for Whole Subsample and Data Scientists") + xlab("Salary") + ylab("")
                                        )

  
  
  
  
  
  
  
  
  

  
})
