#' @importFrom openxlsx read.xlsx
#' @import dplyr
#' @importFrom tibble as_tibble
#' @importFrom stringr str_pad
#' @export
loadCountyReligionCensusData <- function() {

  # http://www.thearda.com/Archive/Files/Descriptions/RCMSMT10.asp

  df <- read.xlsx('data-raw/U.S. Religion Census Religious Congregations and Membership Study, 2010 (County File).XLSX',
                  sheet=1, cols=c(2, 5, 14, 166, 562)) %>%
    mutate(County=str_pad(FIPS, 5, 'left', '0')) %>%
    rename(TotalReligiousAdherents=TOTADH, EvangelicalAdherents=EVANADH, CatholicAdherents=CATHADH, MormonAdherents=LDSADH) %>%
    select(-FIPS) %>%
    mutate_each('as.integer', -County) %>%
    as_tibble()

}
