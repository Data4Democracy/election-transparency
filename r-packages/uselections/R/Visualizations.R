#' Produce a red/blue gradient choropleth of the state based on the percentage of republican (red)
#' versus democratic (blue) registered voters in each county
#' @param state the two-letter FIPS abbrevation for the state
#' @param labels whether to draw the county names on the map (default is FALSE)
#' @import dplyr
#' @export
stateDemocraticRepublicanRegistrationChoropleth <- function(state, labels=FALSE) {
  pr <- PartyRegistration %>% filter(Year==2016 & Month==11)
  stateDemocraticRepublicanChoropleth(pr, state, labels, RDRatioColumnName='rDRPct',
                                      caption='Percent of voters registered as Republican (Red) versus Democratic (Blue) among voters affiliated with those two parties',
                                      titleFunction=function(stateName) {
                                        paste0("2016 Voter Registration Party Affiliation for ", stateName)
                                      })
}

#' Produce a red/blue gradient choropleth of the state based upon the percentage of Trump vs Clinton votes
#' @import dplyr
#' @importFrom readr read_csv
#' @export
stateDemocraticRepublican2016ResultsChoropleth <- function(state, labels=FALSE) {
    stateDemocraticRepublicanChoropleth(PresidentialElectionResults2016, state, labels, RDRatioColumnName='rDRPct',
      caption='Percent of votes for Republican candidate (Red) versus Democratic candidate (Blue) (excluding third-party and write-in votes)',
      titleFunction=function(stateName) {
      paste0("2016 Presidential Election Results for ", stateName)
    })
}

#' Produce a red/blue gradient choropleth of the state
#' @param state the two-letter FIPS abbrevation for the state
#' @param labels whether to draw the county names on the map (default is FALSE)
#' @param stateFIPSColumnName the name of the column in the provided data frame that contains the numeric FIPS code for the state (default=State)
#' @param stateNameColumnName the name of the column in the provided data frame that contains the full state name (default=StateName)
#' @param countyFIPSColumnName the name of the column in the provided data frame that contains the 5-digit FIPS code for each county (default=County)
#' @param caption a string containing the caption for the map (default is an empty string / no caption)
#' @param titleFunction a function, taking the name of the state as a parameter, that returns the string for the title (default is empty string / no title)
#' @param RDRatioColumnName the name of the column in the provided data frame that contains the ratio (R/(D+R)) to be displayed on the choropleth
#' @import dplyr
#' @import tibble
#' @import ggplot2
#' @import scales
#' @importFrom rgeos gIntersection gSimplify
#' @import sp
#' @export
stateDemocraticRepublicanChoropleth <- function(countyLevelDf, state, labels=FALSE,
                                                stateFIPSColumnName='State', stateNameColumnName='StateName',
                                                stateAbbrColumnName='StateAbbr', countyFIPSColumnName='County',
                                                caption='',
                                                titleFunction=function(stateName) {''},
                                                RDRatioColumnName) {

  df <- countyLevelDf %>% filter_(.dots=paste0(stateAbbrColumnName, "=='", state, "'"))
  ret <- NULL

  if (nrow(df) > 0) {

    stateFIPS <- df[1, stateFIPSColumnName] %>% unlist()
    stateName <- df[1, stateNameColumnName] %>% unlist()

    county_shp = readOGR("data-raw/tl_2016_us_county/", "tl_2016_us_county") %>% subset(STATEFP == stateFIPS)
    county_shp_data <- county_shp@data
    state_shp = readOGR("data-raw/cb_2015_us_state_500k/", "cb_2015_us_state_500k") %>% subset(STATEFP == stateFIPS)
    if (!(state %in% c('CO'))) {
      tolerance <- ifelse(state %in% c('NJ', 'GA', 'VA'), .0001, ifelse(state=='AK', .0125, .01))
      county_shp <- gSimplify(county_shp, tolerance)
    }
    county_shp <- gIntersection(state_shp, county_shp, byid=TRUE, id=rownames(county_shp_data))
    county_shp <- sp::SpatialPolygonsDataFrame(county_shp, county_shp_data)

    county_shp@data$id <- rownames(county_shp@data)
    county_shp_df <- fortify(county_shp) %>%
      inner_join(county_shp@data, by=c("id"="id")) %>%
      mutate(GEOID=as.character(GEOID))  %>%
      inner_join(df, by=c("GEOID"=countyFIPSColumnName))

    labelDf <- county_shp@data %>%
      mutate(INTPTLON=as.numeric(as.character(INTPTLON)), INTPTLAT=as.numeric(as.character(INTPTLAT))) %>%
      mutate(NAME=as.character(NAME), GEOID=as.character(GEOID)) %>%
      mutate(NAME=recode(GEOID, "24510"="Baltimore City", "24005"="Baltimore County", .default=NAME)) %>%
      mutate(NAME=recode(GEOID, "29510"="St. Louis City", "29189"="St. Louis County", .default=NAME))

    theme_bare <- theme(
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.background = element_blank(),
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.title = element_text(hjust = 0.5),
      plot.caption = element_text(hjust = 0.5),
      legend.position = "bottom",
      legend.key.width = unit(2, "cm"),
      plot.margin = unit(c(0,1,0,0), "lines")
    )

    # adjustment for Alaska (and would work on any state that stradles 180* of longitude...)
    county_shp_df <- county_shp_df %>%
      mutate(long=ifelse(long > 0, -180 - (180-long), long))

    ret <- ggplot(data=county_shp_df, aes(x=long, y=lat, group=group)) +
      geom_polygon(aes_string(fill=RDRatioColumnName)) +
      geom_path(color="grey")

    if (labels) {
      ret <- ret + geom_text(data=labelDf, aes(x=INTPTLON, y=INTPTLAT, label=NAME, group=NAME), size=3.5)
    }

    titleString <- do.call(titleFunction, list(stateName))

    ret <- ret +
      scale_fill_gradient2(limits=c(0, 1),
                           breaks=c(0, .25, .5, .75, 1), labels=c('Dem 100%', '75%', 'Even', '75%', '100% Rep'),
                           low="#0099F7", high="#F11712", midpoint=.5, guide = "colourbar") +
      labs(fill='', title=titleString, caption=caption) +
      coord_map(projection="mercator") + theme_bare

  }

  ret

}
