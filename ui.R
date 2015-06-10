library(shiny)
library(leaflet)
library(RColorBrewer)
library(dplyr)
library(dygraphs)

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
      leafletOutput("wdimap", width = "100%", height = "100%")
    ), 
    absolutePanel(id = "controls", draggable = FALSE, 
               top = 10, right = 10, width = 500, height = "auto", 
               h3("World Bank map explorer"),
    tabsetPanel(
      tabPanel("Controls", 
               textInput("indicator", label = "World Bank indicator code", 
                         value = "SP.DYN.TFRT.IN"), 
               numericInput("year", label = "Year", value = 2012, min = 1980, max = 2013), 
               selectInput("colors", label = "ColorBrewer palette", 
                           choices = color_picker, 
                           selected = "Blues")), 
               
      tabPanel("Chart", p("Click a country for an interactive chart"), 
               dygraphOutput("dchart", width = "100%")), 
      tabPanel("About", p("Descriptive text here"))
  ))
)
)