
# Import Voting Data -------------------------------------------------------------

load(here("data", "01_anti_incumbent_vote", "ned_v_dem_cee.Rda"))


# CEE NUTS0 --------------------------------------

cee <- c("BG", "HR", "CZ", "EE", "HU", "LV", "LT", "PL", "RO", "SK", "SI")
cee_names <- c("Bulgaria", "Croatia", "Czech Republic", "Czechia", "Estonia", "Hungary", "Latvia", "Lithuania", "Poland", "Romania", "Slovakia", "Slovenia")


# NUTS3 (2010) Typologies
# https://ec.europa.eu/eurostat/documents/345175/6807882/Ttypologies+and+local+information+corresponding+to+NUTS3.xls
nuts3_typologies <- read_csv(here("data", "nuts3_2010_typologies.csv"))
nuts3_typologies <- nuts3_typologies %>% 
  rename(NUTS_ID = `NUTS 3 ID (2010)`,
         coastal = `Coastal region`,
         typology = `Rural - urban typology`,
         metro = `Metro region corresponding to the NUTS`) %>% 
  select(NUTS_ID, typology, metro, coastal) %>% 
  mutate(coastal = case_when(coastal == "N" ~ F,
                             coastal == "Y" ~ T,
                             T ~ NA)) %>% 
  mutate(metro = case_when(metro == "N" ~ F,
                           metro == "Y" ~ T,
                           T ~ NA))# %>% 
  # mutate(typology = factor(typology, ordered = T, levels = c("Rural region", "Intermediate region", "Urban region")))


# Croatian NUTS3 Recoding --------------------------------------

# https://ec.europa.eu/eurostat/web/nuts/background
# https://ec.europa.eu/eurostat/documents/345175/629341/NUTS2021.xlsx
# /Data/NUTS2021.xlsx
hr_nuts_recoding <- read_csv(here("data", "HR_NUTS_Recoding.csv"))


# NUTS3 IDs and Names --------------------------------------

cee_nuts3 <- eurostat::eurostat_geodata_60_2016 %>% 
  select(NUTS_ID, NAME_LATN, NUTS_NAME) %>% 
  # Filter for CEE
  dplyr::filter(str_detect(NUTS_ID, paste0("^", cee, collapse = "|"))) %>% 
  # Filter for NUTS3
  dplyr::filter(str_length(NUTS_ID) == 5)
  
cee_nuts3$geometry <- NULL


# NUTS2 IDs and Names --------------------------------------

cee_nuts2 <- eurostat::eurostat_geodata_60_2016 %>% 
  select(NUTS_ID, NAME_LATN, NUTS_NAME) %>% 
  # Filter for CEE
  dplyr::filter(str_detect(NUTS_ID, paste0("^", cee, collapse = "|"))) %>% 
  # Filter for NUTS2
  dplyr::filter(str_length(NUTS_ID) == 4)

cee_nuts2$geometry <- NULL


# Capitalize letter after space -----------------------------
# Used for pl.R scripts

capitalizeAfterSpace <- function(s) {
  # Splitting the string into characters
  chars <- unlist(strsplit(s, ""))
  
  # Lowercasing all characters first
  chars <- tolower(chars)
  
  # Capitalizing the first character
  chars[1] <- toupper(chars[1])
  
  # Finding spaces and capitalizing the following character
  for (i in 1:(length(chars) - 1)) {
    if (chars[i] == " " && i < length(chars)) {
      chars[i + 1] <- toupper(chars[i + 1])
    }
  }
  
  # Collapsing the characters back into a single string
  paste0(chars, collapse = "")
}


# Election Years -------------------------------------

# Poland
pl_election_years <- ned_v_dem_cee %>% 
  dplyr::filter(str_detect(nuts2016, "^PL")) %>% 
  distinct(year) %>% 
  arrange(year)

pl_election_years <- pl_election_years$year
pl_election_years <- c(1997, 2001, pl_election_years, 2023) # Previous elections
pl_election_years <- sort(pl_election_years) # Ensure election years are sorted

# Romania
ro_election_years <- ned_v_dem_cee %>% 
  dplyr::filter(str_detect(nuts2016, "^RO")) %>% 
  distinct(year) %>% 
  arrange(year)

ro_election_years <- ro_election_years$year
ro_election_years <- c(1996, 2000, 2004, ro_election_years, 2020) # Previous elections
ro_election_years <- sort(ro_election_years) # Ensure election years are sorted

# Bulgaria
bg_election_years <- ned_v_dem_cee %>%
  dplyr::filter(str_detect(nuts2016, "^BG")) %>%
  distinct(year) %>% 
  arrange(year)

bg_election_years <- bg_election_years$year
bg_election_years <- c(2001, 2005, bg_election_years, 2021) # Previous elections
bg_election_years <- sort(bg_election_years) # Ensure election years are sorted

# Lithuania
lt_election_years <- ned_v_dem_cee %>%
  dplyr::filter(str_detect(nuts2016, "^LT")) %>%
  distinct(year) %>% 
  arrange(year)

lt_election_years <- lt_election_years$year
lt_election_years <- c(2000, lt_election_years, 2020) # Previous elections
lt_election_years <- sort(lt_election_years) # Ensure election years are sorted

# Estonia
ee_election_years <- ned_v_dem_cee %>%
  dplyr::filter(str_detect(nuts2016, "^EE")) %>%
  distinct(year) %>% 
  arrange(year)

ee_election_years <- ee_election_years$year
ee_election_years <- c(1999, 2003, ee_election_years, 2023) # Previous elections
ee_election_years <- sort(ee_election_years) # Ensure election years are sorted

# Croatia
hr_election_years <- ned_v_dem_cee %>%
  dplyr::filter(str_detect(nuts2016, "^HR")) %>%
  distinct(year) %>% 
  arrange(year)

hr_election_years <- hr_election_years$year
hr_election_years <- c(2003, 2007, 2011, hr_election_years, 2020) # Previous elections
hr_election_years <- sort(hr_election_years) # Ensure election years are sorted

# Hungary
hu_election_years <- ned_v_dem_cee %>%
  dplyr::filter(str_detect(nuts2016, "^HU")) %>%
  distinct(year) %>% 
  arrange(year)

hu_election_years <- hu_election_years$year
hu_election_years <- c(hu_election_years, 2022) # Previous elections
hu_election_years <- sort(hu_election_years) # Ensure election years are sorted

# Latvia
lv_election_years <- ned_v_dem_cee %>%
  dplyr::filter(str_detect(nuts2016, "^LV")) %>%
  distinct(year) %>% 
  arrange(year)

lv_election_years <- lv_election_years$year
lv_election_years <- c(2002, lv_election_years, 2022) # Previous elections
lv_election_years <- sort(lv_election_years) # Ensure election years are sorted

# Slovakia
sk_election_years <- ned_v_dem_cee %>%
  dplyr::filter(str_detect(nuts2016, "^SK")) %>%
  distinct(year) %>% 
  arrange(year)

sk_election_years <- sk_election_years$year
sk_election_years <- c(1994, 1998, 2002, 2006, sk_election_years, 2020) # Previous elections
sk_election_years <- sort(sk_election_years) # Ensure election years are sorted


# NUTS3 Population -------------------------------------

# Eurostat, only covers 2014--2022
load(file = here("data", "02_external_emigration", "nuts3_population.Rda"))
