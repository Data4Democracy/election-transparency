#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadOhio <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('39')

  df <- read.xlsx("data-raw/oh/turnoutbycounty.xlsx", sheet=1, rows=c(4:91), colNames=FALSE, cols=c(1,4)) %>%
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
