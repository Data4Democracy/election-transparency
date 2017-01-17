#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @import dplyr
#' @import tidyr
#' @export
loadAlaska <- function() {

  precinctCountyMap <- getAlaskaPrecinctCountyMapping()

  page <- read_html("http://elections.alaska.gov/statistics/2016/OCT/VOTERS%20Party_PostRegistrationDeadline.htm")
  tables <- page %>% html_nodes("table") %>% html_table(fill=TRUE) %>% tail(-2) %>% head(-1)
  tables <- tables[seq(1, length(tables), by=2)]

  tables <- lapply(tables, function(df) {
    df <- df %>% head(-2) %>% tail(-2) %>%
      select(X1, X5:X16) %>%
      mutate_each("as.integer", -X1) %>%
      mutate(O=X5+X11+X13+X14+X15+X16, N=X9+X10) %>%
      select(Precinct=X1, D=X6, L=X7, R=X8, G=X12, N, O) %>%
      mutate(Precinct=gsub(x=Precinct, pattern="([0-9\\-]+) .+", replacement="\\1"))
    df
  })

  df <- bind_rows(tables) %>%
    inner_join(precinctCountyMap, by=c("Precinct"="Precinct")) %>%
    mutate(County=paste0('02', County)) %>%
    select(-Precinct) %>%
    group_by(County) %>%
    summarize_each(funs(sum(., na.rm=TRUE))) %>%
    ungroup()

  df

}
