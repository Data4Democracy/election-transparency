#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadMichigan <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('26') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read.xlsx("data-raw/mi/2016_RegVoterCount_511666_7.xlsx", sheet=1, startRow=3, colNames=FALSE, cols=c(2,12)) %>%
    mutate(CountyName=X1, N=X2) %>%
    filter(!is.na(CountyName)) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='ST CLAIR', 'ST. CLAIR', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName=='ST JOSEPH', 'ST. JOSEPH', CountyName)) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
