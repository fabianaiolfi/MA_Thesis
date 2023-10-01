
# Data Import and Preprocessing -------------------------------------------------------------

ned <- read.csv(here("data", "eu_ned_joint.csv"))
ned$party_share <- ned$partyvote / ned$validvote * 100

Emigration <- read.csv(here("data", "05_incumbent_vote_share", "Emigration.csv"))
Election_HR_2011_2015 <- read.csv(here("data", "05_incumbent_vote_share", "Election_HR_2011_2015.csv"))
Election_HR_2015_2016 <- read.csv(here("data", "05_incumbent_vote_share", "Election_HR_2015_2016.csv"))
Election_HR_2016_2020 <- read.csv(here("data", "05_incumbent_vote_share", "Election_HR_2016_2020.csv"))

# Load the shapefile for maps
# https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts
nuts3_shape <- st_read(here("data", "NUTS_RG_10M_2021_3035_shp", "NUTS_RG_10M_2021_3035.shp"))
nuts3_shape_2016 <- st_read(here("data", "NUTS_RG_10M_2016_3035_shp", "NUTS_RG_10M_2016_3035.shp"))