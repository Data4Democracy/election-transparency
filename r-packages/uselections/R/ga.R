#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadGeorgia <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('13') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read.xlsx("data-raw/ga/Active_Voters_by_Race_and_Gender_as_of_November_1_2016.xlsx", sheet=1, startRow=10, colNames=FALSE, cols=c(2,17)) %>%
    mutate(CountyName=X1, N=X2) %>%
    filter(!is.na(CountyName)) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
