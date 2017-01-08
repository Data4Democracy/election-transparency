#' @importFrom tibble as_tibble
#' @importFrom openxlsx read.xlsx
#' @import dplyr
#' @export
loadLouisiana <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('22') %>%
    mutate(CountyName=toupper(CountyName))

  # Note:  Louisiana's website provides this as an xls (old Excel) file.  openxlsx requires xlsx format.
  # we could use the xlsx library, but that requires Java and has other issues...  so you just need to open
  # the xls file in Excel and save-as xlsx.

  spreadsheetFile <- "data-raw/la/2016_1201_par_comb.xlsx"

  sheets <- getSheetNames(spreadsheetFile)

  dfs <- list()

  for (sheet in sheets) {
    dfs[[sheet]] <- read.xlsx(spreadsheetFile, sheet, rows=c(10), colNames=FALSE) %>%
      select(CountyName=X1, D=X6, R=X10, O=X14) %>%
      mutate(G=NA, L=NA, N=NA)
  }

  df <- bind_rows(dfs) %>%
    mutate(CountyName=gsub(x=CountyName, pattern="([A-Z]+) PAR.+", replacement="\\1")) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(CountyName=gsub(x=CountyName, pattern="[^A-Z\\.]", replacement=" ")) %>% # some weird character used for a space in LA source file
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  df

}
