
# Slovakia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (retrieved 13 November 2023)
# File must be resaved as from XLS to XLSX
raw_xl <- read_excel(here("data", "02_external_emigration", "ro", "TEMPO_POP309E_1_10_2023.xlsx"), skip = 2)
 
ro_emigration <- raw_xl %>% 
  drop_na(`...1`, `Year 2000`) %>% 
  select(-`...2`) %>% 
  rename(regionname = `...1`) %>% 
  dplyr::filter(regionname != "TOTAL") %>% 
  left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN"))

# Which regions didn't make it in the join?
missing_nuts <- ro_emigration %>% select(regionname, NUTS_ID) %>% dplyr::filter(is.na(NUTS_ID) == T)

ro_emigration <- ro_emigration %>% 
  mutate(NUTS_ID = case_when(regionname == "Arges" ~ " ",
                             regionname == "Bacau" ~ " ",
                             regionname == "Bistrita-Nasaud" ~ " ",
                             regionname == "Botosani" ~ " ",
                             regionname == "Brasov" ~ " ",
                             regionname == "Braila" ~ " ",
                             regionname == "Buzau" ~ " ",
                             regionname == "Caras-Severin" ~ " ",
                             regionname == "Calarasi" ~ " ",
                             regionname == "Constanta" ~ " ",
                             regionname == "Dambovita" ~ " ",
                             regionname == "Galati" ~ " ",
                             regionname == "Ialomita" ~ " ",
                             regionname == "Iasi" ~ " ",
                             regionname == "Maramures" ~ " ",
                             regionname == "Mehedinti" ~ " ",
                             regionname == "Mures" ~ " ",
                             regionname == "Neamt" ~ " ",
                             regionname == "Salaj" ~ " ",
                             regionname == "Timis" ~ " ",
                             regionname == "Valcea" ~ " ",
                             regionname == "Bucharest Municipality" ~ " "))

# sk_emigration <- raw_xl %>% 
#   rename(regionname = `...1`) %>% 
#   dplyr::filter(str_detect(regionname, "^Region of")) %>% 
#   dplyr::filter(!str_detect(regionname, "NUTS2")) %>% 
#   mutate(NUTS_ID = case_when(regionname == "Region of Bratislava" ~ "SK010",
#                              regionname == "Region of Trnava" ~ "SK021",
#                              regionname == "Region of Trenčín" ~ "SK022",
#                              regionname == "Region of Nitra" ~ "SK023",
#                              regionname == "Region of Žilina" ~ "SK031",
#                              regionname == "Region of Banská Bystrica" ~ "SK032",
#                              regionname == "Region of Prešov" ~ "SK041",
#                              regionname == "Region of Košice" ~ "SK042")) %>% 
#   select(-regionname) %>% 
#   pivot_longer(cols = -NUTS_ID,
#                names_to = "year",
#                values_to = "emigration")


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
