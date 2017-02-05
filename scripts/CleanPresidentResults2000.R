library(dplyr)
library(stringr)

#Raw data: http://www.american.edu/spa/ccps/Data-Sets.cfm
raw <- read.csv('2000PresidentialElectionRaw.csv',stringsAsFactors = F)
match <- read.csv('StateCountyMapping.csv',stringsAsFactors = F)
names(raw) <- tolower(names(raw))

#Replace periods with 0
data <- raw %>%
  mutate(nader = ifelse(nader=='.',0,nader)) %>%
  mutate(phillips = ifelse(phillips=='.',0,phillips)) %>%
  mutate(writeins = ifelse(writeins=='.',0,writeins)) %>%
  mutate(hagelin = ifelse(hagelin=='.',0,hagelin)) %>%
  mutate(mcreynolds = ifelse(mcreynolds=='.',0,mcreynolds)) %>%
  mutate(harris = ifelse(harris=='.',0,harris)) %>%
  mutate(dodge = ifelse(dodge=='.',0,dodge)) %>%
  mutate(nota = ifelse(nota=='.',0,nota)) %>%
  mutate(moorehead = ifelse(moorehead=='.',0,moorehead)) %>%
  mutate(brown = ifelse(brown=='.',0,brown)) %>%
  mutate(venson = ifelse(venson=='.',0,venson)) %>%
  mutate(youngkeit = ifelse(youngkeit=='.',0,youngkeit)) %>%
  mutate(lane = ifelse(lane=='.',0,lane))

#Convert columns to numeric
for(i in c(4:24)) {
  data[,i] <- as.numeric(data[,i])
}

#Create other and totalvotes columns, remove other presidential candidates except Nader
data <- data %>%
  mutate(other = rowSums(.[11,13:24],na.rm=T)) %>%
  select(cid,
         state,
         county,
         bush,
         gore,
         nader,
         browne,
         other) %>%
  mutate(totalvotes = rowSums(.[4:7]))

#Create percentage and lean columns
data <- data %>%
  mutate(dPct = gore/totalvotes) %>%
  mutate(rPct = bush/totalvotes) %>%
  mutate(otherPct = other/totalvotes) %>%
  mutate(dDRPct = gore/(gore+bush)) %>%
  mutate(rDRPct = bush/(gore+bush)) %>%
  mutate(leanD = gore/bush) %>%
  mutate(leanR = bush/gore)

#Clean and join counties
data <- data %>% mutate(state = gsub('\xa0',' ',state)) %>%
  mutate(county = gsub('\xa0',' ',county)) %>%
  mutate(county = gsub('St.','Saint',county,fixed=T))

data <- data %>%
  mutate(county = ifelse(grepl('(City)|(County)',data$county) | state %in% c('Louisiana','District of Columbia','Alaska'),county,paste(county,'County'))) %>%
  mutate(county = ifelse(state=='Louisiana',paste(county,'Parish'),county))

#Individual fixes
data <- data %>%
  mutate(county = ifelse(state=='Florida' & county=='Dade County','Miami-Dade County',county)) %>%
  mutate(county = ifelse(county=='Dekalb County','DeKalb County',county)) %>%
  mutate(county = ifelse(county=='Desoto County','DeSoto County',county)) %>%
  mutate(county = ifelse(county=='DeWitt County','De Witt County',county)) %>%
  mutate(county = ifelse(county=='LaSalle County','La Salle County',county)) %>%
  mutate(county = ifelse(county=='DeSoto Parish','De Soto Parish',county)) %>%
  mutate(county = ifelse(county=='E Baton Rouge Parish','East Baton Rouge Parish',county)) %>%
  mutate(county = ifelse(county=='LaSalle Parish','La Salle Parish',county)) %>%
  mutate(county = ifelse(county=='James City','James City County',county)) %>%
  mutate(county = ifelse(county=='Lac Qui Parle County','Lac qui Parle County',county)) %>%
  mutate(county = ifelse(county=='YaloBusha County','Yalobusha County',county)) %>%
  mutate(county = ifelse(county=='Ste. Genevieve County','Sainte Genevieve County',county)) %>%
  mutate(county = ifelse(county=='Lewis & Clark County','Lewis and Clark County',county)) %>%
  mutate(county = ifelse(county=='De Baca County','DeBaca County',county)) %>%
  mutate(county = ifelse(county=='LeFlore County','Le Flore County',county)) %>%
  mutate(county = ifelse(county=='Dewitt County','DeWitt County',county))

#Virginia fixes
data <- data %>%
  mutate(county = ifelse(state=='Virginia' & county=='Charles City','Charles City County',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Alexandria County','Alexandria City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Bristol County','Bristol City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Buena Vista County','Buena Vista City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Charlottesville County','Charlottesville City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Chesapeake County','Chesapeake City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Clifton Forge County','Alleghany County',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Colonial Heights County','Colonial Heights City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Covington County','Covington City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Danville County','Danville City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Emporia County','Emporia City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Falls Church County','Falls Church City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Fredericksburg County','Fredericksburg City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Galax County','Galax City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Hampton County','Hampton City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Harrisonburg County','Harrisonburg City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Hopewell County','Hopewell City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Lexington County','Lexington City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Lynchburg County','Lynchburg City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Manassas County','Manassas City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Manassas Park County','Manassas Park City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Martinsville County','Martinsville City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Newport News County','Newport News City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Norfolk County','Norfolk City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Norton County','Norton City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Petersburg County','Petersburg City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Poquoson County','Poquoson City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Portsmouth County','Portsmouth City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Radford County','Radford City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Salem County','Salem City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Staunton County','Staunton City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Suffolk County','Suffolk City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Virginia Beach County','Virginia Beach City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Waynesboro County','Waynesboro City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Williamsburg County','Williamsburg City',county)) %>%
  mutate(county = ifelse(state=='Virginia' & county=='Winchester County','Winchester City',county))

#Clean AK district names
match <- match %>%
  mutate(CountyName = ifelse(StateAbbr == 'AK',str_extract(CountyName,"(District )[0-9]+"),CountyName))

#Join data with FIPS codes
data <- left_join(data,match,by=c('state'='StateName','county'='CountyName'))

#Final edits, write csv
data <- data %>% mutate(StateAbbr = ifelse(state=='Hawaii','HI',StateAbbr))

names(data)[3] <- 'CountyName'
names(data)[2] <- 'StateName'

data <- data %>% select(County,
                        bush,
                        gore,
                        nader,
                        browne,
                        other,
                        totalvotes,
                        CountyName,
                        StateName,
                        StateAbbr,
                        dPct,
                        rPct,
                        leanD,
                        leanR,
                        otherPct,
                        dDRPct,
                        rDRPct)

write.csv(data,'PresidentialElectionResults2000.csv',row.names=F)
