#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadNewJersey <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('34') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/nj/2017-01-voter-registration-by-county.csv", col_types='cccccccccccc') %>%
    rename(CountyName=County, R=REP, D=DEM, L=LIB, N=UNA, G=GRE) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement="")), -CountyName) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(O=CNV+NAT+RFP+SSP+CON) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
