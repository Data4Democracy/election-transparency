#' @importFrom tibble as_tibble
#' @importFrom openxlsx read.xlsx
#' @import dplyr
#' @export
loadKansas <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('20')

  df <- read.xlsx("data-raw/ks/2015_August_Voter_Registration_and_Party_Affiliation_Numbers_Certified.xlsx") %>%
    select(-Total, -X7) %>%
    rename(CountyName=County, D=Democratic, L=Libertarian, R=Republican, N=Unaffiliated) %>%
    mutate(G=NA, O=NA) %>%
    mutate_each("as.integer", -CountyName) %>% as_tibble() %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName)

  df

}
