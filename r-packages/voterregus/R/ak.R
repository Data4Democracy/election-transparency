#' @importFrom sp CRS spTransform
#' @importFrom rgdal readOGR
#' @importFrom rgeos gIntersection gArea
#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @import dplyr
#' @import tidyr
#' @export
loadAlaska <- function() {

  county_shp = readOGR("data-raw/tl_2014_us_county/", "tl_2014_us_county") %>% subset(.$STATEFP == '02')
  precinct_shp <- readOGR("data-raw/ak/2013-SW-Proc-Shape-files/", "2013-SW-Proc-Shape-files")

  crs <- CRS("+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")

  boroughList <- as.list(as.character(county_shp@data$COUNTYFP))
  boroughShapefileList <- lapply(boroughList, function(fipscode) {spTransform(subset(county_shp, county_shp$COUNTYFP == fipscode), crs)})
  precinctList <- as.list(as.character(precinct_shp@data$DISTRICT))
  precinctShapefileList <- lapply(precinctList, function(districtCode) {spTransform(subset(precinct_shp, precinct_shp$DISTRICT == districtCode), crs)})

  matchedBoroughs <- character()
  precincts <- character()

  for (ps in precinctShapefileList) {
    maxArea <- 0.0
    bestMatch <- NA
    bestMatchName <- NA
    for (bs in boroughShapefileList) {
      i <- gIntersection(bs, ps)
      if (!is.null(i)) {
        a <- gArea(i) / 1000000
        if (a > maxArea) {
          if (maxArea >= 5) {
            precinctArea <- gArea(ps) / 1000000
            writeLines(paste0("Precinct ", gsub("[\r\n]", "", ps$NAME), " also matched borough ", bestMatchName, " with area of ", maxArea,
                              " out of a total precinct area of ", precinctArea, " square km (", 100*maxArea/precinctArea, "%)"))
          }
          maxArea <- a
          bestMatch <- as.character(bs$COUNTYFP)
          bestMatchName <- as.character(bs$NAMELSAD)
        }
      }
    }
    writeLines(paste0("Matched precinct ", gsub("[\r\n]", "", ps$NAME), " with borough ", bestMatch, "=", bestMatchName))
    matchedBoroughs <- c(matchedBoroughs, bestMatch)
    precincts <- c(precincts, as.character(ps$DISTRICT))
  }

  precinctCountyMap <- data.frame(Precinct=precincts, County=matchedBoroughs, stringsAsFactors=FALSE)

  page <- read_html("http://elections.alaska.gov/statistics/2016/OCT/VOTERS%20Party_PostRegistrationDeadline.htm")
  tables <- page %>% html_nodes("table") %>% html_table(fill=TRUE) %>% tail(-2) %>% head(-1)
  tables <- tables[seq(1, length(tables), by=2)]

  tables <- lapply(tables, function(df) {
    df <- df %>% head(-2) %>% tail(-2) %>%
      select(X1, X5:X16) %>%
      mutate_each("as.integer", -X1) %>%
      mutate(O=X5+X11+X13+X14+X15+X16, N=X9+X10) %>%
      select(Precinct=X1, D=X6, L=X7, R=X8, G=X12, N, O) %>%
      mutate(Precinct=gsub(x=Precinct, pattern="([0-9\\-]+) .+", replacement="\\1"))
    df
  })

  df <- bind_rows(tables) %>%
    inner_join(precinctCountyMap, by=c("Precinct"="Precinct")) %>%
    mutate(County=paste0('02', County)) %>%
    select(-Precinct) %>%
    group_by(County) %>%
    summarize_each(funs(sum(., na.rm=TRUE)))

  df

}
