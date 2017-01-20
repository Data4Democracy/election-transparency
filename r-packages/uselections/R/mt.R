#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadMontana <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('30')

  df <- read.xlsx("data-raw/mt/Registered_Voters_By_County.xlsx", sheet=1, rows=c(5:60), colNames=FALSE, cols=c(1,2)) %>%
    mutate(CountyName=X1, N=X2) %>%
    filter(!is.na(CountyName) & CountyName != 'Total') %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='Lewis & Clark', 'Lewis and Clark', CountyName)) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
