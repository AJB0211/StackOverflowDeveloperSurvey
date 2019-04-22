library(shiny)
library(shinydashboard)
library(googleVis)
suppressMessages(suppressWarnings(library(tidyverse)))


shinyServer(function(input, output, session) {
  conn <- dbConnect(drv = SQLite(), dbname = "./SOdevSurvey.db")
   
  output$distPlot <- renderPlot({
    
    
  })
  
})
