#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadIdaho <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('16')

  df <- read_csv("data-raw/id/2016_November_Party_Affiliation_Totals_by_County.csv", col_types=paste0(rep('c', 7), collapse="")) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer", -County) %>%
    mutate(D=Democratic, R=Republican, N=Unaffiliated, O=Constitution, G=as.integer(NA), L=Libertarian) %>%
    select(CountyName=County, D, R, N, O, G, L, Year, Month) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
