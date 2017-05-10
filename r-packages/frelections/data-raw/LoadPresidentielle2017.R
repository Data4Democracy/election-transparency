library(rvest)
library(stringr)
library(tidyverse)
library(devtools)

PAUSE <- 1.5

subsetUrlVector <- function(v) {
  # v[1:2] # subset for testing
  v # just return v for no subsetting
}

resultsDfList <- list()
turnoutDfList <- list()
resultsIdx <- 1

html <- read_html('http://elections.interieur.gouv.fr/presidentielle-2017/index.html')
deptList <- html_nodes(html, '#listeDpt option')
deptUrls <- html_attr(deptList, 'value')
deptUrls <- deptUrls[deptUrls != '#']
deptUrls <- paste0('http://elections.interieur.gouv.fr/presidentielle-2017/', deptUrls)

deptUrls <- subsetUrlVector(deptUrls)

for (deptUrl in deptUrls) {

  html <- read_html(deptUrl)
  communeLetterList <- html_nodes(html, '.pub-index-communes > div > a')
  communeLetterUrls <- html_attr(communeLetterList, 'href')
  communeLetterUrls <- paste0('http://elections.interieur.gouv.fr/presidentielle-2017/', str_sub(communeLetterUrls, 7))

  communeLetterUrls <- subsetUrlVector(communeLetterUrls)

  for (communeLetterUrl in communeLetterUrls) {

    html <- read_html(communeLetterUrl)
    communeList <- html_nodes(html, '.tableau-communes a')
    communeUrls <- html_attr(communeList, 'href')
    communeUrls <- str_sub(communeUrls, 7)

    communeUrls <- subsetUrlVector(communeUrls)

    letterResultsDfs <- list()
    letterTurnoutDfs <- list()
    communeIdx <- 1

    for (communeUrl in communeUrls) {

      Sys.sleep(PAUSE)

      writeLines(paste0('Processing commune URL: ', communeUrl))

      html <- read_html(paste0('http://elections.interieur.gouv.fr/presidentielle-2017/', communeUrl))

      communeName <- html_nodes(html, '.pub-resultats-entete h3') %>% html_text() %>% .[1]

      round2Table <- html_nodes(html, '.tableau-resultats-listes-ER') %>% .[1]
      round2Names <- html_nodes(round2Table, 'td[style="text-align:left"]') %>% html_text()
      round2Votes <- html_nodes(round2Table, 'td[style="text-align:right"]') %>% html_text() %>%
        gsub(x=., pattern=' ', replacement='') %>% as.integer()
      round2Round <- rep('2', length(round2Names))

      round1Table <- html_nodes(html, '.tableau-resultats-listes-ER') %>% .[2]
      round1Names <- html_nodes(round1Table, 'td[style="text-align:left"]') %>% html_text()
      round1Votes <- html_nodes(round1Table, 'td[style="text-align:right"]') %>% html_text() %>%
        gsub(x=., pattern=' ', replacement='') %>% as.integer()
      round1Round <- rep('1', length(round1Names))

      candidateNames <- c(round2Names, round1Names)
      candidateVotes <- c(round2Votes, round1Votes)
      candidateRound <- c(round2Round, round1Round)

      round2Table <- html_nodes(html, '.tableau-mentions') %>% .[1]
      round2Status <- html_nodes(round2Table, 'td[style="text-align:left"]') %>% html_text()
      round2Count <- html_nodes(round2Table, 'td[style="text-align:right"]') %>% html_text() %>%
        gsub(x=., pattern=' ', replacement='') %>% as.integer()
      round2Round <- rep('2', length(round2Status))

      round1Table <- html_nodes(html, '.tableau-mentions') %>% .[2]
      round1Status <- html_nodes(round1Table, 'td[style="text-align:left"]') %>% html_text()
      round1Count <- html_nodes(round1Table, 'td[style="text-align:right"]') %>% html_text() %>%
        gsub(x=., pattern=' ', replacement='') %>% as.integer()
      round1Round <- rep('1', length(round1Status))

      turnoutStatus <- c(round2Status, round1Status)
      turnoutCount <- c(round2Count, round1Count)
      turnoutRound <- c(round2Round, round1Round)

      communeRow <- tibble(
        Region=str_sub(communeUrl, 1, 3),
        Departement=str_sub(communeUrl, 5, 7),
        CommuneCode=str_sub(communeUrl, 9) %>% gsub(x=., pattern='(.+)\\.html', replacement='\\1'),
        CommuneName=communeName,
        Round=candidateRound,
        Candidate=candidateNames,
        Votes=candidateVotes
      )

      letterResultsDfs[[communeIdx]] <- communeRow

      communeRow <- tibble(
        Region=str_sub(communeUrl, 1, 3),
        Departement=str_sub(communeUrl, 5, 7),
        CommuneCode=str_sub(communeUrl, 9) %>% gsub(x=., pattern='(.+)\\.html', replacement='\\1'),
        CommuneName=communeName,
        Round=turnoutRound,
        Status=turnoutStatus,
        Count=turnoutCount
      )

      letterTurnoutDfs[[communeIdx]] <- communeRow

      communeIdx <- communeIdx + 1

    }

    letterResultsDf <- bind_rows(letterResultsDfs)
    letterTurnoutDf <- bind_rows(letterTurnoutDfs)

    resultsDfList[[resultsIdx]] <- letterResultsDf
    turnoutDfList[[resultsIdx]] <- letterTurnoutDf

    resultsIdx <- resultsIdx + 1

  }

}

source('data-raw/GIS.R')

cleanGeoData <- function(df) {
  df %>%
    filter(!(CommuneName %in% c('Commune de Marseille', 'Commune de Lyon'))) %>%
    filter(!grepl(x=CommuneName, pattern='Commune de Marseille Secteur.+')) %>%
    mutate(
      # fix the commune of Saint-Lucien in Normandy, which changed to a separate commune on 1/1/17, but isn't in our shapefiles...
      CommuneCodeINSEE=ifelse(CommuneCode=='076601', '76676', CommuneCodeINSEE),
      RegionNom=ifelse(CommuneCode=='076601', 'NORMANDIE', RegionNom),
      DepartementNom=ifelse(CommuneCode=='076601', 'SEINE-MARITIME', DepartementNom)
    ) %>%
    mutate(RegionNom=ifelse(Region=='000', 'OUTRE-MER', RegionNom)) %>%
    mutate(DepartementNom=case_when(
      .$Departement=='975' ~ 'Saint-Pierre-et-Miquelon',
      .$Departement=='977' ~ 'Saint-Barthélemy',
      .$Departement=='987' ~ 'Polynésie française',
      .$Departement=='988' ~ 'Nouvelle-Calédonie',
      TRUE ~ .$DepartementNom
    ))
}

Turnout2017 <- bind_rows(turnoutDfList) %>%
  spread(Status, Count) %>%
  left_join(communeData, by='CommuneCode') %>%
  select(Region, RegionNom, Departement, DepartementNom, CommuneCode, CommuneName, CommuneCodeINSEE, CommuneNomINSEE,
         Round, Abstentions, Blancs, Exprimés, Inscrits, Nuls, Votants) %>%
  cleanGeoData()

Results2017 <- bind_rows(resultsDfList) %>%
  left_join(communeData, by='CommuneCode') %>%
  select(Region, RegionNom, Departement, DepartementNom, CommuneCode, CommuneName, CommuneCodeINSEE, CommuneNomINSEE,
         Round, Candidate, Votes) %>%
  cleanGeoData()

use_data(Turnout2017, Results2017)
