#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadIowa <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('19')

  df <- read_csv("data-raw/ia/CoNov16.csv", col_names=paste0('X', 1:11), col_types=paste0(rep('c', 11), collapse="")) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer", -X1) %>%
    mutate(D=X2+X7, R=X3+X8, N=X4+X9, O=X5+X10, G=as.integer(NA), L=as.integer(NA)) %>%
    select(CountyName=X1, D, R, N, O, G, L) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
