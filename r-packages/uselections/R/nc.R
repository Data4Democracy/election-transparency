#' @import dplyr
#' @importFrom readr read_tsv cols_only col_character col_integer
#' @export
loadNorthCarolina <- function() {

  countyNameFIPSMapping <- getCountyNameFIPSMapping('37') %>%
    mutate(CountyName=toupper(CountyName))

  df <- read_tsv('data-raw/nc/voter_stats_20161108.txt',
                 col_types=cols_only(county_desc=col_character(),
                                     election_date=col_skip(),
                                     stats_type=col_skip(),
                                     precinct_abbrv=col_skip(),
                                     vtd_abbrv=col_skip(),
                                     party_cd=col_character(),
                                     race_code=col_skip(),
                                     ethnic_code=col_skip(),
                                     sex_code=col_skip(),
                                     age=col_skip(),
                                     total_voters=col_integer()
                 )) %>%
    group_by(county_desc, party_cd) %>%
    summarize(total_voters=sum(total_voters)) %>%
    ungroup() %>%
    spread(party_cd, total_voters) %>%
    select(CountyName=county_desc, D=DEM, R=REP, L=LIB, N=UNA) %>%
    mutate(G=NA, O=NA, CountyName=trimws(CountyName)) %>%
    inner_join(countyNameFIPSMapping, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    mutate(Year = 2016, Month = 11)

}
