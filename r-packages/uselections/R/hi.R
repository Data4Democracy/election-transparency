#' @importFrom readr read_csv
#' @import dplyr
#' @import tidyr
#' @importFrom tibble as_tibble
#' @export
loadHawaii <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('15')

  df <- read_csv("data-raw/hi/Election-Registration-and-Turnout-Statistics.csv", col_names=paste0('X', 1:13), col_types=paste0(rep('c', 13), collapse="")) %>%
    select(X1, X2, X5, X8, X11) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer") %>%
    gather(CountyName, N, -X1) %>%
    mutate(CountyName=recode(CountyName, X2="Hawaii", X5="Maui", X8="Kauai", X11="Honolulu")) %>%
    rename(Year=X1) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Month = 11) %>%
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
