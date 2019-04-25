library(shiny)
library(shinydashboard)
library(RSQLite)
library(ggplot2)
suppressPackageStartupMessages(library(googleVis))
library(purrr)
library(dplyr)
library(stringr)


shinyServer(function(input, output, session) {
  conn <- dbConnect(drv = SQLite(), dbname = "./SOdevSurvey.db")
  session$onSessionEnded(function(){dbDisconnect(conn)})
  
  
  mainDF <- dbReadTable(conn,"master")
  dsIds <- dbGetQuery(conn,
                      'SELECT distinct(id) FROM devtypes
	                     WHERE id IN (SELECT id FROM devtypes
                       WHERE DevType = "Data Scientist" or 
                       DevType = "Machine Learning Engineer" or 
                       DevType = "Data Analyst");')
  
  output$yearHist <- renderGvis( mainDF %>% group_by(year) %>% summarize(count = n()) %>% mutate(year = as.character(year)) %>% 
                                   gvisColumnChart("year","count", options = list(
                                     title = "Number of Respondents by Year", vAxis = "{minValue: 0, maxValue: 100000}",
                                     legend = "none",
                                     height = 500,
                                     #width = 500,
                                     chartArea = "{'width': '70%', 'height':'70%'}"
                                   )))
  
  output$catNA <- renderGvis( mainDF %>% select(-c(year)) %>% summarize_all(funs(sum(is.na(.)))) %>% 
                                gvisBarChart(options = list(title="Number of Missing Values by Category", 
                                                            bar.groupWidth = '200%',
                                                            legend = "none",
                                                            height=500,
                                                            chartArea = "{'width': '90%', 'height':'70%'}"
                                                            )))
  
  output$employmentChart <- renderGvis( mainDF %>% filter(!is.na(Employment)) %>% group_by(Employment) %>% summarize(count = n()) %>% arrange(count) %>% 
                                          gvisColumnChart("Employment","count",options= list(
                                            title = "Employment Type Frequencies of Respondents",
                                            width = 750,
                                            height = 500,
                                            hAxis = "{'slantedTextAngle':'80','title':'Employment Type'}",
                                            legend = "none"
                                          )))
  
  output$countryChart <- renderGvis( mainDF %>% group_by(Country) %>% summarize(count = n()) %>% arrange(desc(count)) %>% head(20) %>% 
                                      gvisColumnChart("Country","count",options = list(
                                        title = "Respondent Count by Top 20 Countries",
                                        width = 750,
                                        height = 750,
                                        chartArea = "{'height':'55%'}",
                                        hAxis = "{'slantedTextAngle':'70','title':'Country'}",
                                        legend="none"
                                      )))
                      
  
  subDF <- mainDF %>% filter(Employment=="full-time" & Country == "United States")
  
  PythonIds <- as.data.frame(dbGetQuery(conn,
                                        'SELECT distinct(id) FROM `languages`
                                        WHERE id IN (
                                        SELECT id from `languages` WHERE `Language` = "Python");'))
  RIds <- as.data.frame(dbGetQuery(conn,
                                   'SELECT distinct(id) FROM `languages`
                                   WHERE id IN (
                                   SELECT id from `languages` WHERE `Language` = "R");'))
  
  ScalaIds <- as.data.frame(dbGetQuery(conn,
                                       'SELECT distinct(id) FROM `languages`
                                        WHERE id IN (
                                        SELECT id from `languages` WHERE `Language` = "Scala");'))
  
  DSframe <- inner_join(mainDF,dsIds,by=c("id","id"))
  
  output$DScountries <- renderGvis( DSframe %>% group_by(Country) %>% summarize(count = n()) %>% arrange(desc(count)) %>% head(20) %>% 
                                      gvisColumnChart("Country","count",options = list(
                                        title = "Respondents in Data Science, Count by Top 20 Countries",
                                        width = 750,
                                        height = 750,
                                        chartArea = "{'height':'55%'}",
                                        hAxis = "{'slantedTextAngle':'70','title':'Country'}",
                                        legend="none"
                                      )))
  
  DSsubframe <- inner_join(subDF,dsIds,by=c("id","id"))
  
  isDSframe <- full_join(subDF,DSsubframe %>% mutate(isDS = TRUE), by=c("id","id")) %>% mutate(isDS = !is.na(isDS))
  
  isDSrate <- isDSframe %>% summarize(rDS = mean(isDS))
  
  output$DSrateBox <- renderInfoBox(infoBox("Percentage of Data Scientists", paste0(as.character(100*round(isDSrate$rDS,4),"%")), 
                                                                                          icon=icon("calculator"), fill=F))
  
  
  
  output$dsEduChart <-renderGvis(DSsubframe %>% mutate(Education = case_when( 
              is.na(Education) ~ "None",
              TRUE ~ Education
    ))%>%  group_by(Education) %>% summarize(count=n()) %>% arrange(desc(count)) %>% 
                                   gvisColumnChart("Education","count",options = list(
                                                    title = "Highest Degree Achieved by Data Scientists",
                                                    hAxis = "{'slantedTextAngle': '70', 'title': 'Degree'}",
                                                    legend = "none",
                                                    height = 750
                                   )))
    
  output$dsMajorChart <- renderGvis(DSsubframe %>% filter(!is.na(Undergrad)) %>% group_by(Undergrad) %>% summarize(count=n()) %>% arrange(desc(count)) %>% 
                                     gvisColumnChart("Undergrad","count",options=list(
                                       title = "Undergrad Major of Data Scientists",
                                       hAxis = "{'slantedTextAngle': '70', 'title': 'Major'}",
                                       legend="none",
                                       height = 750
                                     )))
  
  
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
  
  output$meanSal <- renderInfoBox(infoBox("Mean Salary of Respondents", round(meanSal,0), icon=icon("dollar-sign"), fill=F))
  output$dsMeanSal <- renderInfoBox(infoBox("Mean Salary of Data Scientist", round(meanDSsal,0), icon=icon("dollar-sign"), fill=F))
  output$salpval <- renderInfoBox(infoBox("p-value of t-test", round(salTest$p.value,5), icon=icon("calculator"), fill=F))
  
  output$salaryDensity <- renderPlot( ggplot() + geom_density(data = subDF %>% filter(Salary>25000), aes(x= as.numeric(Salary)), fill="red", alpha=0.7) + 
                                        geom_density(data = DSsubframe %>% filter(Salary>25000),aes(x=as.numeric(Salary)), fill="blue",alpha=0.5) + xlim(0,3E5)+
                                        ggtitle("Salary Density for Whole Subsample and Data Scientists") + xlab("Salary") + ylab("")
                                        )

  
  RDSframe <- inner_join(RIds,dsIds,by=c("id","id"))
  #print(head(RDSframe))
    
    
  pyDSframe <- inner_join(PythonIds,dsIds, by=c("id","id"))
  #print(head(RDSframe))
  
  RPyframe <- inner_join(pyDSframe,RDSframe,by=c("id","id"))
  
  Scalaframe <- inner_join(ScalaIds,dsIds,by=c("id","id"))
  
  Rcount <-    RDSframe  %>% summarize(count = n()) %>% mutate(Language ="R")
  pyCount <-   pyDSframe %>% summarize(count = n()) %>% mutate(Language="Python")
  bothCount <- RPyframe  %>% summarize(count = n()) %>% mutate(Language="R and Python")
  scalaCount <-Scalaframe %>% summarize(count=n()) %>% mutate(Language="Scala")
  
  RPyAmm <- rbind(pyCount,Rcount,bothCount,scalaCount)
  
  
  output$langBar <- renderGvis( RPyAmm %>% gvisColumnChart("Language","count",options=list(
                                                            legend="none",
                                                            title = "Frequency of Language Use Among Data Scientists",
                                                            hAxis = "{'title': 'Language'}",
                                                            height= 400,
                                                            chartArea = "{'height':'70%'}"
                                                          )))
  
  tensorflowIDs <-as.data.frame(dbGetQuery(conn,
                                           'SELECT distinct(id) FROM frameworks
                                            WHERE id IN (
                                            SELECT id from frameworks WHERE Framework = "TensorFlow");'))
    
  torchIDs <-as.data.frame(dbGetQuery(conn,
                                      'SELECT distinct(id) FROM frameworks
                                        WHERE id IN (
                                        SELECT id from frameworks WHERE Framework = "Pytorch");'))
  
  tfFrame <- inner_join(tensorflowIDs,dsIds, by=c("id","id"))
  torchFrame <- inner_join(torchIDs,dsIds, by=c("id","id"))
  
  tfCount    <- tfFrame    %>% summarize(count = n()) %>% mutate(Framework = "TensorFlow")
  torchCount <- torchFrame %>% summarize(count = n()) %>% mutate(Framework = "Pytorch")
  bothCount  <- inner_join(tfFrame,torchFrame,by=c("id","id")) %>% 
                summarize(count = n()) %>% mutate(Framework = "TensorFlow and Pytorch")
  
  mlfwAmm <- rbind(tfCount,torchCount,bothCount)
  
  output$mlBar <- renderGvis( mlfwAmm %>% gvisColumnChart("Framework","count",options=list(
                                                           legend="none",
                                                           title = "Frequency of Machine Learning Framework Among Data Scientists",
                                                           hAxis = "{'title': 'Framework'}",
                                                           height = 400,
                                                           chartArea = "{'height': '70%'}"
  )))
  

  
})
