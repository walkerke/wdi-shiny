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
               h4("World Development Indicators explorer"),
    tabsetPanel(
      tabPanel("Controls", 
               textInput("indicator", label = "World Development Indicator code", 
                         value = "SP.DYN.TFRT.IN"), 
               numericInput("year", label = "Year", value = 2012, min = 1980, max = 2013), 
               selectInput("colors", label = "ColorBrewer palette", 
                           choices = color_picker, 
                           selected = "Blues")), 
               
      tabPanel("Chart", p("Click a country on the map for an interactive chart"), 
               dygraphOutput("dchart", width = "100%")), 
      tabPanel("About", 
              p("This application allows users to explore the", a("World Bank's World Development
              Indicators", href = "http://data.worldbank.org/"),  "with an interactive map and charts.  
              The application was built using the 
              Shiny framework for the R programming language by", 
              a("Kyle Walker, Texas Christian University. ",
                href = "http://personal.tcu.edu/kylewalker/")), 
              p('Enter any World Development Indicator code to query the World Bank API and return an interactive
                Leaflet map.  The map defaults to Total Fertility Rate in 2012. 
                Click any country to produce an interactive dygraphs time-series chart, available
                from the "Charts" tab (the charts work best in Firefox at the moment).' ), 
              p('Please note that indicators are not always available for all countries for all years.  Also: this
                map uses the Web Mercator projection, which is not ideal for thematic maps of the entire world.  
                Just remember: Africa is 14 times larger than Greenland!'), 
              p(a('The source code is available on GitHub. ', href = "https://github.com/walkerke/wdi-shiny"), 
                'Please let me know if you have any suggestions or feedback!'))
  ))
)
)