#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadWyoming <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('56') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/wy/16GeneralVR_stats.csv",
                 col_names=c('County' ,'Constitution' ,'Democratic' ,'Libertarian' ,'Republican' ,'Unaffiliated' ,'Other*' ,'Empty','TOTAL'),
                 skip=1, col_types='cinnnnicn') %>%
    rename(CountyName=County, R=Republican, D=Democratic, L=Libertarian, N=Unaffiliated) %>%
    mutate(G=NA, O=`Other*`+Constitution) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    filter(CountyName != 'TOTAL') %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
