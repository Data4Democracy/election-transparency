#' @importFrom tibble as_tibble
#' @importFrom openxlsx read.xlsx
#' @importFrom readr read_lines
#' @import dplyr
#' @export
loadRhodeIsland <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('44')

  # Rhode Island reports results by town/city, which is really the local unit of government in the state.
  # But Census still rolls up by county.  So we need to map towns to counties.

  townCountyMapping <- read.xlsx("data-raw/ri/TownCountyMapping.xlsx", colNames=FALSE) %>%
    rename(Town=X1, CountyName=X2) %>%
    mutate(Town=toupper(Town))

  lines <- read_lines("data-raw/ri/10-09-16_RI_VR_TOTALS.csv")

  townTotalLines <- character()
  towns <- character()

  for (line in lines) {

    if (!(grepl(x=line, pattern="^Active|Inactive|Change.+"))) {
      if (grepl(x=line, pattern="^City / Town Total.+")) {
        townTotalLines <- c(townTotalLines, line)
      } else if (!(grepl(x=line, pattern="^City / Town.+")))  {
        towns <- c(towns, gsub(x=line, pattern="([A-Z ]+),.+", replacement="\\1"))
      }

    }

  }

  towns <- towns[towns != 'Total: ']
  dfs <- list()

  t2 <- gsub(x=townTotalLines, pattern=".+: (.+)", replacement="\\1")
  t2 <- gsub(x=t2, pattern="^,(.+)", replacement="\\1")
  t2 <- strsplit(t2, ",")
  t2 <- lapply(t2, function(v) {
    ret <- v
    if(length(v) == 7) {
      v <- v[-2]
    }
    trimws(v)
  })

  df <- as.data.frame(matrix(unlist(t2), ncol=6, byrow=TRUE), stringsAsFactors=FALSE)
  df$Town <- towns

  df <- as_tibble(df) %>%
    mutate_each("as.integer", -Town) %>%
    rename(D=V1, R=V2, O=V3, N=V4) %>%
    select(Town, D, R, O, N) %>%
    mutate_each("as.integer", -Town) %>%
    inner_join(townCountyMapping, by=c("Town"="Town"))

  writeLines(paste0("Town-County merge for Rhode Island produced ", nrow(df), " rows"))

  df <- df %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-Town, -CountyName) %>%
    group_by(County) %>%
    summarize_each(funs(sum(., na.rm=TRUE))) %>%
    mutate(G=as.integer(NA), L=as.integer(NA)) %>%
    ungroup()

  df

}
