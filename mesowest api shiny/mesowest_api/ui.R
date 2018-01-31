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

  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "start",
                 label = "start date, format = YYYYMMDDHHMM",
                 value = "201711290000"),
      textInput(inputId = "end",
                label = "end date, format = YYYYMMDDHHMM",
                value = "201711291200"),
      textInput(inputId = "address",
                label = "City, State",
                value = "Oakland, California"),
      textInput(inputId = "radius",
                label = "radius in miles for station search",
                value = 50),
      actionButton(inputId = "stationdata",
                label = "Click to get stations nearby"),
      textInput(inputId = "station",
                label = "STID (input from table or known station id)",
                value = "C5988"),
   
      
      actionButton(inputId = "clicks",
                   label = "Click to get data"),
      selectInput('ycol', 'Y Variable', "", selected = ""),
      selectInput('xcol', 'X Variable', "", selected = ""),
      numericInput(inputId = "date_breaks",
                   label = "Date breaks for plot",
                   value = 250),
      actionButton(inputId = "plot",
                   label = "Click to plot"),
      downloadLink('down', 'Download')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("table"),
      tableOutput("table2"),
       plotlyOutput("tempts")
    )
  )
))
