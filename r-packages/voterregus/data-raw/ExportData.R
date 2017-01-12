# Script to export dataframe to package

library(dplyr)
library(readr)
library(rgdal)

dfs <- list(
  voterregus::loadAlaska(),
  voterregus::loadArizona(),
  voterregus::loadCalifornia(),
  voterregus::loadColorado(),
  voterregus::loadConnecticut(),
  voterregus::loadDelaware(),
  voterregus::loadDC(),
  voterregus::loadFlorida(),
  voterregus::loadIowa(),
  voterregus::loadKansas(),
  voterregus::loadLouisiana(),
  voterregus::loadMaine(),
  voterregus::loadMaryland(),
  voterregus::loadMassachusetts(),
  voterregus::loadNebraska(),
  voterregus::loadNevada(),
  voterregus::loadNewHampshire(),
  voterregus::loadNewJersey(),
  voterregus::loadNewMexico(),
  voterregus::loadNewYork(),
  voterregus::loadNorthCarolina(),
  voterregus::loadOklahoma(),
  voterregus::loadOregon(),
  voterregus::loadPennsylvania(),
  voterregus::loadRhodeIsland(),
  voterregus::loadSouthDakota(),
  voterregus::loadWestVirginia(),
  voterregus::loadWyoming()
)

PartyRegistration <- select(mutate(bind_rows(dfs), State=substr(County, 1, 2)), State, County, D, G, L, N, O, R)

df <- PartyRegistration %>%
  mutate_each(funs(replace(., which(is.na(.)), 0))) %>%
  mutate(Total=D+G+L+N+O+R, dPct=D/Total, rPct=R/Total, leanD=D/R, leanR=R/D, unaffiliatedPct=N/Total, otherPct=O/Total) %>%
  select(-D, -G, -L, -N, -O, -R, -State)

PartyRegistration <- PartyRegistration %>% inner_join(df, by=c("County"="County"))

countyData <- readOGR("data-raw/tl_2014_us_county/", "tl_2014_us_county")@data %>% select(STATEFP, GEOID, NAME) %>%
  mutate_each("as.character") %>%
  inner_join(read_csv("data-raw/States.txt", col_names=FALSE), by=c("STATEFP"="X2")) %>%
  select(CountyName=NAME, StateName=X1, StateAbbr=X3, County=GEOID)

PartyRegistration <- PartyRegistration %>%
  inner_join(countyData, by=c("County"="County"))

devtools::use_data(PartyRegistration, overwrite=TRUE)
