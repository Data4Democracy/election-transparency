#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadMissouri <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('29') %>%
    filter(County != '29510')

  df <- read_csv("data-raw/mo/VoterTurnoutNov2016.csv", col_names=paste0('X', 1:2), col_types=paste0(rep('c', 2), collapse=""), skip=1) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA, CountyName=trimws(X1), N=X2) %>%
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='De Kalb', 'DeKalb', CountyName)) %>%
    left_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    mutate(County=ifelse(CountyName=='St. Louis City', '29510', County)) %>%
    mutate(County=ifelse(CountyName=='Kansas City', '29095', County)) %>%
    select(-CountyName) %>%
    group_by(County, Year, Month) %>%
    summarize_each("sum") %>%
    ungroup()

  df

}
