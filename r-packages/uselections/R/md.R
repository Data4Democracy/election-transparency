#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadMaryland <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('24') %>%
    mutate(CountyName=toupper(CountyName)) %>%
    mutate(CountyName=ifelse(County=='24510', 'BALTIMORE CITY', CountyName)) %>%
    mutate(CountyName=ifelse(County=='24005', 'BALTIMORE CO.', CountyName)) %>%
    mutate(CountyName=ifelse(County=='24033', "PR. GEORGE'S", CountyName))

  df <- read_csv("data-raw/md/2016_11.csv", col_names=paste0('X', seq(12)), col_types='cciicinnccnc') %>%
    mutate(CountyName=X1, D=X7, R=X8,
           G=gsub(x=X9, pattern="([0-9,]+) ([0-9,]+) ([0-9,]+) ([0-9,]+)", replacement="\\1"),
           L=gsub(x=X9, pattern="([0-9,]+) ([0-9,]+) ([0-9,]+) ([0-9,]+)", replacement="\\2"),
           N=gsub(x=X9, pattern="([0-9,]+) ([0-9,]+) ([0-9,]+) ([0-9,]+)", replacement="\\3"),
           O=gsub(x=X9, pattern="([0-9,]+) ([0-9,]+) ([0-9,]+) ([0-9,]+)", replacement="\\4")) %>%
    select(CountyName, D, R, G, L, N, O) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
