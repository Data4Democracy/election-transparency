#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadNewMexico <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('35')

  encodedNames <- countyNameFIPSMapping$CountyName
  encodedNames[11] <- 'DONA ANA'
  countyNameFIPSMapping$CountyName <- encodedNames

  countyNameFIPSMapping <- mutate(countyNameFIPSMapping, CountyName=toupper(CountyName))

  df <- read_csv("data-raw/nm/STATEWIDE_DEC_30_2016.csv") %>%
    rename(CountyName=Jurisdiction, R=REP, D=DEM, N=DTS, O=OTH) %>%
    mutate(L=NA, G=NA) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 12) # Hardcode until we add historical data

  df

}
