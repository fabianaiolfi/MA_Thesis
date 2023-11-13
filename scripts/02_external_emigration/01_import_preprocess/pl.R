
# Poland -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 10 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "pl", "LUDN_1350_CTAB_20231110071448.csv"),
                      delim = ";")
 
pl_emigration <- raw_csv %>%
  select(-c(Code, `...31`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(1995:2022)
current_names <- colnames(pl_emigration) # Getting the current column names
current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_emigration) <- current_names # Assigning the new names back to the dataframe

# Capitalize letter after space
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

# More preprocessing
pl_emigration <- pl_emigration %>% 
  dplyr::filter(str_detect(regionname, "SUBREGION")) %>% 
  mutate(regionname = gsub("SUBREGION ", "", regionname)) %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>% 
  mutate(regionname = gsub("City Of", "Miasto", regionname)) %>% 
  mutate(regionname = gsub("Capital ", "", regionname)) %>% 
  mutate(regionname = gsub("Wschodni", "wschodni", regionname)) %>% 
  mutate(regionname = gsub("Zachodni", "zachodni", regionname)) %>% 
  left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "emigration") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(emigration = case_when(emigration == 0 & year == 2015 ~ NA,
                                T ~ emigration))


## Population -------------------------------------------------------------

# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 10 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "pl", "LUDN_2425_CTAB_20231110072421.csv"),
                      delim = ";")

pl_population <- raw_csv %>% 
  select(-c(Code, `...31`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(1995:2022)
current_names <- colnames(pl_population) # Getting the current column names
current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_population) <- current_names # Assigning the new names back to the dataframe

# More preprocessing
pl_population <- pl_population %>% 
  dplyr::filter(str_detect(regionname, "SUBREGION")) %>% 
  mutate(regionname = gsub("SUBREGION ", "", regionname)) %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>% 
  mutate(regionname = gsub("City Of", "Miasto", regionname)) %>% 
  mutate(regionname = gsub("Capital ", "", regionname)) %>% 
  mutate(regionname = gsub("Wschodni", "wschodni", regionname)) %>% 
  mutate(regionname = gsub("Zachodni", "zachodni", regionname)) %>% 
  left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(population = population * 1000) # Original CSV population in thousand persons


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

pl <- pl_emigration %>%
  left_join(pl_population, by = c("NUTS_ID", "year")) %>% 
  mutate(crude_emigration = (emigration/population) * 1000) %>% 
  select(NUTS_ID, year, crude_emigration)


## Export ------------------------------

save(pl, file = here("data", "02_external_emigration", "pl", "pl.Rda"))
