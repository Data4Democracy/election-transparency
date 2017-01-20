#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @import dplyr
#' @importFrom tibble as_tibble
#' @export
loadNorthCarolina <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('37') %>%
    mutate(CountyName=toupper(CountyName))

  page <- read_html("http://vt.ncsbe.gov/voter_stats/results.aspx?date=12-31-2016")
  tables <- page %>% html_nodes("table") %>% html_table(fill=TRUE)

  df <- tables[[2]] %>%
    select(CountyName=County, D=Democrats, R=Republicans, L=Libertarians, N=Unaffiliated) %>%
    mutate(G=NA, O=NA, CountyName=trimws(CountyName)) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement="")), -CountyName) %>%
    mutate_each("as.integer", -CountyName) %>%
    filter(CountyName != 'Totals') %>%
    as_tibble() %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
