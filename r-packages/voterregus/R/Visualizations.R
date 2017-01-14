#' Produce a red/blue gradient choropleth of the state
#' @param state the two-letter FIPS abbrevation for the state
#' @param labels whether to draw the county names on the map (default is FALSE)
#' @import dplyr
#' @import ggplot2
#' @import scales
#' @importFrom rgeos gIntersection
#' @import sp
#' @export
stateDemocraticRepublicanRegistrationChoropleth <- function(state, labels=FALSE) {

  df <- PartyRegistration %>% filter(StateAbbr==state)

  ret <- NULL

  if (nrow(df) > 0) {

    stateFIPS <- df[1, 'State'] %>% unlist()
    stateName <- df[1, 'StateName'] %>% unlist()

    county_shp = readOGR("data-raw/tl_2016_us_county/", "tl_2016_us_county") %>% subset(STATEFP == stateFIPS)
    county_shp_data <- county_shp@data
    state_shp = readOGR("data-raw/cb_2015_us_state_500k/", "cb_2015_us_state_500k") %>% subset(STATEFP == stateFIPS)
    county_shp <- gIntersection(state_shp, county_shp, byid=TRUE, id=rownames(county_shp_data))
    county_shp <- sp::SpatialPolygonsDataFrame(county_shp, county_shp_data)

    county_shp@data$id <- rownames(county_shp@data)
    county_shp_df <- fortify(county_shp) %>%
      inner_join(county_shp@data, by=c("id"="id")) %>%
      mutate(GEOID=as.character(GEOID))  %>%
      inner_join(df, by=c("GEOID"="County"))

    labelDf <- county_shp@data %>%
      mutate(INTPTLON=as.numeric(as.character(INTPTLON)), INTPTLAT=as.numeric(as.character(INTPTLAT))) %>%
      mutate(NAME=as.character(NAME), GEOID=as.character(GEOID)) %>%
      mutate(NAME=recode(GEOID, "24510"="Baltimore City", "24005"="Baltimore County", .default=NAME))

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
      panel.margin = unit(c(0,0,0,0), "lines"),
      plot.margin = unit(c(0,0,0,0), "lines")
    )

    ret <- ggplot(data=county_shp_df, aes(x=long, y=lat, group=group)) +
      geom_polygon(aes(fill=rDRPct)) +
      geom_path(color="grey")

    if (labels) {
      ret <- ret + geom_text(data=labelDf, aes(x=INTPTLON, y=INTPTLAT, label=NAME, group=NAME), size=3.5)
    }

    ret <- ret +
      scale_fill_gradient2(limits=c(0, 1),
                           breaks=c(0, .25, .5, .75, 1), labels=c('100%', '75%', 'Even', '75%', '100%'),
                           low="#0099F7", high="#F11712", midpoint=.5, guide = "colourbar") +
      labs(fill='', title=paste0("2016 Voter Registration Party Affiliation for ", stateName)) +
      coord_map(projection="mercator") +
      theme_bare

  }

  ret

}
