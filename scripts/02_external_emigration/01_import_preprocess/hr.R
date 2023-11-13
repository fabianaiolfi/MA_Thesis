
# Croatia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://podaci.dzs.hr/media/ueajlqe5/stanovnistvo-pregled-po-zupanijama.xlsx (retrieved 3 November 2023)
file_path <- here("data", "02_external_emigration", "hr", "stanovnistvo-pregled-po-zupanijama.xlsx")

# Read a specific sheet by name
raw_excel <- read_excel(file_path, sheet = "7.4.2.")

hr_emigration <- raw_excel %>% 
  rename_with(~paste0("V", seq_along(.))) %>% # Reset column names to generic names
  drop_na(V2) %>% 
  select(-V2)

# Remove period from every column in the first row
hr_emigration[1, ] <- hr_emigration[1, ] %>%
  mutate(across(everything(), ~ gsub("\\.", "", .))) %>% 
  mutate(across(everything(), ~ gsub("^", "year_", .)))
colnames(hr_emigration) <- hr_emigration[1, ] # Set column names using the first row
hr_emigration <- hr_emigration[-(1:9), ] # Remove top rows
hr_emigration <- hr_emigration %>% rename(regionname = year_Županija)

df <- ned_v_dem_cee %>% 
  dplyr::filter(country == "Croatia") %>% 
  distinct(nuts2016, regionname) %>% 
  arrange(regionname)
print(df, n = 21)

# Add NUTS ID
hr_emigration$NUTS_ID <- NA
hr_emigration$NUTS_ID[hr_emigration$regionname == "Zagrebačka"] <- "HR042"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Krapinsko-zagorska"] <- "HR043"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Sisačko-moslavačka"] <- "HR04E"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Karlovačka"] <- "HR04D"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Varaždinska"] <- "HR044"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Koprivničko-križevačka"] <- "HR045"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Bjelovarsko-bilogorska"] <- "HR047"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Primorsko-goranska"] <- "HR031"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Ličko-senjska"] <- "HR032"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Virovitičko-podravska"] <- "HR048"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Požeško-slavonska"] <- "HR049"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Brodsko-posavska"] <- "HR04A"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Zadarska"] <- "HR033"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Osječko-baranjska"] <- "HR04B"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Šibensko-kninska"] <- "HR034"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Vukovarsko-srijemska"] <- "HR04C"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Splitsko-dalmatinska"] <- "HR035"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Istarska"] <- "HR036"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Dubrovačko-neretvanska"] <- "HR037"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Međimurska"] <- "HR046"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Grad Zagreb"] <- "HR050"

# Only keep relevant rows
hr_emigration <- hr_emigration %>% dplyr::filter(regionname == "u inozemstvo" | is.na(NUTS_ID) == F)
# Copy regionname and NUTS ID from previous row
hr_emigration$regionname <- with(hr_emigration, ifelse(seq_along(regionname) %% 2 == 1, regionname, dplyr::lag(regionname)))
hr_emigration$NUTS_ID <- with(hr_emigration, ifelse(seq_along(NUTS_ID) %% 2 == 1, NUTS_ID, dplyr::lag(NUTS_ID)))
# Remove rows containing NAs
hr_emigration <- hr_emigration %>% drop_na()

# Wide to Long
hr_emigration <- hr_emigration %>%
  pivot_longer(cols = starts_with("year"),
               names_to = "year",
               values_to = "value") %>% 
  select(-regionname) %>% 
  mutate(year = gsub("year_", "", year)) %>% 
  mutate(year = as.numeric(year)) %>% 
  rename(emigration = value) %>% 
  mutate(emigration = as.numeric(emigration))
  

## Population -------------------------------------------------------------

# Source: https://podaci.dzs.hr/media/ueajlqe5/stanovnistvo-pregled-po-zupanijama.xlsx (retrieved 3 November 2023)
file_path <- here("data", "02_external_emigration", "hr", "stanovnistvo-pregled-po-zupanijama.xlsx")

