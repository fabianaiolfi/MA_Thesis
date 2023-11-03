
# Croatia -------------------------------------------------------------


## Net Migration -------------------------------------------------------------

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
hr_emigration$NUTS_ID <- NA

hr_emigration$NUTS_ID[hr_emigration$regionname == "Zagrebačka"] <- "HR065"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Krapinsko-zagorska"] <- "HR064"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Sisačko-moslavačka"] <- "HR028"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Karlovačka"] <- "HR027"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Varaždinska"] <- "HR062"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Koprivničko-križevačka"] <- "HR063"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Bjelovarsko-bilogorska"] <- "HR021"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Primorsko-goranska"] <- "HR031"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Ličko-senjska"] <- "HR032"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Virovitičko-podravska"] <- "HR022"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Požeško-slavonska"] <- "HR023"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Brodsko-posavska"] <- "HR024"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Zadarska"] <- "HR033"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Osječko-baranjska"] <- "HR025"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Šibensko-kninska"] <- "HR034"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Vukovarsko-srijemska"] <- "HR026"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Splitsko-dalmatinska"] <- "HR035"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Istarska"] <- "HR036"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Dubrovačko-neretvanska"] <- "HR037"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Međimurska"] <- "HR061"
hr_emigration$NUTS_ID[hr_emigration$regionname == "Grad Zagreb"] <- "HR050"

test <- hr_emigration %>% 
  dplyr::filter(regionname == "u inozemstvo" | is.na(NUTS_ID)==F)

# Reshape and filter data
formatted_data <- test %>%
  # Convert 'year_' columns to numeric
  mutate(across(starts_with("year"), as.numeric, .names = "as_numeric_{col}")) %>%
  # Filter out rows with 'NA' in 'NUTS_ID'
  dplyr::filter(NUTS_ID != "NA") %>%
  # Select and rename columns
  select(NUTS_ID, year_1998 = as_numeric_year_1998, year_1999 = as_numeric_year_1999) %>%
  # Replace 'NA' values with corresponding values from 'u inozemstvu' rows
  mutate(across(starts_with("year"), 
                ~ coalesce(.,
                           lag(.),
                           lead(.))))

#name_list <- cee_nuts3$NAME_LATN

# hr_nuts3 <- cee_nuts3 %>% 
#   dplyr::filter(str_detect(NUTS_ID, "^HR"))
# 
# hr_nuts3 <- hr_nuts3$NAME_LATN

#unique(hr_emigration$year_Županija)
# 
# hr_emigration <- hr_emigration %>% 
#   rename(regionname = year_Županija) %>%
#   #dplyr::filter(grepl("Abroad", regionname) | regionname %in% cee_nuts3$NAME_LATN)
#   #dplyr::filter(regionname %in% hr_nuts3)
#   dplyr::filter(apply(sapply(hr_nuts3, grepl, regionname), 1, any))



# 
# # Get the names of all sheets in the Excel file
# sheet_names <- excel_sheets(file_path)
# 
# # Import all sheets and merge into one dataframe
# bg_emigration <- map_df(sheet_names, function(year) {
#   
#   # Read data from the current sheet
#   df <- read_excel(file_path, sheet = year)
#   
#   # Perform transformations
#   df <- df %>%
#     rename_with(~paste0("V", seq_along(.))) %>% # Reset column names to generic names
#     select(V1, V5) %>%
#     rename(regionname = V1,
#            emigration = V5) %>% 
#     mutate(emigration = as.numeric(emigration),
#            year = as.numeric(year))  # Convert year from sheet name to numeric
#   
#   return(df)
# })
# 
# bg_emigration <- bg_emigration %>% 
#   drop_na(emigration) %>% 
#   dplyr::filter(regionname != "Total") %>% 
#   mutate(abs_emigration = abs(emigration))
# 
# # Remove rows with duplicate "regionname" values and keep only the one with the higher "abs_emigration",
# bg_emigration <- bg_emigration %>%
#   group_by(regionname, year) %>%
#   top_n(1, abs_emigration) %>%
#   ungroup() %>% 
#   select(-abs_emigration)
# 
# # Add NUTS3
# bg_emigration <- bg_emigration %>% 
#   left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>% 
#   drop_na(NUTS_ID) %>% 
#   distinct(year, NUTS_ID, .keep_all = T) %>% 
#   select(year, NUTS_ID, regionname, emigration)
# 
# 
# ## Population -------------------------------------------------------------
# 
# # Source: https://www.nsi.bg/en/content/2975/population-districts-municipalities-place-residence-and-sex (retrieved 2 November 2023)
# file_path <- here("data", "02_external_emigration", "bg", "Pop_6.1.1_Pop_DR_EN.xls")
# 
# # Get the names of all sheets in the Excel file
# sheet_names <- excel_sheets(file_path)
# 
# # Import all sheets and merge into one dataframe
# bg_population <- map_df(sheet_names, function(year) {
#   
#   # Read data from the current sheet
#   df <- read_excel(file_path, sheet = year)
#   
#   # Perform transformations
#   df <- df %>%
#     rename_with(~paste0("V", seq_along(.))) %>% # Reset column names to generic names
#     select(V1, V2) %>% 
#     rename(regionname = V1,
#            population = V2) %>% 
#     mutate(population = as.numeric(population),
#            year = as.numeric(year))  # Convert year from sheet name to numeric
#   
#   return(df)
# })
# 
# bg_population <- bg_population %>% 
#   drop_na(population) %>% 
#   dplyr::filter(regionname != "Total")
# 
# # Sofia (stolitsa) has different name in 2010 and 2011
# bg_population$regionname[bg_population$regionname == "Sofia cap."] <- "Sofia (stolitsa)"
# 
# # Remove rows with duplicate "regionname" values and keep only the one with the higher "abs_population",
# bg_population <- bg_population %>%
#   group_by(regionname, year) %>%
#   top_n(1, population) %>%
#   ungroup()
# 
# # Add NUTS3
# bg_population <- bg_population %>% 
#   left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>% 
#   drop_na(NUTS_ID) %>% 
#   distinct(year, NUTS_ID, .keep_all = T) %>%
#   select(year, NUTS_ID, regionname, population)
# 
# 
# ## Calculate crude emigration --------------------------------
# # Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm
# 
# bg <- bg_emigration %>% 
#   left_join(select(bg_population, -regionname), by = c("year", "NUTS_ID")) %>% 
#   mutate(crude_emigration = (emigration/population) * 1000)
# 
# 
# ## Export ------------------------------
# 
# save(bg, file = here("data", "02_external_emigration", "bg", "bg.Rda"))
