#' @importFrom readr read_csv
#' @import dplyr
#' @importFrom tibble as_tibble
#' @export
loadMassachusetts <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('25') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_csv("data-raw/ma/enrollment_counts_20161019.csv", col_names=paste0('X', seq(14)), col_types='cnncccncncncnc') %>%
    select(CountyName=X1, D=X3, R=X5, G=X7, X9, X13, N=X11)

  df$R <- gsub(x=unlist(lapply(strsplit(df$R, " "), head, 1)), pattern=",", replacement="")

  df <- df %>%
    mutate_each("as.integer", -CountyName) %>%
    mutate(O=X9+X13) %>%
    select(CountyName, D, R, G, N, O) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11) %>% # Hardcode until we add historical data
    as_tibble()

  df

}
