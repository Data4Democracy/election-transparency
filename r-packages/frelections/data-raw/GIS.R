library(rgdal)
library(tidyverse)

# read commune data out of GEOFLA shapefiles, and construct a CommuneCode that maps to the code scheme that the Interior Ministry uses
# for election data.  Note that we're throwing out the spatial polygons here...just using the shapefiles as an easy source of
# commune/departement/region rollups.

# shapefiles sourced from http://professionnels.ign.fr/geofla

communeData <- bind_rows(
  readOGR('/opt/data/Shapefiles/France/GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00236/GEOFLA_2-2_SHP_LAMB93_FR-ED161/COMMUNE/', 'COMMUNE')@data %>%
    mutate(Source='GEOFLA_2-2_COMMUNE_SHP_LAMB93_FXX_2016-06-28') %>% mutate_if(is.factor, as.character) %>% mutate(CommuneCode=str_pad(INSEE_COM, 6, 'left', '0')),
  bind_rows(
    readOGR('/opt/data/Shapefiles/France/GEOFLA_2-2__SHP_RGM04UTM38S_D976_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00236/GEOFLA_2-2_SHP_RGM04UTM38S_D976-ED161/COMMUNE/', 'COMMUNE')@data %>%
      mutate(Source='GEOFLA_2-2__SHP_RGM04UTM38S_D976_2016-06-28') %>% mutate_if(is.factor, as.character) %>%
      mutate(CODE_COM=paste0('5', str_sub(CODE_COM, 2, 3)), INSEE_COM=paste0('975', str_sub(INSEE_COM, 4, 5))),
    readOGR('/opt/data/Shapefiles/France/GEOFLA_2-2_COMMUNE_SHP_RGR92UTM40S_D974_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00236/GEOFLA_2-2_SHP_RGR92UTM40S_D974-ED161/COMMUNE/', 'COMMUNE')@data %>%
      mutate(Source='GEOFLA_2-2_COMMUNE_SHP_RGR92UTM40S_D974_2016-06-28') %>% mutate_if(is.factor, as.character),
    readOGR('/opt/data/Shapefiles/France/GEOFLA_2-2_COMMUNE_SHP_UTM20W84GUAD_D971_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00236/GEOFLA_2-2_SHP_UTM20W84GUAD_D971-ED161/COMMUNE/', 'COMMUNE')@data %>%
      mutate(Source='GEOFLA_2-2_COMMUNE_SHP_UTM20W84GUAD_D971_2016-06-28') %>% mutate_if(is.factor, as.character),
    readOGR('/opt/data/Shapefiles/France/GEOFLA_2-2_COMMUNE_SHP_UTM20W84MART_D972_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00236/GEOFLA_2-2_SHP_UTM20W84MART_D972-ED161/COMMUNE/', 'COMMUNE')@data %>%
      mutate(Source='GEOFLA_2-2_COMMUNE_SHP_UTM20W84MART_D972_2016-06-28') %>% mutate_if(is.factor, as.character),
    readOGR('/opt/data/Shapefiles/France/GEOFLA_2-2_COMMUNE_SHP_UTM22RGFG95_D973_2016-06-28/GEOFLA/1_DONNEES_LIVRAISON_2016-06-00236/GEOFLA_2-2_SHP_UTM22RGFG95_D973-ED161/COMMUNE/', 'COMMUNE')@data %>%
      mutate(Source='GEOFLA_2-2_COMMUNE_SHP_UTM22RGFG95_D973_2016-06-28') %>% mutate_if(is.factor, as.character)
  ) %>% mutate(CommuneCode=paste0(str_sub(INSEE_COM, 1, 2), str_sub(CODE_REG, 2, 2), str_sub(INSEE_COM, 3, 5)))
) %>% as_tibble() %>%
  mutate(CommuneCode=ifelse(grepl(x=NOM_COM, pattern='MARSEILLE\\-[0-9]+E'), paste0('013055AR', str_sub(INSEE_COM, 4, 5)), CommuneCode)) %>%
  mutate(CommuneCode=ifelse(grepl(x=NOM_COM, pattern='LYON\\-[0-9]+E'), paste0('069123AR0', str_sub(INSEE_COM, 5, 5)), CommuneCode)) %>%
  select(CommuneCodeINSEE=INSEE_COM, CommuneNomINSEE=NOM_COM, RegionCode=CODE_REG, RegionNom=NOM_REG, DepartementCode=CODE_DEPT, DepartementNom=NOM_DEPT, CommuneCode)

