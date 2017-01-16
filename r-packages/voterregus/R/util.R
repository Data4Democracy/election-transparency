#' @importFrom rgdal readOGR
#' @import dplyr
getCountyNameFIPSMapping <- function(StateFIPSCode) {

  if (!exists("countyData", env=packageEnv)) {
    assign("countyData", readOGR("data-raw/tl_2016_us_county/", "tl_2016_us_county")@data, env=packageEnv)
  }

  get("countyData", env=packageEnv) %>%
    filter(STATEFP==StateFIPSCode) %>%
    select(CountyName=NAME, County=GEOID) %>% mutate_each("as.character")

}

packageEnv <- new.env()
