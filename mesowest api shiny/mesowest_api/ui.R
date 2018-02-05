#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
library(shiny)
library(ggplot2)
library(plotly)
library(RColorBrewer)
library(dplyr)
library(shinythemes)

pdf(NULL)

ui <- shinyUI(fluidPage(
  theme = shinytheme("sandstone"),
  titlePanel("mesowest API"),
  tabsetPanel(
    tabPanel("Station Select",
             titlePanel("Station Select"),
             sidebarLayout(
               sidebarPanel(
             textInput(inputId = "address",
                       label = "City, State",
                       value = "Oakland, California"),
             textInput(inputId = "radius",
                       label = "radius in miles for station search",
                       value = 50),
             actionButton(inputId = "stationdata",
                          label = "Click to get stations nearby"),
             leafletOutput("MapPlot1")
               ),
             mainPanel(
             tableOutput("table")
             
             )
             )),
            
  # Sidebar for specifying 
  
    tabPanel("Data download",
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "start",
                 label = "start date, format = YYYYMMDDHHMM",
                 value = "201711290000"),
      textInput(inputId = "end",
                label = "end date, format = YYYYMMDDHHMM",
                value = "201711291200"),
      
      textInput(inputId = "station",
                label = "STID (input from table or known station id)",
                value = "C5988"),
   
      
      actionButton(inputId = "clicks",
                   label = "Click to get data"),
      downloadLink('down', 'Download')
    ),
    mainPanel(
      tableOutput("table2")
    )
    )),
     # Show a plot of the generated distribution
  
    tabPanel("plot it",
             sidebarLayout(
               sidebarPanel(
                 selectInput('xcol', 'X Variable', "", selected = ""),
                 selectInput('ycol', 'Y Variable', "", selected = ""),
                 numericInput(inputId = "date_breaks",
                          label = "Date breaks for plot",
                          value = 250),
                actionButton(inputId = "plot",
                          label = "Click to plot")
               ),
             mainPanel(    
      plotlyOutput("tempts")
             )))
    )
)
)
