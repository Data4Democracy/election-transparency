#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @import dplyr
#' @import tidyr
#' @export
loadUtah <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('49')

  dfs <- list()

  for (i in 1:6) {
    dfs[[i]] <- read.xlsx("data-raw/ut/Utah June 2016 Registration.xlsx", sheet=i)
  }

  df <- bind_rows(dfs) %>%
    select(CountyName=County, Party, Registered) %>%
    spread(Party, Registered) %>%
    rename(D=`Democratic Party`, R=`Republican Party`, L=`Libertarian Party`, N=Unaffiliated) %>%
    mutate(O=`Constitution Party` + `Independent American Party`, G=NA) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    select(CountyName, D, G, L, R, N, O, Year, Month) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
