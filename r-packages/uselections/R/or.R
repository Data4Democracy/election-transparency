#' @importFrom readr read_csv
#' @import dplyr
#' @export
loadOregon <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('41')

  df <- read_csv("data-raw/or/Nov16.csv", col_names=paste0('X', 1:10), col_types=paste0(rep('c', 10), collapse="")) %>%
    mutate(CountyName=X1,
           D=gsub(x=X2, pattern="(.+) (.+)", replacement="\\1"),
           I=gsub(x=X2, pattern="(.+) (.+)", replacement="\\2"),
           R=X3,
           N=gsub(x=X4, pattern="(.+) (.+)", replacement="\\1"),
           Constitution=gsub(x=X4, pattern="(.+) (.+)", replacement="\\2"),
           L=X5,
           G=gsub(x=X6, pattern="(.+) (.+)", replacement="\\1"),
           Progressive=gsub(x=X6, pattern="(.+) (.+)", replacement="\\2")
    ) %>%
    mutate_each(funs(gsub(x=., pattern=",", replacement="")), -CountyName) %>%
    select(CountyName, D, I, R, N, Constitution, L, G, Progressive, X7, X8, X9) %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(O=X7+X8+X9+Constitution+Progressive) %>%
    select(CountyName, D, R, G, L, N, O) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) # Hardcode until we add historical data

  df

}
