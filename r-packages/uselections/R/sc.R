#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @import dplyr
#' @import tidyr
#' @importFrom tibble as_tibble
#' @export
loadSouthCarolina <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('45') %>%
    mutate(CountyName=toupper(CountyName))

  page <- read_html("http://www.state.sc.us/cgi-bin/scsec/96vr?countykey=ALL&D1=ALL")
  tables <- page %>% html_nodes("table") %>% html_table(fill=TRUE)

  df <- tables[[1]][2:47,] %>%
    select(CountyName=X1, N=X3) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
