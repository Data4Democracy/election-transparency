#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadIndiana <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('18')

  df <- read_csv("data-raw/in/2016_General_Election_Turnout.csv", col_names=paste0('X', 1:2), col_types=paste0(rep('c', 2), collapse="")) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA, CountyName=X1, N=X2) %>%
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='La Porte', 'LaPorte', CountyName)) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
