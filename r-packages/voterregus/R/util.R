#' @importFrom rgdal readOGR
#' @import dplyr
getCountyNameFIPSMapping <- function(StateFIPSCode) {
  county_shp <- readOGR("data-raw/tl_2014_us_county/", "tl_2014_us_county") %>% subset(.$STATEFP == StateFIPSCode)
  county_shp@data %>% select(CountyName=NAME, County=GEOID) %>% mutate_each("as.character")
}
