#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadVermont <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('50') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/vt/2016gevoterturnout.csv", col_types='cc', col_names=FALSE) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA, CountyName=X1, N=X2) %>%
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
