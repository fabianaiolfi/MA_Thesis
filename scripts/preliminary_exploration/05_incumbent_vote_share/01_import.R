
# Data Import and Preprocessing -------------------------------------------------------------

# Crude rate of net migration including statistical adjustment is the ratio of the net migration including statistical adjustment during the year to the average population in that year. The value is expressed per 1000 inhabitants. The crude rate of net migration is equal to the difference between the crude rate of population change and the crude rate of natural change (that is, net migration is considered as the part of population change not attributable to births and deaths). It is calculated in this way because immigration or emigration flows are either not available or the figures are not reliable.
net_migr_nuts3 <- read_csv(here("data", "demo_r_gind3_spreadsheet_sheet_2.csv"),
                           na = ":",
                           show_col_types = FALSE)

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