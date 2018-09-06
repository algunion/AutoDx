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
library(corrplot)





options(shiny.maxRequestSize=3000*1024^2) 
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  
  workingData <- reactive({
    req(input$selectedFile)
    
    tryCatch(
      {
        df <- readr::read_csv(input$selectedFile$datapath, col_names = input$header, guess_max = 10000)
        df <- data.frame(df, stringsAsFactors = TRUE)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    df
  })
  
  cols_info <- reactive({
    req(workingData())
    
    col_names <- colnames(workingData())
    col_types <- sapply(workingData(), class)
    print(col_types)
    col_numeric <- col_names[col_types %in% c("integer", "numeric")]
    col_categ <- col_names[col_types %in% c("character")]
    
    list(col_names = col_names, col_types = col_types, col_numeric = col_numeric, col_categ = col_categ)
  })
  
   
  output$exploreTable <- DT::renderDataTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$selectedFile)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    
    
    DT::datatable(workingData(), options = list(
      scrollX = TRUE,
      lengthMenu = list(c(10, 20,-1), c('10', '20', 'All')),
      pageLength = 20
    ))
    
  })
  
  
  output$eda <- DT::renderDataTable({
    DT::datatable(describe(workingData()), options = list(
      scrollX = TRUE,
      lengthMenu = list(c(10, 20,-1), c('10', '20', 'All')),
      pageLength = 20
    ))
    
    
  })
  
  output$selectedNumericalUI <- renderUI({
    selectInput("selectedNumerical", "Select numerical column", cols_info()$col_numeric, selected = NULL, multiple = FALSE,
                selectize = TRUE, width = NULL, size = NULL)
  })
  
  output$selectedACategUI <- renderUI({
    selectInput("selectedCategoricalA", "Select categorical column", cols_info()$col_categ, selected = NULL, multiple = FALSE,
                selectize = TRUE, width = NULL, size = NULL)
  })
  
  output$selectedBCategUI <- renderUI({
    selectInput("selectedCategoricalB", "Select target categorical", cols_info()$col_categ, selected = NULL, multiple = FALSE,
                selectize = TRUE, width = NULL, size = NULL)
  })
  
  
  
  output$edanorm <- renderPlot({
    plot_normality(workingData(), input$selectedNumerical)
  })
  
  output$categExploration <- renderPlot({
    # to do
  })
  
})
