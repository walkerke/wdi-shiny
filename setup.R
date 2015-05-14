library(maptools)

countries <- readShapePoly("ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp")

quantile_labels <- function(vec, n) {
  qs <- round(quantile(vec, seq(0, 1, 1/n), na.rm = TRUE), 1)
  len <- length(qs) - 1
  qlabs <- c()
  for (i in 1:len) {
    j <- i + 1
    v <- paste0(as.character(qs[i]), "-", as.character(qs[j]))
    qlabs <- c(qlabs, v)
  }
  final_labs <- c(qlabs, "Data unavailable")
  final_labs
}
