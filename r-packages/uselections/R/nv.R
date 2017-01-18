#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadNevada <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('32')

  df <- read_csv("data-raw/nv/nv.csv", col_types='cnnnnnnn') %>%
    rename(CountyName=County, R=Republican, D=Democrat, L=Libertarian, N=Nonpartisan, O=Other) %>%
    mutate(G=NA, O=O+`Independent American`) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    filter(!(CountyName == 'Statewide')) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
