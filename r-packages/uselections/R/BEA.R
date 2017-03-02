#' @importFrom openxlsx read.xlsx
#' @import dplyr
#' @importFrom tibble as_tibble
#' @export
loadCountyBEAData <- function() {

  # To create these tables:
  # 1. bea.gov >> Interactive Data
  # 2. GDP & Personal Income
  # 3. Table:  Local Area Personal Income and Employment >> Personal Income by Major Component and Earnings by Industry (CA5, CA5N)
  # 4. Select NAICS or SIC, depending on timeframe
  # 5. Major Area=County
  # 6. State=All Counties in the US
  # 7. Area/Statistic:  Levels, Manufacturing
  # 8. Time period (select desired year)
  # 9. Download and manually assemble into spreadsheet

  df <- NULL

  for (sheet in c('Mfg1', 'Mfg2', 'Total1', 'Total2')) {
    dft <- read.xlsx('data-raw/CountyEmployment.xlsx', sheet=sheet, rows=7:3144, colNames=FALSE, na.strings=c('(D)', '(L)', '(NA)')) %>%
      select(-X2)
    colCount <- ncol(dft) - 1
    originalNames <- paste0('X', 3:(3+colCount-1))
    newNames <- paste0(sheet, 3:(3+colCount-1))
    dft <- rename_(dft, .dots=setNames(originalNames, newNames))
    if (is.null(df)) {
      df <- dft
    } else {
      df <- inner_join(df, dft, by=c("X1"="X1"))
    }
  }

  df <- df %>%
    rename(County=X1, MfgEmp1970=Mfg23, MfgEmp1980=Mfg24, MfgEmp1990=Mfg25, MfgEmp2001=Mfg13, MfgEmp2015=Mfg14,
           TotalEmp1970=Total23, TotalEmp1980=Total24, TotalEmp1990=Total25, TotalEmp2001=Total13, TotalEmp2015=Total14) %>%
    select_(.dots=sort(colnames(.))) %>%
    mutate_each("as.integer", -County) %>%
    as_tibble()

  df

}
