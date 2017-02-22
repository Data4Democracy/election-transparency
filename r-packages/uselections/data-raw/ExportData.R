# Script to export dataframe to package

library(dplyr)
library(readr)
library(rgdal)
library(stringr)

dfs <- list(
  uselections::loadAlabama(),
  uselections::loadAlaska(),
  uselections::loadArkansas(),
  uselections::loadArizona(),
  uselections::loadCalifornia(),
  uselections::loadColorado(),
  uselections::loadConnecticut(),
  uselections::loadDelaware(),
  uselections::loadDC(),
  uselections::loadFlorida(),
  uselections::loadGeorgia(),
  uselections::loadHawaii(),
  uselections::loadIdaho(),
  uselections::loadIllinois(),
  uselections::loadIndiana(),
  uselections::loadIowa(),
  uselections::loadKansas(),
  uselections::loadKentucky(),
  uselections::loadLouisiana(),
  uselections::loadMaine(),
  uselections::loadMaryland(),
  uselections::loadMassachusetts(),
  uselections::loadMichigan(),
  uselections::loadMinnesota(),
  uselections::loadMississippi(),
  uselections::loadMissouri(),
  uselections::loadMontana(),
  uselections::loadNebraska(),
  uselections::loadNevada(),
  uselections::loadNewHampshire(),
  uselections::loadNewJersey(),
  uselections::loadNewMexico(),
  uselections::loadNewYork(),
  uselections::loadNorthCarolina(),
  uselections::loadNorthDakota(),
  uselections::loadOhio(),
  uselections::loadOklahoma(),
  uselections::loadOregon(),
  uselections::loadPennsylvania(),
  uselections::loadRhodeIsland(),
  uselections::loadSouthCarolina(),
  uselections::loadSouthDakota(),
  uselections::loadTennessee(),
  uselections::loadTexas(),
  uselections::loadUtah(),
  uselections::loadVermont(),
  uselections::loadVirginia(),
  uselections::loadWashington(),
  uselections::loadWestVirginia(),
  uselections::loadWisconsin(),
  uselections::loadWyoming()
)


PartyRegistration <- select(mutate(bind_rows(dfs), State=substr(County, 1, 2)), State, County, Year, Month, D, G, L, N, O, R)

df <- PartyRegistration %>%
  mutate_each(funs(replace(., which(is.na(.)), 0))) %>%
  mutate(Total=D+G+L+N+O+R, dPct=D/Total, rPct=R/Total, leanD=D/R, leanR=R/D, unaffiliatedPct=N/Total, otherPct=O/Total,
         dDRPct=D/(D+R), rDRPct=R/(D+R)) %>%
  mutate(dPct=ifelse(N==Total, NA, dPct),
         rPct=ifelse(N==Total, NA, rPct),
         leanD=ifelse(N==Total, NA, leanD),
         leanR=ifelse(N==Total, NA, leanR),
         otherPct=ifelse(N==Total, NA, otherPct),
         dDRPct=ifelse(N==Total, NA, dDRPct),
         rDRPct=ifelse(N==Total, NA, rDRPct)) %>%
  select(-D, -G, -L, -N, -O, -R, -State)

PartyRegistration <- PartyRegistration %>% inner_join(df, by=c("County"="County", "Year"="Year", "Month"="Month"))

States <- read_csv("data-raw/States.txt",
                   col_types=cols_only(State = col_character(),
                                       StateName = col_character(),
                                       StateAbbr = col_character(),
                                       ElectoralVotes = col_integer(),
                                       AllowsPartyRegistration = col_logical(),
                                       VoterIDLaw = col_integer(),
                                       VoterIDLawVerbose = col_character(),
                                       ClosedPrimary = col_logical()))

