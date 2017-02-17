#' @importFrom openxlsx read.xlsx
#' @importFrom tibble as_tibble
#' @importFrom stringr str_pad
#' @import dplyr
#' @export
loadCountySSIData <- function() {

  # Downloaded from https://www.ssa.gov/policy/docs/statcomps/ssi_sc/

  spreadsheetFile <- 'data-raw/ssi_sc15.xlsx'
  sheetNames <- getSheetNames(spreadsheetFile)
  sheetNames <- sheetNames[grepl(x=sheetNames, pattern='Table 3.+')]

  dfs <- list()

  for (sheetName in sheetNames) {
    df <- read.xlsx(spreadsheetFile, sheetName, startRow=6, colNames=FALSE, na.strings='(X)') %>%
      select(-X1, -X2) %>%
      filter(!(grepl(x=X3, pattern='Counties|Independent.+'))) %>%
      filter(!is.na(X3)) %>%
      mutate_each('as.integer')
      dfs[[sheetName]] <- df
  }

  dcPayments <- read.xlsx(spreadsheetFile, 'Table 2', rows=13, cols=4, colNames=FALSE) %>% rename(X11=X1)

  df <- read.xlsx(spreadsheetFile, 'Table 1', rows=13, colNames=FALSE) %>%
    mutate(X10=X8, X9=X7, X8=X6, X7=X5, X6=X4, X5=X3, X4=X2, X3=11001) %>%
    select(-X1, -X2)

  df <- cbind(df, dcPayments)

  dfs[['DC']] <- df

  df <- bind_rows(dfs) %>%
    rename(County=X3, TotalSSI=X4, AgedSSI=X5, BlindDisabledSSI=X6, OASDI=X10, SSIPayments=X11) %>%
    mutate(County=str_pad(as.character(County), 5, 'left', '0'), SSIPayments=SSIPayments*1000) %>%
    select(-X7, -X8, -X9) %>%
    mutate_each('as.integer', -County) %>%
    as_tibble()

}
