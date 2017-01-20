#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadIllinois <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('17') %>%
    mutate(CountyName=paste0(CountyName, " County"))

  df <- read.xlsx("data-raw/il/Active & Inactive totals  11-10-16.xlsx", sheet=1, startRow=2, colNames=FALSE, cols=c(2,3)) %>%
    mutate(CountyName=X1, N=X2) %>%
    filter(!is.na(CountyName) & CountyName != 'Totals') %>%
    mutate(D=NA, G=NA, L=NA, R=NA, O=NA) %>%
    select(CountyName, D, G, L, R, N, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=ifelse(CountyName=='City of Aurora', 'Kane County', CountyName)) %>% # technically parts in other counties too, but best we can do
    mutate(CountyName=ifelse(CountyName=='City of Bloomington', 'McLean County', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName=='City of Chicago', 'Cook County', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName=='City of Danville', 'Vermilion County', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName=='City of East St Louis', 'St. Clair County', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName=='City of Galesburg', 'Knox County', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName=='City of Rockford', 'Winnebago County', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName=='JoDaviess County', 'Jo Daviess County', CountyName)) %>%
    mutate(CountyName=ifelse(CountyName=='DeWitt County', 'De Witt County', CountyName)) %>%
    group_by(CountyName) %>%
    summarize_each("sum") %>%
    ungroup() %>%
    mutate(Year = as.integer(2016), Month = as.integer(11)) %>% # Hardcode until we add historical data
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
