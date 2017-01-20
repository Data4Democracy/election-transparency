#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadNorthDakota <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('38')

  df <- read.xlsx("data-raw/nd/Results.xlsx", sheet=1, rows=c(10:62), colNames=FALSE, cols=c(1,2)) %>%
    mutate(CountyName=trimws(X1), N=X2) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
