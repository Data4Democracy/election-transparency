#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @import dplyr
#' @import tidyr
#' @importFrom tibble as_tibble
#' @export
loadTexas <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('48') %>%
    mutate(CountyName=toupper(CountyName))

  page.2016 <- read_html("https://www.sos.state.tx.us/elections/historical/nov2016.shtml")
  tables.2016 <- page.2016 %>% html_nodes("table") %>% html_table(fill=TRUE)

  df.2016 <- tables.2016[[1]] %>%
    filter(`County Name` != 'Statewide Total') %>%
    select(CountyName=`County Name`, N=`Voter Registration`) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='LASALLE', 'LA SALLE', CountyName)) %>%
    left_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  
  page.2014 <- read_html("https://www.sos.state.tx.us/elections/historical/nov2014.shtml")
  tables.2014 <- page.2014 %>% html_nodes("table") %>% html_table(fill=TRUE)
  
  df.2014 <- tables.2014[[1]] %>%
    filter(`County Name` != 'Statewide Total') %>%
    select(CountyName=`County Name`, N=`Voter Registration`) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    mutate(Year = 2014, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='LASALLE', 'LA SALLE', CountyName)) %>%
    left_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()
  
  df <- rbind(df.2016, df.2014)
  
  df

}
