
# Estonia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# 2000 -- 2017
# Source: RVR01 (https://andmed.stat.ee/en/stat/Lepetatud_tabelid__Rahvastik.Arhiiv__Rahvastikus%C3%BCndmused.%20Arhiiv/RVR01, retrieved 7 November 2023)
ee_emigration_00_17 <- read_csv(here("data", "02_external_emigration", "ee", "RVR01_20231107-225217.csv"),
                                skip = 1) # Skip first row to prevent CSV import mess

ee_emigration_00_17 <- ee_emigration_00_17 %>% 
  rename(year = Year,
         countyname = `Administrative unit/Type of settlement`,
         emigration = `Males and females Emigration External migration`) %>% 
  dplyr::filter(str_detect(countyname, "COUNTY")) %>%  # Only keep counties (=NUTS3 regions)
  dplyr::filter(countyname != "UNKNOWN COUNTY") %>% 
  # Add NUTS3 to county name based on https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Estonia#NUTS_3 (retrieved 10 November 2023)
  mutate(NUTS_ID = case_when(countyname == "HARJU COUNTY" ~ "EE001",
                             countyname == "HIIU COUNTY" ~ "EE004",
                             countyname == "LÄÄNE COUNTY" ~ "EE004",
                             countyname == "PÄRNU COUNTY" ~ "EE004",
                             countyname == "SAARE COUNTY" ~ "EE004",
                             countyname == "JÄRVA COUNTY" ~ "EE006",
                             countyname == "LÄÄNE-VIRU COUNTY" ~ "EE006",
                             countyname == "RAPLA COUNTY" ~ "EE006",
                             countyname == "IDA-VIRU COUNTY" ~ "EE007",
                             countyname == "JÕGEVA COUNTY" ~ "EE008",
                             countyname == "PÕLVA COUNTY" ~ "EE008",
                             countyname == "TARTU COUNTY" ~ "EE008",
                             countyname == "VALGA COUNTY" ~ "EE008",
                             countyname == "VILJANDI COUNTY" ~ "EE008",
                             countyname == "VÕRU COUNTY" ~ "EE008")) %>% 
  # Set NAs
  mutate(emigration = case_when(emigration == ".." ~ NA,
                                T ~ emigration)) %>% 
  mutate(emigration = as.numeric(emigration)) %>% 
  # Calculate sum by NUTS_ID and year
  group_by(NUTS_ID, year) %>% 
  summarise(emigration = sum(emigration)) %>% 
  # Remove 2015 and later because they are included in second data source
  dplyr::filter(year < 2015)

# 2015--2022
# Source: RVR02 (https://andmed.stat.ee/en/stat/rahvastik__rahvastikusundmused__ranne/RVR02/table/tableViewLayout2, retrieved 7 November 2023)
ee_emigration_15_22 <- read_csv(here("data", "02_external_emigration", "ee", "RVR02_20231107-225029.csv"),
                                skip = 1) # Skip first row to prevent CSV import mess

ee_emigration_15_22 <- ee_emigration_15_22 %>% 
  rename(year = Year,
         countyname = `Administrative unit/Type of settlement region`,
         emigration = `Males and females Emigration External migration`) %>% 
  dplyr::filter(str_detect(countyname, "COUNTY")) %>% # Only keep counties (=NUTS3 regions)
  dplyr::filter(countyname != "UNKNOWN COUNTY") %>% 
  # Add NUTS3 to county name based on https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_Estonia#NUTS_3 (retrieved 10 November 2023)
  mutate(NUTS_ID = case_when(countyname == "HARJU COUNTY" ~ "EE001",
                             countyname == "HIIU COUNTY" ~ "EE004",
                             countyname == "LÄÄNE COUNTY" ~ "EE004",
                             countyname == "PÄRNU COUNTY" ~ "EE004",
                             countyname == "SAARE COUNTY" ~ "EE004",
                             countyname == "JÄRVA COUNTY" ~ "EE006",
                             countyname == "LÄÄNE-VIRU COUNTY" ~ "EE006",
                             countyname == "RAPLA COUNTY" ~ "EE006",
                             countyname == "IDA-VIRU COUNTY" ~ "EE007",
                             countyname == "JÕGEVA COUNTY" ~ "EE008",
                             countyname == "PÕLVA COUNTY" ~ "EE008",
                             countyname == "TARTU COUNTY" ~ "EE008",
                             countyname == "VALGA COUNTY" ~ "EE008",
                             countyname == "VILJANDI COUNTY" ~ "EE008",
                             countyname == "VÕRU COUNTY" ~ "EE008")) %>% 
  # Set NAs
  mutate(emigration = case_when(emigration == ".." ~ NA,
                                T ~ emigration)) %>% 
  mutate(emigration = as.numeric(emigration)) %>% 
  # Calculate sum by NUTS_ID and year
  group_by(NUTS_ID, year) %>% 
  summarise(emigration = sum(emigration))

# Merge both sources
ee_emigration <- rbind(ee_emigration_00_17, ee_emigration_15_22)
rm(ee_emigration_00_17, ee_emigration_15_22)


## Population -------------------------------------------------------------

# 1990---2017
# Source:
ee_emigration_00_17 <- read_csv(here("data", "02_external_emigration", "ee", "RV022_20231107-230654.csv"),
                                skip = 1) # Skip first row to prevent CSV import mess


 
## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm



## Export ------------------------------

#save(ee, file = here("data", "02_external_emigration", "ee", "ee.Rda"))
