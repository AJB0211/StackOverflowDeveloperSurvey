library(shiny)
library(shinydashboard)
library(RSQLite)
library(ggplot2)
suppressPackageStartupMessages(library(googleVis))
library(purrr)
library(dplyr)
library(stringr)
library(tidyr)



shinyServer(function(input, output, session) {
  conn <- dbConnect(drv = SQLite(), dbname = "./SOdevSurvey.db")
  session$onSessionEnded(function(){dbDisconnect(conn)})
  
  
  mainDF <- dbReadTable(conn,"master")
  
  dsTitle <- dbGetQuery(conn,
                        'SELECT distinct(id) FROM devtypes
	                     WHERE id IN (SELECT id FROM devtypes
                       WHERE DevType = "Data Scientist");')
  
  mleTitle <- dbGetQuery(conn,
                      'SELECT distinct(id) FROM devtypes
	                     WHERE id IN (SELECT id FROM devtypes
                       WHERE DevType = "Machine Learning Engineer");')
  
  daTitle <- dbGetQuery(conn,
                      'SELECT distinct(id) FROM devtypes
	                     WHERE id IN (SELECT id FROM devtypes
                       WHERE DevType = "Data Analyst");')
  
  
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
  
  
  
  
  
  output$employmentChart <- renderPlot( mainDF %>% filter(!is.na(Employment)) %>% group_by(Employment) %>% summarize(count = n()) %>% 
                                          ggplot(aes(x=reorder(Employment,-count),y=count)) + geom_col(fill="blue") + theme(legend.position = "none") + #coord_cartesian(ylim= c(0.3,0.7))+
                                          xlab("Employment Type") + ylab("Frequency") + ggtitle("Employment Type Frequencies of Respondents") + 
                                          theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                                axis.title = element_text(size=18),
                                                axis.text.x  = element_text(size=14,angle=70,hjust=1),
                                                axis.text.y  = element_text(size=14),
                                                plot.title = element_text(size=24)), height=500)
                                          
                                        
  
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
  
  
  output$DSrateBox <- renderInfoBox(infoBox("Percentage of Data Scientists", paste0(as.character(100*round(isDSrate$rDS,4)),"%"), 
                                                                                          icon=icon("calculator"), fill=F))
  
  eduFrame <- inner_join(DSsubframe %>% mutate(Education = case_when( is.na(Education) ~ "None", TRUE ~ Education), tot = n()) 
                              %>% group_by(Education) %>% summarize(rate = n()/first(tot)),censusFrame,by=c("Education","Education")) %>% 
                              rename(`Data Science` = rate.x, `US Census`=rate.y) %>% gather(key="Population",value="rate",`Data Science`,`US Census`)
    
  #print(eduFrame)
  
  
  output$dsEduRateChart <- renderPlot(eduFrame %>% filter(Education %in% c("Bachelor's","Master's","Doctoral")) %>% 
                            ggplot(aes(x=reorder(Education,-rate),y=rate)) + geom_col(aes(fill=`Population`),position="dodge") +
                                  #scale_color_manual(labels=c("US Census","Stack Overflow Data Scientists"),values=c("blue","red"))+ #coord_cartesian(ylim= c(0.3,0.7))+
                                  labs(x="Degree",y="Frequency",
                                       title="Highest Academic Degree by Data Scientists Compared to US Population",
                                       color = "Population") + 
                                  theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                     axis.title = element_text(size=18),
                                     axis.text.x  = element_text(size=14,angle=70,hjust=1),
                                     axis.text.y  = element_text(size=14),
                                     plot.title = element_text(size=24),
                                     legend.text = element_text(size=22),
                                     legend.title = element_text(size=24)
                                     ),height=500)

  
  
  output$dsEduChart <-renderPlot(DSsubframe %>% mutate(Education = case_when(
                                is.na(Education) ~ "None",
                                TRUE ~ Education
                                ))%>%  group_by(Education) %>% summarize(count=n()) %>% arrange(desc(count)) %>%
                                  ggplot(aes(x=reorder(Education,-count),y=count)) + geom_col(fill="blue") + 
                                  theme(legend.position = "none") + #coord_cartesian(ylim= c(0.3,0.7))+
                                  xlab("Education Level") + ylab("Frequency") + ggtitle("Highest Level of Education Experienced by Data Scientists") +
                                  theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                        axis.title = element_text(size=18),
                                        axis.text.x  = element_text(size=14,angle=70,hjust=1),
                                        axis.text.y  = element_text(size=14),
                                        plot.title = element_text(size=24)), height=500)
  

    
  output$dsMajorChart <- renderPlot(DSsubframe %>% filter(!is.na(Undergrad)) %>% group_by(Undergrad) %>% summarize(count=n()) %>% arrange(desc(count)) %>% 
                                      ggplot(aes(x=reorder(Undergrad,-count),y=count)) + geom_col(fill="blue") + theme(legend.position = "none") + #coord_cartesian(ylim= c(0.3,0.7))+
                                      xlab("Major") + ylab("Frequency") +
                                      ggtitle("Undergraduate Degree Major Among Data Scientists") + 
                                      theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                            axis.title = element_text(size=18),
                                            axis.text.x  = element_text(size=14,angle=70,hjust=1),
                                            axis.text.y  = element_text(size=14),
                                            plot.title = element_text(size=24)),height=500)
  
  
  DSbootRate <- DSsubframe %>% mutate(isBoot = !is.na(TimeAfterBootcamp)) %>% summarize(bootRate = mean(isBoot),bootCount = sum(isBoot))
  
  output$dsBootRateBox <- renderInfoBox(infoBox("Number of Bootcamp Attendees", DSbootRate$bootCount, icon=icon("calculator"), fill=F))
  
  output$dsBootcamp <- renderPlot( DSsubframe %>% filter(!is.na(TimeAfterBootcamp)) %>% mutate(tot = n()) %>% 
                                     group_by(TimeAfterBootcamp) %>% summarize(count = n(), tot=first(tot)) %>%  
                                     mutate(rate = count/tot) %>% arrange(desc(rate)) %>% 
                                     ggplot(aes(x=reorder(TimeAfterBootcamp,-count),y=count)) + geom_col(fill="blue") + 
                                     theme(legend.position = "none") + #coord_cartesian(ylim= c(0.3,0.7))+
                                     xlab("Time After Bootcamp") + ylab("Count") +
                                     ggtitle("Rate of Time Spent After Bootcamp in Job Search") + 
                                     theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                           axis.title = element_text(size=18),
                                           axis.text  = element_text(size=14),
                                           plot.title = element_text(size=24)))
                                     
                                     
                                     
                                     
                                  
  
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
                                        ggtitle("Salary Density for Whole Subsample and Data Scientists") + xlab("Salary") + ylab("") +
                                        theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                              axis.title = element_text(size=20),
                                              axis.text  = element_text(size=14),
                                              plot.title = element_text(size=30))
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
  
  
  SQLids <- as.data.frame(dbGetQuery(conn,
                                     'SELECT distinct(id) FROM `languages`
                                       WHERE id in (
                                       SELECT id from `languages` WHERE `Language` = "SQL");'))
  
  dsSQL <- DSsubframe %>% mutate(useSQL = id %in% SQLids$id)
  
  output$dsSQLbox <- renderInfoBox(infoBox("Rate of SQL usage", paste0(as.character(100 * round(mean(dsSQL$useSQL),2)),"%")))
  
  dsUseSQL  <- dsTitle %>% mutate(useSQL = id %in% SQLids$id) %>% summarize(rate = mean(useSQL)) %>% mutate(Title = "Data Scientist")
  mleUseSQL <- mleTitle %>% mutate(useSQL = id %in% SQLids$id) %>% summarize(rate = mean(useSQL)) %>% mutate(Title = "Machine Learning Engineer")
  daUseSQL  <- daTitle %>% mutate(useSQL = id %in% SQLids$id) %>% summarize(rate = mean(useSQL)) %>% mutate(Title = "Data Analyst")
  
  output$SQLbar <- renderPlot(rbind(dsUseSQL,mleUseSQL,daUseSQL) %>% arrange(desc(rate)) %>% ggplot(aes(x=Title,y=rate)) + 
                                geom_col(aes(fill=Title)) + theme(legend.position = "none") + coord_cartesian(ylim= c(0.3,0.7))+
                                xlab("Job Title") + ylab("Rate") + ggtitle("SQL Usage Rate Among Data Positions") + 
                                theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                      axis.title = element_text(size=20),
                                      axis.text  = element_text(size=14),
                                      plot.title = element_text(size=30))
                                )
    
    
  
  output$langBar <- renderPlot(RPyAmm %>% ggplot(aes(x=Language,y=count)) + 
                                 geom_col(aes(fill=Language)) + theme(legend.position = "none") + #coord_cartesian(ylim= c(0.3,0.7))+
                                 xlab("Language") + ylab("Count") + ggtitle("Frequency of Language Use Among Data Scientists") + 
                                 theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                       axis.title = element_text(size=20),
                                       axis.text  = element_text(size=14),
                                       plot.title = element_text(size=30))
                                 )
  
  
  
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
  
  output$mlBar <- renderPlot( mlfwAmm %>% 
                                ggplot(aes(x=reorder(Framework,-count),y=count)) + geom_col(aes(fill=Framework)) + theme(legend.position = "none") + #coord_cartesian(ylim= c(0.3,0.7))+
                                xlab("Framework") + ggtitle("Frequency of Machine Learning Framework Among Data Scientists") + 
                                theme(panel.background = element_rect(fill = "white", colour = "grey50"),
                                      axis.title = element_text(size=18),
                                      axis.text  = element_text(size=14),
                                      plot.title = element_text(size=24)))
                                

  
})
