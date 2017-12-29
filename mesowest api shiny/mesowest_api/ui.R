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
      textInput(inputId = "station",
                   label = "Staton ID",
                   value = "C5988"),
      actionButton(inputId = "clicks",
                   label = "Click to get data"),
      downloadButton('down', 'Download data')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("table"),
       plotOutput("distPlot")
    )
  )
))
