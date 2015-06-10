library(shiny)
library(leaflet)
library(WDI)

source('setup.R')


shinyServer(function(input, output, session) {
  
  # Build reactive expression that takes values from the input to fetch the data
  
  countries2 <- reactive({
    
    merge_to_wdi(input$indicator, input$year)
    
  })
  
  # Attempt to draw the map 
  
  output$wdi_map <- renderLeaflet({
    
    stamen_tiles <- "http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png"
    
    stamen_attribution <- 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, under <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a href="http://openstreetmap.org">OpenStreetMap</a>, under <a href="http://www.openstreetmap.org/copyright">ODbL</a>.'
    

    map <- leaflet() %>%
      addTiles(urlTemplate = stamen_tiles,
               attribution = stamen_attribution) %>%
      setView(0, 0, 2)
    
    
    map

      
      
    
    
  })
  
  observe({
    
    classes <- 6
    
    indicator_alias <- "Value"
    
    pal <- colorQuantile(input$colors, NULL, n = classes)
    
    labs <- quantile_labels(countries2()[[input$indicator]], classes)
    
    country_popup <- paste0("<strong>Country: </strong>",
                            countries2()$country,
                            "<br><strong>",
                            indicator_alias,
                            ", ",
                            as.character(input$year),
                            ": </strong>",
                            countries2()[[input$indicator]])
    
      
    map <- leafletProxy("wdi_map", session) %>%
      clearShapes() %>%
      clearControls() %>%
      addPolygons(data = countries2(), 
                fillColor = ~pal(countries2()[[input$indicator]]),
                fillOpacity = 0.8,
                color = "#BDBDC3",
                weight = 1,
                popup = country_popup) %>%
      addLegend(colors = c(RColorBrewer::brewer.pal(classes, input$colors), "#808080"),
                position = "bottomright",
                bins = classes,
                labels = labs)
    
    
  })
  

  
}
  
  
  
  )