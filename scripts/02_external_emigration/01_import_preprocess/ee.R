
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
#RV022: POPULATION, 1 JANUARY by Year, County, Sex and Age group
# Source: https://andmed.stat.ee/en/stat/Lepetatud_tabelid__Rahvastik.Arhiiv__Rahvastikun%C3%A4itajad%20ja%20koosseis.%20Arhiiv/RV022/table/tableViewLayout2 (retrieved 7 November 2023)
ee_population_90_17 <- read_csv(here("data", "02_external_emigration", "ee", "RV022_20231107-230654.csv"),
                                skip = 1) # Skip first row to prevent CSV import mess

ee_population_90_17 <- ee_population_90_17 %>% 
  select(-Sex) %>% 
  rename(year = Year,
         countyname = County,
         population = `Age groups total`) %>% 
  dplyr::filter(countyname != "County unknown") %>% 
  mutate(countyname = gsub("\\*", "", countyname)) %>% 
  mutate(NUTS_ID = case_when(countyname == "Harju county" ~ "EE001",
                             countyname == "Hiiu county" ~ "EE004",
                             countyname == "Lääne county" ~ "EE004",
                             countyname == "Pärnu county" ~ "EE004",
                             countyname == "Saare county" ~ "EE004",
                             countyname == "Järva county" ~ "EE006",
                             countyname == "Lääne-Viru county" ~ "EE006",
                             countyname == "Rapla county" ~ "EE006",
                             countyname == "Ida-Viru county" ~ "EE007",
                             countyname == "Jõgeva county" ~ "EE008",
                             countyname == "Põlva county" ~ "EE008",
                             countyname == "Tartu county" ~ "EE008",
                             countyname == "Valga county" ~ "EE008",
                             countyname == "Viljandi county" ~ "EE008",
                             countyname == "Võru county" ~ "EE008")) %>% 
  drop_na(NUTS_ID) %>% 
  mutate(population = as.numeric(population)) %>% 
  # Calculate sum by NUTS_ID and year
  group_by(NUTS_ID, year) %>% 
  summarise(population = sum(population))

# 2018--2023
# RV022U: POPULATION, 1 JANUARY. ADMINISTRATIVE DIVISION AS AT 01.01.2018 by Year, County, Sex and Age group
# https://andmed.stat.ee/en/stat/rahvastik__rahvastikunaitajad-ja-koosseis__rahvaarv-ja-rahvastiku-koosseis/RV022U/table/tableViewLayout2 (retrieved 7 November 2023)
ee_population_18_23 <- read_csv(here("data", "02_external_emigration", "ee", "RV022U_20231107-230138.csv"),
                                skip = 1) # Skip first row to prevent CSV import mess

ee_population_18_23 <- ee_population_18_23 %>% 
  select(-Sex) %>% 
  rename(year = Year,
         countyname = County,
         population = `Age groups total`) %>% 
  dplyr::filter(countyname != "County unknown") %>% 
  mutate(NUTS_ID = case_when(countyname == "Harju county" ~ "EE001",
                             countyname == "Hiiu county" ~ "EE004",
                             countyname == "Lääne county" ~ "EE004",
                             countyname == "Pärnu county" ~ "EE004",
                             countyname == "Saare county" ~ "EE004",
                             countyname == "Järva county" ~ "EE006",
                             countyname == "Lääne-Viru county" ~ "EE006",
                             countyname == "Rapla county" ~ "EE006",
                             countyname == "Ida-Viru county" ~ "EE007",
                             countyname == "Jõgeva county" ~ "EE008",
                             countyname == "Põlva county" ~ "EE008",
                             countyname == "Tartu county" ~ "EE008",
                             countyname == "Valga county" ~ "EE008",
                             countyname == "Viljandi county" ~ "EE008",
                             countyname == "Võru county" ~ "EE008")) %>% 
  drop_na(NUTS_ID) %>% 
  mutate(population = as.numeric(population)) %>% 
  # Calculate sum by NUTS_ID and year
  group_by(NUTS_ID, year) %>% 
  summarise(population = sum(population))

# Merge both sources
ee_population <- rbind(ee_population_90_17, ee_population_18_23)
rm(ee_population_90_17, ee_population_18_23)

 
## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm



## Export ------------------------------

#save(ee, file = here("data", "02_external_emigration", "ee", "ee.Rda"))
