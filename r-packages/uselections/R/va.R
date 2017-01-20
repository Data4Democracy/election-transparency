#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadVirginia <- function() {

  countyNameFIPSMapping <- getCountyData() %>%
    filter(STATEFP=='51') %>%
    mutate(CountyName=toupper(NAMELSAD)) %>%
    select(County=GEOID, CountyName)

  df <- read_csv("data-raw/va/Registrant_Count_By_Locality.csv", col_names=c('X1','X2'), skip=1, col_types='c____n__________________') %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    mutate(CountyName=trimws(X1)) %>%
    mutate(CountyName=trimws(gsub(x=CountyName, pattern="Locality: [0-9]+ ([ A-Z&]+)", replacement="\\1"))) %>%
    mutate(CountyName=ifelse(CountyName=='KING & QUEEN COUNTY', 'KING AND QUEEN COUNTY', CountyName)) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA, N=X2) %>%
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    group_by(CountyName, Year, Month) %>%
    summarize_each("sum") %>%
    ungroup() %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
