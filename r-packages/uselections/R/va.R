#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadVirginia <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('51') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/va/Registrant_Count_By_Locality.csv", col_names=c('X1','X2'), skip=1, col_types='c____n__________________') %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    mutate(CountyName=trimws(gsub(x=X1, pattern="Locality: [0-9]+ ([ A-Z&]+) COUNTY", replacement="\\1"))) %>%
    mutate(CountyName=ifelse(CountyName %in% c('FAIRFAX','FRANKLIN','ROANOKE','RICHMOND'),paste0(CountyName,' COUNTY'),CountyName)) %>%
    mutate(CountyName=trimws(gsub(x=CountyName, pattern="Locality: [0-9]+ ([ A-Z&]+) CITY", replacement="\\1"))) %>%
    mutate(CountyName=ifelse(CountyName=='KING & QUEEN', 'KING AND QUEEN', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName %in% c('FAIRFAX','FRANKLIN','ROANOKE','RICHMOND'),paste0(CountyName,' CITY'),CountyName)) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA, N=X2) %>%
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    group_by(CountyName, Year, Month) %>%
    summarize_each("sum") %>%
    ungroup() %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
