#' @importFrom readr read_csv
#' @import dplyr
#' @importFrom tibble as_tibble
#' @export
loadArkansas <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('05')

  df <- read_csv("data-raw/ar/ARRegisteredVoters6-1-16.csv", col_names=paste0('X', 1:2), col_types=paste0(rep('c', 2), collapse="")) %>%
    mutate(CountyName=X1, N=gsub(x=X2, pattern=",", replacement="")) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
