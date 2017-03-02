#' @import dplyr
#' @importFrom readr read_fwf fwf_positions
#' @export
loadCountyCDCData <- function() {

  df <- read_fwf('ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/OAE/urbanrural/NCHSURCodes2013.txt',
                 col_types='cccccccccc',
                 fwf_positions(c(1,3,7,10,47,98,107,116,118,120), c(2,5,8,45,96,105,114,116,118,120))) %>%
    mutate(County=paste0(X1, X2),
           NCHS_UrbanRural2013=recode(X8,
                                      '1'='Large central metro',
                                      '2'='Large fringe metro',
                                      '3'='Medium metro',
                                      '4'='Small metro',
                                      '5'='Micropolitan (nonmetropolitan)',
                                      '6'='Noncore (nonmetropolitan)'),
           NCHS_UrbanRural2006=recode(X9,
                                      '1'='Large central metro',
                                      '2'='Large fringe metro',
                                      '3'='Medium metro',
                                      '4'='Small metro',
                                      '5'='Micropolitan (nonmetropolitan)',
                                      '6'='Noncore (nonmetropolitan)'),
           NCHS_UrbanRural1990=recode(X10,
                                      '1'='Large central metro',
                                      '2'='Large fringe metro',
                                      '3'='Medium metro',
                                      '4'='Small metro',
                                      '5'='With a city of 10,000 or more (nonmetropolitan)',
                                      '6'='Without a city of 10,00 or more (nonmetropolitan)')) %>%
    select(County, starts_with('NCHS'))

  df

}
