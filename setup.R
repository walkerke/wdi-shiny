library(maptools)
library(kwgeo)
library(WDI)
library(leaflet)
library(readxl)


# Set up the data

countries <- readShapePoly("ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp")

# Function to grab WDI data and merge to the spatial data frame

merge_to_wdi <- function(indicator, year) {
  
  dat <- WDI(country = "all",
             indicator = indicator,
             start = year,
             end = year)
  
  
  dat[[indicator]] <- round(dat[[indicator]], 1)
  
  
  
  countries2 <- geo_join(countries,
                          dat,
                          "iso_a2",
                          "iso2c")
  
  countries2
  
}


# Generate a lookup table

xl <- "WDI_April2013_CETS.xls"

lookup <- read_excel(xl)

names(lookup) <- c("a", "b", "c", "d", "e", "f")

lookup_list <- setNames(as.list(lookup$b), lookup$a)

lookup_list2 <- setNames(as.list(lookup$a), lookup$b)


