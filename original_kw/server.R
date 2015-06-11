library(shiny)
library(kwgeo)
library(leaflet)
library(WDI)

# source('setup.R')

shinyServer(function(input, output) {
  
  output$wdi_map <- renderLeaflet({
    
    wdi_leaflet(indicator = input$indicator, classes = 6, colors = input$colors, year = input$year)
    
  })
  
  
}
  
  
  
  )