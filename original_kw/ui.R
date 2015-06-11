library(shiny)
library(leaflet)
library(RColorBrewer)
library(dplyr)

brewer_df <- brewer.pal.info

brewer_df$colors <- row.names(brewer_df)

sub <- filter(brewer_df, category == "div" | category == "seq")

color_picker <- sub$colors

shinyUI(
  fluidPage(
    tags$head(includeCSS("styles.css")),
    fixedPanel(
      id = "fullscreen", 
      top = 0, left = 0, width = "100%", height = "100%", 
      leafletOutput("wdi_map", width = "100%", height = "100%")
    ), 
    fixedPanel(id = "controls", 
               top = 10, left = 10, width = 350, height = "auto", draggable = TRUE, 
               h3("World Bank map explorer"), 
               textInput("indicator", label = "World Bank indicator code", 
                         value = "SP.DYN.TFRT.IN"), 
               sliderInput("year", label = "Year", value = 2012, sep = "", 
                           min = 1980, max = 2013, step = 1, width = "100%"), 
               selectInput("colors", label = "ColorBrewer palette", 
                           choices = color_picker, 
                           selected = "Blues")
               )
  )
)