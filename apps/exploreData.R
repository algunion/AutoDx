#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)

exploreData <- function(dataset) {
  # Define UI for application that draws a histogram
  
  ui <- fluidPage(
    # Application title
    titlePanel("Analiza Exploratorie a datelor"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          'sampleSize',
          'Sample Size',
          min = 1,
          max = nrow(dataset),
          value = min(1000, nrow(dataset)),
          step = 500,
          round = 0
        ),
        
        checkboxInput('jitter', 'Jitter', value = TRUE),
        checkboxInput('smooth', 'Smooth', value = TRUE),
        
        selectInput('x', 'X', names(dataset)),
        selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
        selectInput('color', 'Color', c('None', names(dataset))),
        
        selectInput('facet_row', 'Facet Row',
                    c(None = '.', names(dataset[sapply(dataset, is.factor)]))),
        selectInput('facet_col', 'Facet Column',
                    c(None = '.', names(dataset[sapply(dataset, is.factor)])))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(plotOutput("exploratoryPlot"))
    )
  )
  
  # Define server logic required to draw a histogram
  server <- function(input, output) {
    
    output$exploratoryPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      filtered <- dataset[sample(nrow(dataset), input$sampleSize), ]
      
      
      p <-
        ggplot(filtered, aes_string(x = input$x, y = input$y)) + geom_point()
      
      if (input$color != 'None')
        p <- p + aes_string(color = input$color)
      
      facets <- paste(input$facet_row, '~', input$facet_col)
      if (facets != '. ~ .')
        p <- p + facet_grid(facets)
      
      if (input$jitter)
        p <- p + geom_jitter()
      if (input$smooth)
        p <- p + geom_smooth()
      
      print(p)
    })
  }
  
  # Run the application
  print("Returning shiny app")
  shinyApp(ui = ui, server = server, options = list(height = 500, width = "100%"))
}

#exploreData(read_csv(file.choose()))
