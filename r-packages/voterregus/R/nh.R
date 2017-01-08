#' @importFrom tibble as_tibble
#' @importFrom openxlsx read.xlsx
#' @import dplyr
#' @export
loadNewHampshire <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('33')

  # Note:  New Hampshire's website provides this as an xls (old Excel) file.  openxlsx requires xlsx format.
  # we could use the xlsx library, but that requires Java and has other issues...  so you just need to open
  # the xls file in Excel and save-as xlsx.

  df <- read.xlsx("data-raw/nh/nh.xlsx", sheet=1, rows=4:13, colNames=FALSE) %>%
    select(-X5) %>%
    rename(CountyName=X1, D=X3, R=X2, N=X4) %>%
    mutate(G=NA, L=NA, O=NA, CountyName=trimws(CountyName)) %>%
    mutate_each("as.integer", -CountyName) %>% as_tibble() %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName)

  df

}
