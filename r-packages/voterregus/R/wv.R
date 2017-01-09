#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @import dplyr
#' @importFrom tibble as_tibble
#' @export
loadWestVirginia <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('54') %>%
    mutate(CountyName=toupper(CountyName))

  page <- read_html("http://www.sos.wv.gov/elections/history/Pages/Voter_Registration.aspx")
  tables <- page %>% html_nodes("table") %>% html_table(fill=TRUE)

  # note: West Virginia puts a series of tables, updated monthly (it appears) on the same page.  So the particular
  # table corresponding to the 2016 general election will change over time (and, presumably, will eventually disappear)

  df <- tables[[3]] %>% head(-2) %>% tail(-1) %>%
    select(CountyName=X1, D=X2, R=X3, L=X5, N=X6, O=X7, X4) %>%
    mutate(G=NA, CountyName=trimws(CountyName)) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(O=O+X4) %>%
    select(-X4) %>%
    as_tibble() %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
