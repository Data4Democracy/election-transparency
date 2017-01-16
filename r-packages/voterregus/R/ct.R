#' @importFrom readr read_lines read_csv
#' @import dplyr
#' @export
loadConnecticut <- function() {

  lines <- read_lines("data-raw/ct/nov15re.csv")
  filteredLines <- lines[!grepl(x=lines, pattern="Republican Party|Town ,County|Totals ,")] %>% head(169)

  countyNameFIPSMapping <- getCountyNameFIPSMapping('09')

  getThirdValue <- function(s) {
    gsub(x=s, pattern="(.+) (.+) (.+)", replacement="\\3")
  }

  df <- read_csv(paste(filteredLines, collapse="\n"), col_names=paste0('X', 1:14), col_types=paste0(rep('c', 14), collapse="")) %>%
    mutate(Town=X1, CountyName=X2, R=getThirdValue(X4), D=getThirdValue(X5), O=gsub(x=X8, pattern="([0-9,]+) .*", replacement="\\1"), N=X11) %>%
    select(CountyName, R, D, O, N) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer", -CountyName) %>%
    group_by(CountyName) %>%
    summarize_each(funs(sum(., na.rm=TRUE))) %>%
    ungroup() %>%
    mutate(G=as.integer(NA), L=as.integer(NA)) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
