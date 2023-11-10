
# Estonia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: RVR01 (https://andmed.stat.ee/en/stat/Lepetatud_tabelid__Rahvastik.Arhiiv__Rahvastikus%C3%BCndmused.%20Arhiiv/RVR01, retrieved 7 November 2023)

# 2000 -- 2017
ee_emigration_00_17 <- read_csv(here("data", "02_external_emigration", "ee", "RVR01_20231107-225217.csv"),
                                skip = 1) # Skip first row to prevent CSV import mess
colnames(ee_emigration_00_17)
ee_emigration_00_17 <- ee_emigration_00_17 %>% 
  rename(year = Year,
         countyname = `Administrative unit/Type of settlement`,
         emigration = `Males and females Emigration External migration`) %>% 
  dplyr::filter(str_detect(countyname, "COUNTY")) %>%  # Only keep counties (=NUTS3 regions) UNKNOWN COUNTY
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
                             countyname == "VÕRU COUNTY" ~ "EE008"
                             )) %>% 
  # Set NAs
  mutate(emigration = case_when(emigration == ".." ~ NA,
                                T ~ emigration)) %>% 
  mutate(emigration = as.numeric(emigration)) %>% 
  # Calculate sum by NUTS_ID and year
  group_by(NUTS_ID, year) %>% 
  summarise(emigration = sum(emigration))





unique(ee_emigration_00_17$regionname)
sum(is.na(ee_emigration_00_17$NUTS_ID))





## Population -------------------------------------------------------------

# Source:

 
## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm



## Export ------------------------------

#save(ee, file = here("data", "02_external_emigration", "ee", "ee.Rda"))
