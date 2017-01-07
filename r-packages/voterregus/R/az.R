#' @import dplyr
#' @importFrom readr read_delim read_lines
#' @export
loadArizona <- function() {

  lines <- read_lines("data-raw/az/2016-11-08.csv")
  filteredLines <- character()

  readFirstDistrict <- FALSE
  readLastDistrict <- FALSE

  for (line in lines) {

    readFirstDistrict <- readFirstDistrict | grepl(x=line, pattern="Congressional District 1")

    if (readFirstDistrict & !readLastDistrict) {

      if (!grepl(x=line, pattern="Congressional District|TOTALS")) {
        filteredLines <- c(filteredLines, line)
      }

    }

    readLastDistrict <- readLastDistrict | grepl(x=line, pattern="STATE TOTALS")

  }

  countyNameFIPSMapping <- getCountyNameFIPSMapping('04')

  df <- read_delim(paste(filteredLines, collapse="\n"), delim=",", col_names=FALSE, col_types="cccccccccccc") %>%
    select(CountyName=X4, D=X6, G=X8, L=X9, R=X10, O=X11) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement=""))) %>%
    mutate_each("as.integer", -CountyName) %>%
    group_by(CountyName) %>%
    summarize_each(funs(sum(., na.rm=TRUE))) %>%
    ungroup() %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName)

  df

}
