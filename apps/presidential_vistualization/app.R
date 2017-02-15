# Data Vis for Presidential Elections

library(shinydashboard)
library(shiny)
library(leaflet)
library(rgdal)
library(gpclib)
library(maptools)
library(R6)
library(raster)
library(broom)
library(scales)
library(reshape2)
library(tidyverse)
gpclibPermit()


# elections <-list(
#   'Election_2000' = read_csv('https://query.data.world/s/404aq0u4n98hmozughp08npg1') %>% select(County, CountyName, StateName, bush, gore, nader, browne, other),
#   'Election_2004' = read_csv('https://query.data.world/s/6mr92w4p92rem4bpbs1ggzcui') %>% select(County, CountyName, StateName, bush, kerry, other),
#   'Election_2008' = read_csv('https://query.data.world/s/8pz64y5pglv8dt6umysffgahh') %>% select(County, CountyName, StateName, mccain, obama, other),
#   'Election_2012' = read_csv('https://query.data.world/s/29sed01wkb9ljmgg0kgj3ztop') %>% select(County, CountyName, StateName, romney, obama, johnson, stein, other),
#   'Election_2016' = read_csv('https://query.data.world/s/dmjcapenh4fg8y7chl5oqgjto') %>% select(County, CountyName, StateName, trump, clinton, johnson, stein, other)
# )
elections <-list(
  'Election_2000' = read_csv('./elections/Election_2000.csv'),
  'Election_2004' = read_csv('./elections/Election_2004.csv'),
  'Election_2008' = read_csv('./elections/Election_2008.csv'),
  'Election_2012' = read_csv('./elections/Election_2012.csv'),
  'Election_2016' = read_csv('./elections/Election_2016.csv')
)

elections[[4]]<-mutate(elections[[4]], CountyName= paste(CountyName, 'County'))
elections[[5]]<-mutate(elections[[5]], CountyName=paste(CountyName, 'County'))

# Function for capitalizing names.
proper<-function(x) paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))

# 2012 election sees FIPS as integer and not as character, have to work around to coerce leading 0s.
FIPS<-data_frame(FIPS=elections[[5]]$County, CountyName=paste(proper(elections[[5]]$CountyName),proper(elections[[5]]$StateName)))
elections[[4]]$County <- sapply(paste(proper(elections[[4]]$CountyName),proper(elections[[4]]$StateName)), function(i){
  FIPS$FIPS[which(i == FIPS$CountyName)[1]]
})


# FIPS headers
state_table = c(
'Alabama' = 01L,
'Alaska' = 02L,
'Arizona' = 04L,
'Arkansas' = 05L,
'California' = 06L,
'Colorado' = 08L,
'Connecticut' = 09L,
'Delaware' = 10L,
'Florida' = 12L,
'Georgia' = 13L,
'Hawaii' = 15L,
'Idaho' = 16L,
'Illinois' = 17L,
'Indiana' = 18L,
'Iowa' = 19L,
'Kansas' = 20L,
'Kentucky' = 21L,
'Louisiana' = 22L,
'Maine' = 23L,
'Maryland' = 24L,
'Massachusetts' = 25L,
'Michigan' = 26L,
'Minnesota' = 27L,
'Mississippi' = 28L,
'Missouri' = 29L,
'Montana' = 30L,
'Nebraska' = 31L,
'Nevada' = 32L,
'New Hampshire' = 33L,
'New Jersey' = 34L,
'New Mexico' = 35L,
'New York' = 36L,
'North Carolina' = 37L,
'North Dakota' = 38L,
'Ohio' = 39L,
'Oklahoma' = 40L,
'Oregon' = 41L,
'Pennsylvania' = 42L,
'Rhode Island' = 44L,
'South Carolina' = 45L,
'South Dakota' = 46L,
'Tennessee' = 47L,
'Texas' = 48L,
'Utah' = 49L,
'Vermont' = 50L,
'Virginia' = 51L,
'Washington' = 53L,
'West Virginia' = 54L,
'Wisconsin' = 55L,
'Wyoming' = 56L,
'District of Columbia' = 11L
)

# Vector used for select box in Shiny App
election_names <- c(
  '2000 - Bush & Gore'='Election_2000',
  '2004 - Bush & Kerry'='Election_2004',
  '2008 - McCain & Obama'='Election_2008',
  '2012 - Romney & Obama'='Election_2012',
  '2016 - Trump & Clinton'='Election_2016'
)

# Read in shapefiles, prepare for leaflets (filter out geographies that can't vote in Pres elex)
state_shape <- readOGR(dsn = './shapefiles/states', layer = 'cb_2015_us_state_500k')
state_shape@data$id <- rownames(state_shape@data)
state_shape.points <- tidy(state_shape, region = 'id')
state_shape.df <- inner_join(state_shape.points, state_shape@data, by='id')
state_shape.df <- mutate(state_shape.df, region=NAME)
state_shape <- subset(state_shape, NAME %in% names(state_table))

county_shape <- readOGR(dsn = './shapefiles/counties', layer = 'cb_2015_us_county_500k')
county_shape@data$id <- rownames(county_shape@data)
county_shape.points <- tidy(county_shape, region = 'id')
county_shape.df <- inner_join(county_shape.points, county_shape@data, by='id')
county_shape.df <- mutate(county_shape.df, region=paste(NAME,'County'))

