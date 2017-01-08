#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @import dplyr
#' @import tidyr
#' @importFrom tibble as_tibble
#' @export
loadFlorida <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('12') %>%
    mutate(CountyName=toupper(CountyName))

  page <- read_html("http://dos.myflorida.com/elections/data-statistics/voter-registration-statistics/voter-registration-monthly-reports/voter-registration-current-by-county/")
  tables <- page %>% html_nodes("table") %>% html_table(fill=TRUE)

  df <- tables[[1]] %>%
    rename(CountyName=COUNTY, R=REPUBLICAN, D=DEMOCRAT, O=MINOR, N=NONE) %>%
    select(-TOTAL) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate(L=NA, G=NA) %>%
    mutate_each("as.integer", -CountyName) %>%
    as_tibble() %>%
    filter(CountyName != 'TOTAL') %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName)

  df

}
