#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadWashington <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('53')

  df <- read.xlsx("data-raw/wa/VoterParticipation.xlsx", sheet='Turnout') %>%
    mutate(CountyName=trimws(CountyName), N=NumberOfRegisteredVoters) %>%
    filter(CountyName != 'Total') %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
