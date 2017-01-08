#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadNebraska <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('31')

  df <- read_csv("data-raw/ne/2016-canvass-book.csv") %>%
    rename(CountyName=County, R=Republican, D=Democratic, L=Libertarian, N=Nonpartisan) %>%
    mutate(G=NA, O=NA) %>%
    select(CountyName, R, D, G, L, N, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName)

  df

}
