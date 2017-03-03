#' @importFrom openxlsx read.xlsx
#' @importFrom readr read_csv cols_only col_integer col_double col_character
#' @importFrom stringr str_pad
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

  dfs <- list()
  dfs[['2016']] <- df

  for (f in list.files('data-raw/ca/', pattern='*.csv', full.names=TRUE)) {
    tdf <- read_csv(f, skip=1, col_names=FALSE, col_types=cols_only(
      X1=col_skip(),
      X2=col_skip(),
      X3=col_integer(),
      X4=col_integer(),
      X5=col_integer(),
      X6=col_integer(),
      X7=col_integer(),
      X8=col_integer(),
      X9=col_integer(),
      X10=col_integer(),
      X11=col_integer()
    )) %>%
      rename(County=X3, Year=X4, Month=X5, D=X6, G=X7, L=X8, N=X9, O=X10, R=X11) %>%
      mutate(County=str_pad(County, 5, 'left', '0'))
    dfs[[f]] <- tdf
  }

  df <- bind_rows(dfs)

  df

}