# Read a specific sheet by name
raw_excel <- read_excel(file_path, sheet = "7.4.3.")

hr_population <- raw_excel %>% 
  rename_with(~paste0("V", seq_along(.))) %>% # Reset column names to generic names
  drop_na(V2, V3) %>% 
  select(-V2)

# Clean up first row
hr_population[1, ] <- hr_population[1, ] %>%
  mutate(across(everything(), ~ str_sub(., start = 1, end = 4))) %>% 
  mutate(across(everything(), ~ gsub("^", "year_", .)))
colnames(hr_population) <- hr_population[1, ] # Set column names using the first row
hr_population <- hr_population[-(1:2), ] # Remove top rows
hr_population <- hr_population %>% rename(regionname = year_Župa)

# Add NUTS ID
hr_population$NUTS_ID <- NA
hr_population$NUTS_ID[hr_population$regionname == "Zagrebačka"] <- "HR042"
hr_population$NUTS_ID[hr_population$regionname == "Krapinsko-zagorska"] <- "HR043"
hr_population$NUTS_ID[hr_population$regionname == "Sisačko-moslavačka"] <- "HR04E"
hr_population$NUTS_ID[hr_population$regionname == "Karlovačka"] <- "HR04D"
hr_population$NUTS_ID[hr_population$regionname == "Varaždinska"] <- "HR044"
hr_population$NUTS_ID[hr_population$regionname == "Koprivničko-križevačka"] <- "HR045"
hr_population$NUTS_ID[hr_population$regionname == "Bjelovarsko-bilogorska"] <- "HR047"
hr_population$NUTS_ID[hr_population$regionname == "Primorsko-goranska"] <- "HR031"
hr_population$NUTS_ID[hr_population$regionname == "Ličko-senjska"] <- "HR032"
hr_population$NUTS_ID[hr_population$regionname == "Virovitičko-podravska"] <- "HR048"
hr_population$NUTS_ID[hr_population$regionname == "Požeško-slavonska"] <- "HR049"
hr_population$NUTS_ID[hr_population$regionname == "Brodsko-posavska"] <- "HR04A"
hr_population$NUTS_ID[hr_population$regionname == "Zadarska"] <- "HR033"
hr_population$NUTS_ID[hr_population$regionname == "Osječko-baranjska"] <- "HR04B"
hr_population$NUTS_ID[hr_population$regionname == "Šibensko-kninska"] <- "HR034"
hr_population$NUTS_ID[hr_population$regionname == "Vukovarsko-srijemska"] <- "HR04C"
hr_population$NUTS_ID[hr_population$regionname == "Splitsko-dalmatinska"] <- "HR035"
hr_population$NUTS_ID[hr_population$regionname == "Istarska"] <- "HR036"
hr_population$NUTS_ID[hr_population$regionname == "Dubrovačko-neretvanska"] <- "HR037"
hr_population$NUTS_ID[hr_population$regionname == "Međimurska"] <- "HR046"
hr_population$NUTS_ID[hr_population$regionname == "Grad Zagreb"] <- "HR050"

# Wide to Long
hr_population <- hr_population %>%
  pivot_longer(cols = starts_with("year"),
               names_to = "year",
               values_to = "value") %>% 
  select(-regionname) %>% 
  mutate(year = gsub("year_", "", year)) %>% 
  mutate(year = as.numeric(year)) %>% 
  rename(population = value) %>% 
  mutate(population = as.numeric(population))

 
## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

hr <- hr_emigration %>%
  left_join(hr_population, by = c("year", "NUTS_ID")) %>%
  mutate(crude_emigration = (emigration/population) * 1000) %>% 
  select(NUTS_ID, year, crude_emigration)


## Export ------------------------------

save(hr, file = here("data", "02_external_emigration", "hr", "hr.Rda"))
