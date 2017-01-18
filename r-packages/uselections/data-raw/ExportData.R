# Script to export dataframe to package

library(dplyr)
library(readr)
library(rgdal)

dfs <- list(
  uselections::loadAlaska(),
  uselections::loadArizona(),
  uselections::loadCalifornia(),
  uselections::loadColorado(),
  uselections::loadConnecticut(),
  uselections::loadDelaware(),
  uselections::loadDC(),
  uselections::loadFlorida(),
  uselections::loadIowa(),
  uselections::loadKansas(),
  uselections::loadLouisiana(),
  uselections::loadMaine(),
  uselections::loadMaryland(),
  uselections::loadMassachusetts(),
  uselections::loadNebraska(),
  uselections::loadNevada(),
  uselections::loadNewHampshire(),
  uselections::loadNewJersey(),
  uselections::loadNewMexico(),
  uselections::loadNewYork(),
  uselections::loadNorthCarolina(),
  uselections::loadOklahoma(),
  uselections::loadOregon(),
  uselections::loadPennsylvania(),
  uselections::loadRhodeIsland(),
  uselections::loadSouthDakota(),
  uselections::loadWestVirginia(),
  uselections::loadWyoming()
)


PartyRegistration <- select(mutate(bind_rows(dfs), State=substr(County, 1, 2)), State, County, Year, Month, D, G, L, N, O, R)

df <- PartyRegistration %>%
  mutate_each(funs(replace(., which(is.na(.)), 0))) %>%
  mutate(Total=D+G+L+N+O+R, dPct=D/Total, rPct=R/Total, leanD=D/R, leanR=R/D, unaffiliatedPct=N/Total, otherPct=O/Total,
         dDRPct=D/(D+R), rDRPct=R/(D+R)) %>%
  select(-D, -G, -L, -N, -O, -R, -State)

PartyRegistration <- PartyRegistration %>% inner_join(df, by=c("County"="County", "Year"="Year", "Month"="Month"))

countyData <- uselections::getCountyData() %>% select(STATEFP, GEOID, NAME) %>%
  mutate_each("as.character") %>%
  mutate(NAME=recode(GEOID, "24510"="Baltimore City", "24005"="Baltimore County", .default=NAME)) %>%
  mutate(NAME=recode(GEOID, "29510"="St. Louis City", "29189"="St. Louis County", .default=NAME)) %>%
  inner_join(read_csv("data-raw/States.txt", col_names=paste0('X', seq(3)), col_types='ccc'), by=c("STATEFP"="X2")) %>%
  select(CountyName=NAME, StateName=X1, StateAbbr=X3, County=GEOID)

PartyRegistration <- PartyRegistration %>%
  inner_join(countyData, by=c("County"="County"))

PresidentialElectionResults2016 <- load2016PresidentialResults() %>%
  inner_join(countyData, by=c("County"="County")) %>%
  mutate(dPct=clinton/totalvotes, rPct=trump/totalvotes, leanD=clinton/trump, leanR=trump/clinton, otherPct=other/totalvotes,
         dDRPct=clinton/(clinton+trump), rDRPct=trump/(clinton+trump), State=substr(County, 1, 2))

devtools::use_data(PartyRegistration, overwrite=TRUE)
devtools::use_data(PresidentialElectionResults2016, overwrite=TRUE)

rm(PartyRegistration)
rm(PresidentialElectionResults2016)
rm(countyData)
rm(df)
rm(dfs)
