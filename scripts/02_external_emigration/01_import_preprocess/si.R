
# Slovakia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://pxweb.stat.si/SiStatData/pxweb/en/Data/Data/05N1042S.px/table/tableViewLayout2/ (retrieved 10 November 2023)
# Converted from Windows 1252 to UTF8
raw_csv <- read_delim(here("data", "02_external_emigration", "si", "05N1042S_20231110-081535_utf8.csv"), skip = 1)

si_emigration <- raw_csv %>% 
  rename(regionname = `STATISTICAL REGION`)

# Rename columns to year
year_names <- as.character(2000:2022)
current_names <- colnames(si_emigration) # Getting the current column names
current_names[2:24] <- year_names # Replacing the names of columns 2 through 29
colnames(si_emigration) <- current_names # Assigning the new names back to the dataframe



## Population -------------------------------------------------------------

# Source: https://datacube.statistics.sk/#!/view/en/vbd_dem/om7011rr/v_om7011rr_00_00_00_en (retrieved 10 November 2023)
raw_xl <- read_excel(here("data", "02_external_emigration", "sk", "v_om7011rr_00_00_00_en20231110074721.xlsx"), skip = 5)

sk_population <- raw_xl %>% 
  rename(regionname = `...1`) %>% 
  dplyr::filter(str_detect(regionname, "^Region of")) %>% 
  dplyr::filter(!str_detect(regionname, "NUTS2")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Region of Bratislava" ~ "SK010",
                             regionname == "Region of Trnava" ~ "SK021",
                             regionname == "Region of Trenčín" ~ "SK022",
                             regionname == "Region of Nitra" ~ "SK023",
                             regionname == "Region of Žilina" ~ "SK031",
                             regionname == "Region of Banská Bystrica" ~ "SK032",
                             regionname == "Region of Prešov" ~ "SK041",
                             regionname == "Region of Košice" ~ "SK042")) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population")


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

sk <- sk_emigration %>%
  left_join(sk_population, by = c("NUTS_ID", "year")) %>% 
  mutate(crude_emigration = (emigration/population) * 1000)


## Export ------------------------------

save(sk, file = here("data", "02_external_emigration", "sk", "sk.Rda"))
