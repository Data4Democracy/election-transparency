#' Load 2016 presidential election results from the Pettigrew dataverse dataset at Harvard, augmented
#' by data from some states directly from state sources.
#' @importFrom readr read_csv
#' @import dplyr
#' @importFrom openxlsx read.xlsx
#' @importFrom stringr str_pad
#' @export
load2016PresidentialResults <- function() {

  df <- read_csv("https://query.data.world/s/eu9r2968zroqabxcbpbmwj0eb", col_types = 'cccciiiiiin')

  df2 <- df %>%
    filter(!(state %in% c('MS', 'ME', 'AK', 'KS'))) %>%
    mutate(fipscode=str_pad(gsub(x=fipscode, pattern="([0-9])\\.([0-9]+)e.+", replacement='\\1\\2'), 5, 'right', '0')) %>%
    mutate(fipscode=ifelse(state %in% c('AL','AZ', 'AR', 'CA','CO'), paste0('0', fipscode), fipscode)) %>%
    mutate(County=substr(fipscode, 1, 5)) %>%
    mutate(County=ifelse(state=='CT', paste0('0', substr(County, 1, 4)), County)) %>%
    mutate(County=ifelse(state=='DC', '11001', County)) %>%
    mutate(County=ifelse(state=='MO', ifelse(jurisdiction=='St. Louis City', '29510', substr(fipscode, 1, 5)), County)) %>% # St. Louis is an independent city in Missouri.
    mutate(County=ifelse(County=='46113', '46102', County)) %>% # miscode in the Harvard data
    mutate(County=ifelse(County=='29380', '29085', County)) %>% # Missouri tabulates Kansas City election results separately.  Most of KC is in Jackson County.  Best we can do.
    select(County, clinton, trump, johnson, stein, other, totalvotes) %>%
    mutate(trump=ifelse(County=='04027', 25165, trump), totalvotes=ifelse(County=='04027', 52416, totalvotes)) %>% # error in Harvard compilation
    as_tibble() # take out when done

  # Kansas is not in the harvard dataset.  Loading from spreadsheet converted from SOS PDF obtained from DKE

  ksCountyInfo <- getCountyNameFIPSMapping('20') %>%
    mutate(CountyName=toupper(CountyName))

  ks <- read.xlsx("data-raw/ks/2016 Kansas county-level election results.xlsx", colNames=FALSE, startRow=3) %>%
    mutate_each(funs(replace(., is.na(.), 0)), -X1) %>%
    mutate_each("as.integer", -X1) %>%
    mutate(clinton=X2, stein=X3, johnson=X4, trump=X5, other=X6+X7+X8+X9+X10+X11+X12+X13+X14+X15+X16+X17+X18+X19+X20,
           totalvotes=clinton+johnson+stein+trump+other, CountyName=trimws(X1)) %>%
    select(CountyName, clinton, trump, johnson, stein, other, totalvotes) %>%
    inner_join(ksCountyInfo, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  # Mississippi is not in the harvard dataset...loading from spreadsheet created by hand from scanned PDFs of county returns on state's website

  msCountyInfo <- getCountyNameFIPSMapping('28')
  ms <- read.xlsx("data-raw/ms/Results.xlsx", colNames=TRUE) %>%
    mutate(other=Castle+De.La.Fuente+Hedges, totalvotes=clinton+johnson+stein+trump+other) %>%
    select(CountyName, clinton, trump, johnson, stein, other, totalvotes) %>%
    inner_join(msCountyInfo, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  # Maine data in the harvard dataset are at a town/township level that is not mappable to any Census place list.  So we grab the data from the state's
  # site and re-do.

  meCountyNames <- c("Androscoggin","Aroostook","Cumberland","Franklin","Hancock","Kennebec","Knox",
                     "Lincoln","Oxford","Penobscot","Piscataquis","Sagadahoc","Somerset","Waldo","Washington","York")
  names(meCountyNames) <- c("AND","ARO","CUM","FRA","HAN","KEN","KNO","LIN","OXF","PEN","PIS","SAG","SOM","WAL","WAS","YOR")

  me <- read.xlsx("data-raw/me/president.xlsx", colNames=FALSE, startRow=3) %>%
    select(-X2) %>%
    filter(!is.na(X1))
  me$X1 <- meCountyNames[me$X1]

  meCountyInfo <- getCountyNameFIPSMapping('23')
  me <- me %>%
    rename(CountyName=X1, clinton=X3, johnson=X4, stein=X5, trump=X6) %>%
    mutate(other=X7+X8+X9+X10, totalvotes=clinton+johnson+stein+trump+other) %>%
    select(CountyName, clinton, trump, johnson, stein, other, totalvotes) %>%
    inner_join(meCountyInfo, by=c("CountyName"="CountyName")) %>%
    select(-CountyName) %>%
    as_tibble()

  # Alaska data in Harvard dataset are by district, not Borough.  Have to redo.

  akRaw <- read_lines("http://www.elections.alaska.gov/results/16GENR/data/resultsbyprct.txt")
  akLines <- akRaw[grepl(x=akRaw, pattern='Clinton|Trump|Castle|Fuente|Johnson|Stein')]

  precinctLines <- akLines[!grepl(x=akLines, pattern='HD99|District')]
  districtLines <- akLines[grepl(x=akLines, pattern='District')]

  df <- data.frame(precinctLines, stringsAsFactors=FALSE) %>%
    separate(precinctLines, into=paste0('X', 1:8), sep=',') %>% as_tibble() %>%
    mutate(Precinct=gsub(x=X1, pattern="\"([0-9\\-]+) .+", replacement="\\1"),
           Candidate=tolower(gsub(x=X3, pattern="\"([A-Za-z ]+)$", replacement="\\1")),
           Votes=as.integer(X7)) %>%
    select(Precinct, Candidate, Votes) %>%
    group_by(Precinct, Candidate) %>%
    summarize(Votes=sum(Votes)) %>%
    spread(Candidate, Votes, fill=0) %>%
    mutate(District=gsub(x=Precinct, pattern="([0-9]+)-([0-9]+)", replacement="\\1"))

  PrecinctVotes <- df %>% select(-District)

  # Per agreement on #election-transparency Slack channel on Jan 16...we allocate district-level counts of absentee etc ballots by the proportion
  # of votes for each precinct within that district

  PrecinctAllocation <- df %>%
    mutate(total=castle+clinton+`de la fuente`+johnson+stein+trump) %>%
    group_by(District, Precinct) %>%
    summarize(total=sum(total)) %>%
    mutate(alloc=total/sum(total)) %>%
    select(-total)

  df <- data.frame(districtLines, stringsAsFactors=FALSE) %>%
    separate(districtLines, into=paste0('X', 1:8), sep=',') %>% as_tibble() %>%
    mutate(District=gsub(x=X1, pattern="\"District ([0-9\\-]+) .+", replacement="\\1"),
         Candidate=tolower(gsub(x=X3, pattern="\"([A-Za-z ]+)$", replacement="\\1")),
         Votes=as.integer(X7)) %>%
    mutate(District=str_pad(District, 2, side="left", pad="0")) %>%
    select(District, Candidate, Votes) %>%
    group_by(District, Candidate) %>%
    summarize(Votes=sum(Votes)) %>%
    ungroup() %>%
    spread(Candidate, Votes, fill=0) %>%
    inner_join(PrecinctAllocation, by=c("District"="District")) %>%
    mutate(castle=round(castle*alloc), clinton=round(clinton*alloc), `de la fuente`=round(`de la fuente`*alloc), johnson=round(johnson*alloc),
           stein=round(stein*alloc), trump=round(trump*alloc)) %>%
    select(Precinct, castle, clinton, `de la fuente`, johnson, stein, trump) %>%
    mutate_each("as.integer", -Precinct)

  PrecinctVotes <- bind_rows(PrecinctVotes, df) %>%
    group_by(Precinct) %>%
    summarize_each("sum")

  precinctCountyMap <- getAlaskaPrecinctCountyMapping()

  ak <- PrecinctVotes  %>%
    inner_join(precinctCountyMap, by=c("Precinct"="Precinct")) %>%
    mutate(County=paste0('02', County)) %>%
    select(-Precinct) %>%
    group_by(County) %>%
    summarize_each(funs(sum(., na.rm=TRUE))) %>%
    ungroup() %>%
    mutate_each("as.integer", -County) %>%
    mutate(other=castle + `de la fuente`, totalvotes=clinton+trump+stein+johnson+other) %>%
    select(County, clinton, trump, johnson, stein, other, totalvotes)

  bind_rows(df2, ks, ms, me, ak) %>%
    group_by(County) %>%
    summarize_each("sum") %>%
    mutate_each("as.integer", -County)

}
