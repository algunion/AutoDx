#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(DataExplorer)
library(dlookr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  
  workingData <- reactive({
    req(input$selectedFile)
    
    tryCatch(
      {
        df <- readr::read_csv(input$selectedFile$datapath, col_names = input$header)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    df
  })
   
  output$exploreTable <- DT::renderDataTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$selectedFile)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    
    
    DT::datatable(workingData(), options = list(
      lengthMenu = list(c(10, 20,-1), c('10', '20', 'All')),
      pageLength = 20
    ))
    
  })
  
  
  output$eda <- renderTable({
    describe(workingData())
  })
  
  output$edanorm <- renderPlot({
    plot_correlate(workingData())
  })
  
})
