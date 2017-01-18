#' @importFrom readr read_delim
#' @importFrom tibble as_tibble
#' @import dplyr
#' @export
loadMaine <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('23')

  df <- read_delim("data-raw/me/r-e-active.txt", delim="|", col_names=TRUE) %>%
  select(COUNTY, D, G, L, R, U) %>%
  mutate(CountyName=recode(COUNTY,
                           AND='Androscoggin',
                           ARO='Aroostook',
                           CUM='Cumberland',
                           FRA='Franklin',
                           HAN='Hancock',
                           KEN='Kennebec',
                           KNO='Knox',
                           LIN='Lincoln',
                           OXF='Oxford',
                           PEN='Penobscot',
                           PIS='Piscataquis',
                           SAG='Sagadahoc',
                           SOM='Somerset',
                           WAL='Waldo',
                           WAS='Washington',
                           YOR='York')) %>%
  select(-COUNTY) %>%
  rename(N=U)%>%
  mutate_each("as.integer", -CountyName) %>%
  group_by(CountyName) %>%
  summarize_each(funs(sum(., na.rm=TRUE))) %>%
  inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
  select(-CountyName) %>%
  mutate(O=as.integer(NA))  %>%
  mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
  as_tibble()

  df
}
