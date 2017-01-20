#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadMinnesota <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('27')

  df <- read.xlsx("data-raw/mn/mn-voter-registration-by-county-since-2000.xlsx", sheet=1, startRow=3, colNames=FALSE, cols=c(1,46)) %>%
    mutate(CountyName=X1, N=X2) %>%
    filter(!is.na(CountyName)) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='Saint Louis', 'St. Louis', CountyName)) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