countyData <- uselections::getCountyData() %>% select(STATEFP, GEOID, NAME) %>%
  mutate_each("as.character") %>%
  mutate(NAME=recode(GEOID, "24510"="Baltimore City", "24005"="Baltimore County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "29510"="St. Louis City", "29189"="St. Louis County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "51760"="Richmond City", "51159"="Richmond County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "51770"="Roanoke City", "51161"="Roanoke County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "51600"="Fairfax City", "51059"="Fairfax County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "51620"="Franklin City", "51067"="Franklin County", .default=NAME)) %>%
  inner_join(States, by=c("STATEFP"="State")) %>%
  select(CountyName=NAME, StateName, StateAbbr, County=GEOID)

PartyRegistration <- PartyRegistration %>%
  inner_join(countyData, by="County") %>%
  mutate(Year=as.integer(Year), Month=as.integer(Month))

PresidentialElectionResults2016 <- load2016PresidentialResults() %>%
  inner_join(countyData, by="County") %>%
  mutate(dPct=clinton/totalvotes, rPct=trump/totalvotes, leanD=clinton/trump, leanR=trump/clinton, otherPct=other/totalvotes,
         dDRPct=clinton/(clinton+trump), rDRPct=trump/(clinton+trump), State=substr(County, 1, 2))

CountyArea <- getCountyData() %>% mutate(LandAreaSqMiles=(as.numeric(as.character(ALAND)))*0.000000386102159) %>%
  select(GEOID, LandAreaSqMiles) %>%
  mutate(GEOID=as.character(GEOID))

AmericanNations <- read_csv('http://specialprojects.pressherald.com/americannations/county_results.csv',
                            col_types=cols_only(GEOID=col_integer(), AN_TITLE=col_character())) %>%
  mutate(County=str_pad(GEOID, 5, 'left', '0'), WoodardAmericanNation=AN_TITLE) %>%
  select(County, WoodardAmericanNation) %>%
  filter(!(County %in% c('46113', '02270'))) %>% # these counties don't exist
  bind_rows(data.frame(County=c('02158', '01059', '46102'), WoodardAmericanNation=c('First Nation', 'Deep South', 'Far West'))) # not in Woodard's list

FoundryPartialStates <- read_csv('data-raw/FoundryPartialStateCounties.txt',
                                 col_types=cols_only(X1=col_character(), X2=col_character()), col_names=FALSE) %>%
  inner_join(States, by=c("X1"="StateAbbr")) %>% select(State, X2) %>%
  inner_join(getCountyData() %>% select(County=GEOID, CountyName=NAME, State=STATEFP) %>%
               mutate_each("as.character"), by=c('X2'='CountyName', 'State'='State')) %>% select(County)

FoundryCompleteStates <- getCountyData() %>% select(STATEFP, GEOID) %>% mutate_each ('as.character') %>%
  filter(STATEFP %in% c('26','34','36','39','42')) %>% filter(GEOID != '36061')  %>% # MI, OH, PA, NY, NJ...minus Manhattan
  select(County=GEOID)

FoundryCounties <- c(FoundryPartialStates$County, FoundryCompleteStates$County)

CountyCharacteristics <- loadCountyACSData() %>% full_join(loadCountyBEAData(), by="County") %>%
  inner_join(AmericanNations, by="County") %>%
  inner_join(CountyArea, by=c('County'='GEOID')) %>%
  inner_join(loadCountyBLSData(), by='County') %>%
  inner_join(loadCountySSIData(), by='County') %>%
  left_join(loadCountyCDCData(), by='County') %>%
  mutate(State=substr(County, 1, 2), FoundryCounty=County %in% FoundryCounties)

AlaskaPrecinctBoroughMapping <- getAlaskaPrecinctCountyMapping()

devtools::use_data(PartyRegistration, overwrite=TRUE)
devtools::use_data(PresidentialElectionResults2016, overwrite=TRUE)
devtools::use_data(States, overwrite=TRUE)
devtools::use_data(CountyCharacteristics, overwrite=TRUE)
devtools::use_data(AlaskaPrecinctBoroughMapping, overwrite=TRUE)

rm(PartyRegistration)
rm(PresidentialElectionResults2016)
rm(AlaskaPrecinctBoroughMapping)
rm(countyData)
rm(df)
rm(dfs)
rm(States)
rm(CountyCharacteristics)
rm(CountyArea)
rm(FoundryPartialStates)
rm(FoundryCompleteStates)
rm(FoundryCounties)
