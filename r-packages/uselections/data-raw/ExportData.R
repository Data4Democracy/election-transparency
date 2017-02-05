# Script to export dataframe to package

library(dplyr)
library(readr)
library(rgdal)

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

states <- read_csv("data-raw/States.txt", col_names=paste0('X', seq(4)), col_types='ccci')

countyData <- uselections::getCountyData() %>% select(STATEFP, GEOID, NAME) %>%
  mutate_each("as.character") %>%
  mutate(NAME=recode(GEOID, "24510"="Baltimore City", "24005"="Baltimore County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "29510"="St. Louis City", "29189"="St. Louis County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "51760"="Richmond City", "51159"="Richmond County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "51770"="Roanoke City", "51161"="Roanoke County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "51600"="Fairfax City", "51059"="Fairfax County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "51620"="Franklin City", "51067"="Franklin County", .default=NAME)) %>%
  inner_join(states, by=c("STATEFP"="X2")) %>%
  select(CountyName=NAME, StateName=X1, StateAbbr=X3, County=GEOID)

States <- states %>% select(State=X2, StateName=X1, StateAbbr=X3, ElectoralVotes=X4) %>%
  mutate(AllowsPartyRegistration=as.integer(StateAbbr %in%
                                              c('AK','CA','CO','CT','DE','DC','FL','ID','IA','KS','KY','ME','MD',
                                                'MA','NE','NV','NH','NJ','NM','NY','NC','OK','OR','PA','RI','SD',
                                                'UT','WV','WY')))

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

CountyCharacteristics <- loadCountyACSData() %>% full_join(loadCountyBEAData(), by="County") %>%
  inner_join(CountyArea, by=c('County'='GEOID')) %>%
  inner_join(loadCountyBLSData(), by='County') %>%
  left_join(loadCountyCDCData(), by='County')

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
rm(states)
rm(States)
rm(CountyCharacteristics)
rm(CountyArea)
