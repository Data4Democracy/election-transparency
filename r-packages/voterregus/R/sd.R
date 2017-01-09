#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadSouthDakota <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('46')

  df <- read_csv("data-raw/sd/StatewideVotersByCountybyParty_11.8.2016.csv") %>%
    rename(CountyName=County, R=Republican, D=Democratic, L=Libertarian, N=`NPA/IND`) %>%
    mutate(G=NA, O=OTH+Constitution) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    filter(CountyName != 'Total') %>%
    mutate(CountyName=ifelse(CountyName=='Oglala Lakota', 'Fall River', CountyName)) %>% # tabulated separately by SD elections, but joined with Fall River in Census
    mutate_each("as.integer", -CountyName) %>%
    group_by(CountyName) %>%
    summarize_each(funs(sum(., na.rm=TRUE))) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>% select(-CountyName)

  df

}
