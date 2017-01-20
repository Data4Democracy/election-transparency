#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadAlabama <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('01') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read.xlsx("data-raw/al/ALVR-2016.xlsx", sheet=1, startRow=4, colNames=FALSE, cols=1:2) %>%
    mutate(CountyName=X1, N=X2) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='ST_CLAIR', 'ST. CLAIR', CountyName)) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
