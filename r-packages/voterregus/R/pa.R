#' @importFrom tibble as_tibble
#' @importFrom openxlsx read.xlsx
#' @import dplyr
#' @export
loadPennsylvania <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('42') %>%
    mutate(CountyName=toupper(CountyName))

  # Note:  Pennsylvania's website provides this as an xls (old Excel) file.  openxlsx requires xlsx format.
  # we could use the xlsx library, but that requires Java and has other issues...  so you just need to open
  # the xls file in Excel and save-as xlsx.

  df <- read.xlsx("data-raw/pa/currentvotestats.xlsx", sheet=1, rows=3:69, colNames=FALSE) %>%
    select(-X2, -X7) %>%
    rename(CountyName=X1, D=X3, R=X4, N=X5, O=X6) %>%
    mutate(G=NA, L=NA, CountyName=ifelse(CountyName=='McKEAN', 'MCKEAN', CountyName)) %>%
    mutate_each("as.integer", -CountyName) %>% as_tibble() %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) # %>% select(-CountyName)

  df

}
