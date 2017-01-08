#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadNevada <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('32')

  df <- read_csv("data-raw/nv/nv.csv") %>%
    rename(CountyName=County, R=Republican, D=Democrat, L=Libertarian, N=Nonpartisan, O=Other) %>%
    mutate(G=NA, O=O+`Independent American`) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    filter(!(CountyName == 'Statewide')) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName)

  df

}
