#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadMississippi <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('28')

  df <- read.xlsx("data-raw/ms/MS voter count statewide.xlsx", sheet=1, cols=c(1, 4), rows=5:86, colNames=FALSE) %>%
    mutate(CountyName=trimws(gsub(x=X1, pattern='.+\\- ([A-Za-z ]+)', replacement='\\1')), N=X2) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='Jeff Davis', 'Jefferson Davis', CountyName)) %>%
    left_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
