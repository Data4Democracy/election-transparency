#' @import dplyr
#' @importFrom readr read_csv cols_only col_character col_integer col_number
#' @export
loadCountyACSData <- function() {

  # execute this query in American Fact Finder: https://factfinder.census.gov/bkmk/table/1.0/en/ACS/15_5YR/S1903/0100000US.05000.003
  # then download the data file to the data-raw directory
  medianIncomeDf <- read_csv('data-raw/ACS_15_5YR_S1903_with_ann.csv', skip=2, col_names=FALSE, na=c('(X)'),
                             col_types=cols_only(X2=col_character(), X6=col_integer())) %>%
    rename(County=X2, MedianHouseholdIncome=X6)

  # American Fact Finder:  https://factfinder.census.gov/bkmk/table/1.0/en/ACS/15_5YR/DP05/0100000US.05000.003
  # then download the data file to the data-raw directory
  populationDf <- read_csv('data-raw/ACS_15_5YR_DP05_with_ann.csv', skip=2, col_names=FALSE, na=c('(X)'),
                           col_types=cols_only(X2=col_character(),
                                               X6=col_integer(),
                                               X8=col_integer(),
                                               X12=col_integer(),
                                               X16=col_integer(),
                                               X20=col_integer(),
                                               X24=col_integer(),
                                               X28=col_integer(),
                                               X32=col_integer(),
                                               X36=col_integer(),
                                               X40=col_integer(),
                                               X44=col_integer(),
                                               X48=col_integer(),
                                               X52=col_integer(),
                                               X56=col_integer(),
                                               X60=col_integer(),
                                               X64=col_integer(),
                                               X68=col_number(),
                                               X236=col_integer(),
                                               X240=col_integer(),
                                               X244=col_integer(),
                                               X248=col_integer(),
                                               X252=col_integer(),
                                               X256=col_integer(),
                                               X264=col_integer())) %>%
    rename(County=X2, TotalPopulation=X6, Male=X8, Female=X12, Age0_4=X16, Age5_9=X20, Age10_14=X24, Age15_19=X28,
           Age20_24=X32, Age25_34=X36, Age35_44=X40, Age45_54=X44, Age55_59=X48, Age60_64=X52, Age65_74=X56, Age75_84=X60,
           Age85=X64, MedianAge=X68, White=X236, Black=X240, AmericanIndianAlaskaNative=X244, Asian=X248, NativeHawaiianPacificIslander=X252, OtherRace=X256,
           Hispanic=X264) %>%
    mutate(SimpsonDenom=White+Black+AmericanIndianAlaskaNative+Asian+NativeHawaiianPacificIslander+OtherRace,
      SimpsonDiversityIndex=1 - ((White/SimpsonDenom)^2 + (Black/SimpsonDenom)^2 + (AmericanIndianAlaskaNative/SimpsonDenom)^2 +
             (Asian/SimpsonDenom)^2 + (NativeHawaiianPacificIslander/SimpsonDenom)^2 + (OtherRace/SimpsonDenom)^2)) %>% select(-SimpsonDenom)

  # American Fact Finder: https://factfinder.census.gov/bkmk/table/1.0/en/ACS/15_5YR/S1501/0100000US.05000.003
  # then download the data file to the data-raw directory
  educationDf <- read_csv('data-raw/ACS_15_5YR_S1501_with_ann.csv', skip=2, col_names=FALSE, na=c('(X)'),
                          col_types=cols_only(X2=col_character(), X64=col_integer(), X76=col_integer(), X88=col_integer(),
                                              X100=col_integer(), X112=col_integer(), X124=col_integer(), X136=col_integer(), X148=col_integer())) %>%
    rename(County=X2, Population25Plus=X64, EdK8=X76, Ed9_12=X88, EdHS=X100, EdCollNoDegree=X112, EdAssocDegree=X124, EdBachelorDegree=X136,
           EdGraduateDegree=X148)

  # American Fact Finder: https://factfinder.census.gov/bkmk/table/1.0/en/ACS/15_5YR/B25105/0100000US.05000.003
  # then download the data file to the data-raw directory
  housingCostsDf <- read_csv('data-raw/ACS_15_5YR_B25105_with_ann.csv', skip=2, col_names=FALSE,
                             col_types=cols_only(X2=col_character(), X4=col_integer())) %>%
    rename(MedianHousingCosts=X4, County=X2)

  # American Fact Finder: https://factfinder.census.gov/bkmk/table/1.0/en/ACS/15_5YR/S1201/0100000US.05000.003
  # then download the data file to the data-raw directory
  maritalStatusDf <- read_csv('data-raw/ACS_15_5YR_S1201_with_ann.csv', skip=2, col_names=FALSE,
                              col_types=cols_only(X2=col_character(), X4=col_integer(), X6=col_double(), X8=col_double(),
                                                  X10=col_double(), X12=col_double(), X14=col_double())) %>%
    rename(County=X2) %>%
    mutate(Married=X6*X4/100, Widowed=X8*X4/100, Divorced=X10*X4/100, Separated=X12*X4/100, NeverMarried=X14*X4/100) %>%
    select(-starts_with('X')) %>% mutate_each("round", -County) %>% mutate_each("as.integer", -County)

  inner_join(medianIncomeDf, populationDf, by="County") %>% inner_join(educationDf, by="County") %>%
    inner_join(housingCostsDf, by="County") %>% inner_join(maritalStatusDf, by="County")

}