# Function for capitalizing names.
proper<-function(x) paste0(toupper(substr(x, 1, 1)), tolower(substring(x, 2)))

# DPLYR heavy function for creating table of results in shiny app
create_result_df <- function(election_select, state_select){
  if(state_select == 'National'){
    election <- elections[[names(elections)[which(election_names == election_select)]]]
  }else{
    election <- elections[[names(elections)[which(election_names == election_select)]]] %>% filter(StateName == state_select)
  }
  election[is.na(election)] <- 0 #na.rm-ish.
  election<-election %>% 
    select(-CountyName,-StateName,-County) %>% 
    melt() %>% 
    group_by(variable) %>% 
    summarize(sum(value)) %>% 
    mutate(variable = proper(variable), `sum(value)`=comma_format()(floor(`sum(value)`)))
  names(election)<-c('Candidate','Votes')
  election
}

# Heavy lifting done here--create the leaflet.
create_leaflet <- function(election_select, state_select){
  # Set shape, national uses different shapefile.
  if(state_select == 'National'){
    shape <- state_shape
    election <- elections[[names(elections)[which(election_names == election_select)]]] %>% 
      select(-CountyName,-County) %>% 
      group_by(StateName) %>% 
      summarize_all(sum)
    # Add winner column to election df
    election$winner<-sapply(1:nrow(election), function(i){
      if(which(election[i,2:length(election)] == max(election[i,2:length(election)],na.rm=T)) %>% length() > 1){
        'Tie'
      }else names(election[i,2:length(election)])[which(election[i,2:length(election)] == max(election[i,2:length(election)],na.rm=T))] 
    }) %>% factor()
    shape@data$region <- shape@data$NAME # region needed for consistency.
    shape@data<-left_join(shape@data, election, by=c('NAME' = 'StateName'))
    candidates<-names(election)[2:3]
  }else{
    shape <- subset(county_shape, as.numeric(as.character(STATEFP)) == state_table[which(names(state_table) == state_select)])
    # Filter election for correct state
    election <- elections[[names(elections)[which(election_names == election_select)]]] %>% 
      filter(StateName == state_select) %>% 
      mutate(County = as.character(County))
    election$CountyName <- as.factor(as.character(election$CountyName))
    election[is.na(election)] <- 0 # replace na with 0, need to do this for dplyr functions.
    # Copied from above.  Good functional programmers are disappointed.
    election$winner<-sapply(1:nrow(election), function(i){
      if(which(election[i,4:length(election)] == max(election[i,4:length(election)])) %>% length() > 1){
        'Tie'
      }else names(election[i,4:length(election)])[which(election[i,4:length(election)] == max(election[i,4:length(election)]))] 
    }) %>% factor()
    shape@data$region <- shape@data$GEOID # region needed for consistency
    shape@data <- left_join(shape@data, election, by=c('region' = 'County'))
    candidates<-names(election)[4:5]
  }
  # GOP is Red, Democrats are Blue.  Why?  No one knows.
  colors<-c('red','blue')
  # Function for coloring the map.
  pal <- colorFactor(
    sapply(levels(shape$winner),function(i){
      if(i %in% candidates) colors[which(candidates == i)]
      else 'white'
    }),
    levels(shape$winner)
  )
  # Create popup label in leaflet.
  pop <- paste0('<strong>',shape$NAME,'</strong><br>',proper(candidates[1]),':', comma_format()(shape[[which(names(shape) == candidates[1])]]),
                '<br>',proper(candidates[2]),':',comma_format()(shape[[which(names(shape) == candidates[2])]]))
  
  to_return <- leaflet(data = shape) %>% 
    addTiles() %>% 
    addPolygons(data = shape, stroke = F, smoothFactor=0.2, fillOpacity = 0.75, color=~pal(winner), popup=pop) %>% 
    addPolylines(weight=2, color='black')
  # Set zoom to exclude AK and HI in national map (you can still scroll/zoom to find them.)
  if(state_select == 'National') to_return <- to_return %>% setView(lng = -98.585522, lat = 39.833333, zoom = 3.66) 
  to_return
}

# Set UI in Shiny App
ui<-dashboardPage(
  dashboardHeader(title = 'United States Presidential Elections, 2000-2016',
                  titleWidth = 600),
  dashboardSidebar(
    selectInput('election_selection', 'Select Election', election_names, selected = 'Election_2016'),
    selectInput('state_selection', 'Select State', c('National',names(state_table)), selected = 'Kentucky')
  ),
  dashboardBody(
    # Style tag helps make leaflet take up more space.
    tags$style(type = "text/css", 
               "#selected_election {height: calc(100vh - 400px) !important;}",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"),
    leafletOutput('selected_election'),
    dataTableOutput('election_result'), width = 12, height = 12
  )
)

# Use functions frm above in server portion of shiny app
server <- function(input, output){
  output$selected_election <- renderLeaflet({
    create_leaflet(election_select = input$election_selection, state_select = input$state_selection)
  })
  output$election_result <- renderDataTable({
    create_result_df(election_select = input$election_selection, state_select = input$state_selection)
  }, options = list(searching = F, paging = F))
}

shinyApp(ui,server)