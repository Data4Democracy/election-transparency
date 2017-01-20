#' @importFrom readr read_csv
#' @import dplyr
#' @importFrom tibble as_tibble
#' @export
loadSouthDakota <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('46')

  df <- read_csv("data-raw/sd/StatewideVotersByCountybyParty_11.8.2016.csv", col_types='cnnnininn') %>%
    rename(CountyName=County, R=Republican, D=Democratic, L=Libertarian, N=`NPA/IND`) %>%
    mutate(G=NA, O=OTH+Constitution) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, R, D, G, L, N, O, Year, Month) %>%
    filter(CountyName != 'Total') %>%
    mutate_each("as.integer", -CountyName) %>%
    group_by(CountyName) %>%
    summarize_each(funs(sum(., na.rm=TRUE))) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
