#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadWyoming <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('56') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/wy/16GeneralVR_stats.csv") %>%
    rename(CountyName=County, R=Republican, D=Democratic, L=Libertarian, N=Unaffiliated) %>%
    mutate(G=NA, O=`Other*`+Constitution) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    filter(CountyName != 'TOTAL') %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
