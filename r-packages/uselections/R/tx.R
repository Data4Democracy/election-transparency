#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @import dplyr
#' @import tidyr
#' @importFrom tibble as_tibble
#' @export
loadTexas <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('48') %>%
    mutate(CountyName=toupper(CountyName))

  df.list = list()
  df.iterator <- 1
  #start at 2008
  for(i in seq(2008, 2016, 2))
  {
    page <- read_html(paste("https://www.sos.state.tx.us/elections/historical/nov", i, ".shtml", sep=""))
    tables <- page %>% html_nodes("table") %>% html_table(fill=TRUE)
    
    df.year.i <- tables[[1]] %>%
      filter(`County Name` != 'Statewide Total') %>%
      select(CountyName=`County Name`, N=`Voter Registration`) %>%
      mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
      mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
      mutate(Year = i, Month = 11) %>% # Hardcode until we add historical data
      select(CountyName, D, G, L, R, N, O, Year, Month) %>%
      mutate_each("as.integer", -CountyName) %>%
      mutate(CountyName=ifelse(CountyName=='LASALLE', 'LA SALLE', CountyName)) %>%
      left_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
      select(-CountyName) %>%
      as_tibble()
    
      df.list[[df.iterator]] <- df.year.i
      df.iterator <- df.iterator + 1
  }
  
  df <- do.call(rbind, df.list)
  
  df

}
