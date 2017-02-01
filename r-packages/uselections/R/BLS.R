#' @importFrom readr read_tsv
#' @import dplyr
#' @export
loadCountyBLSData <- function() {

  df <- read_tsv('data-raw/la.data.64.County', na=c('-')) %>%
    filter(year==2016) %>% filter(period=='M10') %>%
    mutate(County=substr(series_id, 6, 10), type=substr(series_id, 20, 20)) %>%
    filter(type != '3') %>%
    mutate(type=recode(type, '4'='Unemployment', '5'='Employment', '6'='LaborForce')) %>%
    select(County, type, value) %>%
    spread(type, value)

  df

}
