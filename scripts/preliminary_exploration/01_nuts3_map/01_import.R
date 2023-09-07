
# Data Import -------------------------------------------------------------

# Crude rate of net migration plus statistical adjustment [CNMIGRATRT]
# https://ec.europa.eu/eurostat/databrowser/view/DEMO_R_GIND3__custom_7029377/default/table?lang=en
# https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm
# Crude rate of net migration including statistical adjustment is the ratio of the net migration including statistical adjustment during the year to the average population in that year. The value is expressed per 1000 inhabitants. The crude rate of net migration is equal to the difference between the crude rate of population change and the crude rate of natural change (that is, net migration is considered as the part of population change not attributable to births and deaths). It is calculated in this way because immigration or emigration flows are either not available or the figures are not reliable.
net_migr_nuts3 <- read_csv(here("data", "demo_r_gind3_spreadsheet_sheet_2.csv"),
                           na = ":",
                           show_col_types = FALSE)


# NUTS3 (2010) Typologies
# https://ec.europa.eu/eurostat/documents/345175/6807882/Ttypologies+and+local+information+corresponding+to+NUTS3.xls
nuts3_typologies <- read_csv(here("data", "nuts3_2010_typologies.csv"))


# EU Accession Dates
eu_accession <- read_csv(here("data", "eu_accession.csv"))
