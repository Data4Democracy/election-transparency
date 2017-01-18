#' @importFrom openxlsx read.xlsx
#' @import dplyr
#' @export
loadCalifornia <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('06')

  # Note:  California's website provides this as an xls (old Excel) file.  openxlsx requires xlsx format.
  # we could use the xlsx library, but that requires Java and has other issues...  so you just need to open
  # the xls file in Excel and save-as xlsx.

  df <- read.xlsx("data-raw/ca/county.xlsx") %>%
    rename(CountyName=County) %>%
    filter(CountyName != 'Percent') %>%
    mutate(O=American.Independent+Other+Peace.and.Freedom) %>%
    select(CountyName, D=Democratic, R=Republican, G=Green, L=Libertarian, N=No.Party.Preference, O) %>%
    mutate_each("as.integer", -CountyName) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
