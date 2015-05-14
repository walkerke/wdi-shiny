library(shiny)
library(leaflet)
library(WDI)

source('setup.R')


shinyServer(function(input, output) {
  
  
  output$wdi_map <- renderLeaflet({
    
    ind <- input$indicator
    
    dat <- WDI(country = "all",
               indicator = ind,
               start = input$year,
               end = input$year)
    
    
    dat[[ind]] <- round(dat[[ind]], 1)
    
    
    
    countries2 <- sp::merge(countries,
                            dat,
                            by.x = "iso_a2",
                            by.y = "iso2c",
                            sort = FALSE)
    
    classes <- 6
    
    indicator_alias <- "Value"
    
    pal <- colorQuantile(input$colors, NULL, n = classes)
    
    labs <- quantile_labels(countries2[[ind]], classes)
    
    country_popup <- paste0("<strong>Country: </strong>",
                            countries2$country,
                            "<br><strong>",
                            indicator_alias,
                            ", ",
                            as.character(input$year),
                            ": </strong>",
                            countries2[[ind]])
    
    stamen_tiles <- "http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png"
    
    stamen_attribution <- 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, under <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a href="http://openstreetmap.org">OpenStreetMap</a>, under <a href="http://www.openstreetmap.org/copyright">ODbL</a>.'
    
    leaflet(data = countries2) %>%
      addTiles(urlTemplate = stamen_tiles,
               attribution = stamen_attribution) %>%
      setView(0, 0, zoom = 2) %>%
      addPolygons(fillColor = ~pal(countries2[[ind]]),
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