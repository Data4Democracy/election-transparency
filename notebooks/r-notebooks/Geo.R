library(dplyr)
library(tibble)
library(ggplot2)
library(scales)
library(sp)
library(rgdal, quietly=TRUE)
library(ggrepel)

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
    
    county_shp <- readOGR("shapefiles/cb_2015_us_county_500k/", "cb_2015_us_county_500k", verbose=FALSE) %>% subset(STATEFP == stateFIPS)
    centroids <- coordinates(county_shp)
    county_shp@data$INTPTLON <- centroids[,1]
    county_shp@data$INTPTLAT <- centroids[,2]
    county_shp_data <- county_shp@data
    
    county_shp@data$id <- rownames(county_shp@data)
    county_shp_df <- fortify(county_shp) %>%
      inner_join(county_shp@data, by=c("id"="id")) %>%
      mutate(GEOID=as.character(GEOID))  %>%
      inner_join(df, by=c("GEOID"=countyFIPSColumnName))
    
    labelDf <- county_shp@data %>%
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
      ret <- ret + geom_text_repel(data=labelDf, mapping=aes(x=INTPTLON, y=INTPTLAT, label=NAME, group=NAME), size=3.5,
                                   min.segment.length=unit(.2, 'cm'), label.padding=unit(.1, 'cm'))
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
