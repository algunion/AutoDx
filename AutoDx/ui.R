#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Auto DX"),
  theme = shinytheme("simplex"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      width = 2,
      fileInput("selectedFile", "Select CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      tags$hr(),
      
      # Input: Checkbox if file has header ----
      checkboxInput("header", "Header", TRUE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Show", DT::dataTableOutput("exploreTable")),
                  tabPanel("Exploratory Analysis", 
                           h1("Exploratory analysis of dataset"),
                           DT::dataTableOutput("eda"),
                           hr(),
                           h2("Normality inspection of numerical variables"),
                           fluidRow(
                             uiOutput("selectedNumericalUI"),
                             plotOutput("edanorm")),
                           hr(),
                           h2("Categorical variables exploration"),
                           fluidRow(
                             uiOutput("selectedACategUI"),
                             uiOutput("selectedBCategUI")
                           ),
                           plotOutput("categExploration")),
                  tabPanel("Model creation", tableOutput("table")))
    )
  )
))
