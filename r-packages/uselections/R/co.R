#' @importFrom openxlsx read.xlsx
#' @import dplyr
#' @export
loadColorado <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('08')

  df <- read.xlsx("data-raw/co/statistics.xlsx", sheet=2, startRow=4, colNames=FALSE) %>%
    mutate_each(funs(replace(., is.na(.), 0)), -X1) %>%
    mutate(CountyName=X1, D=X3+X11+X19, G=X4+X12+X20, L=X5+X13+X21, R=X6+X14+X22, N=X7+X15+X23, O=X2+X8+X10+X16+X18+X24) %>%
    select(CountyName, D, G, L, R, N, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    ungroup() %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
