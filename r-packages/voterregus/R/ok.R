#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadOklahoma <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('40') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/ok/ok.csv", col_names=FALSE) %>%
    rename(CountyName=X1, D=X2, R=X3, O=X4, N=X5) %>%
    mutate(L=NA, G=NA, CountyName=trimws(gsub(x=CountyName, pattern="[ ]?[0-9]+ ([A-Z]+)", replacement="\\1"))) %>%
    mutate(CountyName=ifelse(CountyName == 'LEFLORE', "LE FLORE", CountyName)) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
