#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadKentucky <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('21') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/ky/voterstatscounty-20170118-120709.csv", col_names=FALSE, col_types='ciiiiiiiiiiiii') %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    mutate(CountyName=gsub(x=X1, pattern="[0-9]+[ ]+([A-Z]+)", replacement="\\1"),
           D=X3, R=X4, L=X7, G=X8, O=X5+X9+X10+X11, N=X6) %>%
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
