#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source('mesowest_api.R')
options(shiny.maxRequestSize=30*1024^2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  source('mesowest_api.R')

    observeEvent(
      input$clicks,
      {
  path <- paste("/v2/stations/timeseries?stid=",input$station,"&token=7bae27b7657c4d47812e9fb4760aff56&start=",input$start,"&end=",input$end,"",sep="")
  call <- mesowest_api(path)
  dat <- call$content
  dat <- dat$STATION
  dat <- dat$OBSERVATIONS
  df <- data.frame(matrix(unlist(dat), ncol = ncol(dat)),stringsAsFactors=FALSE)
  names(df) <- names(dat)
  df$date_time <- gsub(c("T"), " ", df$date_time)
  df$date_time <- gsub(c("Z"), " ", df$date_time)

    
    output$down <- downloadHandler(
      filename = function() { 
        paste(input$station, '.csv', sep='') 
      },
      
      content = function() {
        write.csv(df)
      }
    )
    output$table <- renderTable(head(df))
      })
})