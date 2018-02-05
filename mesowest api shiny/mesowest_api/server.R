#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(nominatim)
library(shiny)
library(leaflet)
source('mesowest_api.R')
options(shiny.maxRequestSize=30*1024^2)
options(warn =-1)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  source('mesowest_api.R')
  
  observeEvent(
    input$stationdata,
    {
  key <- "g6ZDA3kCC8DLFxjioLEtqv5l0CgdNzoW"
      
  stations <- osm_geocode(input$address, key = key)
  lats <- stations$lat
  longs <- stations$lon
  path1 <- paste("/v2/stations/metadata?network=1,2,3,4,5,6,7,8,9,10,11,12,13&radius=",lats,",",longs,",",input$radius,"&token=7bae27b7657c4d47812e9fb4760aff56")
  call <- mesowest_api(path1)
  out <- call$content$STATION
  out$start <- out$PERIOD_OF_RECORD$start
  out$end <- out$PERIOD_OF_RECORD$end
  out <- select(out, -PERIOD_OF_RECORD)
  out <- out[order(out$DISTANCE),]
  out$LONGITUDE <- as.numeric(out$LONGITUDE)
  out$LATITUDE <- as.numeric(out$LATITUDE)
  output$table <- renderTable(head(out,10))
  
  output$MapPlot1 <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>%
     
      setView(lng = max(out$LONGITUDE - .5), lat = min(out$LATITUDE + .5), zoom = 7)
    
  })
  
  leafIcons <- icons(
    iconUrl = ifelse(out$STATUS =="ACTIVE",
                     "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png",
                     "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png"
    ))
  
  observe({
  leafletProxy("MapPlot1") %>% 
         addTiles() %>% 
         addMarkers(lng = out$LONGITUDE,
                      lat = out$LATITUDE,
                      icon = leafIcons,
                      popup = as.character(paste("Station ID:", out$STID))
                        )
          })
    })
 
    observeEvent(
      input$clicks,
      {
  
      
    data <- reactive(
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
        df$date_time <- strftime(as.POSIXct(df$date_time, format ="%Y-%m-%d %H:%M:%S"))
        df$air_temp_set_1 <- as.numeric(df$air_temp_set_1)*(9/5)+32
        
    
          updateSelectInput(session, inputId = 'xcol', label = 'X Variable',
                    choices = names(df), selected =  names(df)[1])
  
          updateSelectInput(session, inputId = 'ycol', label = 'Y Variable',
                    choices = names(df), selected =  names(df)[2])
          return(df)
   
        })
    output$table2 <- renderTable(head(data()))
      
    

  observeEvent(
    input$plot,
    {
  output$tempts <- renderPlotly({
    
    x <- data()[,input$xcol]
    y <- data()[,input$ycol]
    
    fmt <- list(
      family = "Arial, sans-serif",
      size = 12
    )
    fmt2 <- list(
      family = "Arial, sans-serif",
      size = 9
    )
    
    xtit <- list(
      title = input$xcol,
      titlefont = fmt,
      tickangle = 45,
      tickfont = fmt2,
      dtick = input$date_breaks,
      showticklabels = TRUE
    )
    
    ytit <- list(
      title = input$ycol,
      titlefont = fmt,
      tickangle = 45,
      tickfont = fmt2
    )
    m <- list(
      b = 100,
      pad = 4
    )
    
    leg <- list(colorbar = list(title = input$ycol,
                                titlefont = fmt))
    
    plot_ly(x = x, y = y,type = "scatter", mode ="markers", marker = leg, color = ~y) %>%
      layout(xaxis = xtit, yaxis = ytit, margin = m) 
    
      }) 
    })
      })
       
    
    output$down <- downloadHandler(
      filename = function() { 
        paste('input$station', '.csv', sep='') 
      },
      
      content = function(filename) {
        write.csv(df, filename) 
      })
})