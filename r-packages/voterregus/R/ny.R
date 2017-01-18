#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadNewYork <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('36')

  df <- read_csv("data-raw/ny/county_nov16.csv") %>%
    filter(STATUS == 'Total') %>%
    mutate(COUNTY=ifelse(is.na(COUNTY), trimws(gsub(x=REGION, pattern='Within NYC|Outside NYC (.+)', replacement='\\1')), COUNTY)) %>%
    filter(COUNTY != 'Grand Tot') %>%
    rename(CountyName=COUNTY, R=REP, D=DEM, G=GRE) %>%
    mutate(L=NA, O=OTH+REF+WEP+CON+WOR, N=BLANK+IND, CountyName=ifelse(CountyName=='St.Lawrence', 'St. Lawrence', CountyName)) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    filter(!(CountyName == 'Statewide')) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
