
# Bulgaria -------------------------------------------------------------


## Net Migration -------------------------------------------------------------

# Source: https://www.nsi.bg/en/content/3060/migration-population-districts-municipalities-and-sex (retrieved 2 November 2023)
file_path <- here("data", "02_external_emigration", "bg", "Pop_5.1_Migration_DR_EN.xls")

# Get the names of all sheets in the Excel file
sheet_names <- excel_sheets(file_path)

# Import all sheets and merge into one dataframe
bg_net_migration <- map_df(sheet_names, function(year) {
  
  # Read data from the current sheet
  df <- read_excel(file_path, sheet = year)
  
  # Perform transformations
  df <- df %>%
    rename_with(~paste0("V", seq_along(.))) %>% # Reset column names to generic names
    select(V1, V8) %>% 
    rename(regionname = V1,
           net_migration = V8) %>% 
    mutate(net_migration = as.numeric(net_migration),
           year = as.numeric(year))  # Convert year from sheet name to numeric
  
  return(df)
})

bg_net_migration <- bg_net_migration %>% 
  drop_na(net_migration) %>% 
  dplyr::filter(regionname != "Total") %>% 
  mutate(abs_net_migration = abs(net_migration))

# Remove rows with duplicate "regionname" values and keep only the one with the higher "abs_net_migration",
bg_net_migration <- bg_net_migration %>%
  group_by(regionname, year) %>%
  top_n(1, abs_net_migration) %>%
  ungroup() %>% 
  select(-abs_net_migration)

# Add NUTS3
bg_net_migration <- bg_net_migration %>% 
  left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>% 
  drop_na(NUTS_ID) %>% 
  distinct(year, NUTS_ID, .keep_all = T) %>% 
  select(year, NUTS_ID, regionname, net_migration)


## Population -------------------------------------------------------------

# Source: https://www.nsi.bg/en/content/2975/population-districts-municipalities-place-residence-and-sex (retrieved 2 November 2023)
file_path <- here("data", "02_external_emigration", "bg", "Pop_6.1.1_Pop_DR_EN.xls")

# Get the names of all sheets in the Excel file
sheet_names <- excel_sheets(file_path)

# Import all sheets and merge into one dataframe
bg_population <- map_df(sheet_names, function(year) {
  
  # Read data from the current sheet
  df <- read_excel(file_path, sheet = year)
  
  # Perform transformations
  df <- df %>%
    rename_with(~paste0("V", seq_along(.))) %>% # Reset column names to generic names
    select(V1, V2) %>% 
    rename(regionname = V1,
           population = V2) %>% 
    mutate(population = as.numeric(population),
           year = as.numeric(year))  # Convert year from sheet name to numeric
  
  return(df)
})

bg_population <- bg_population %>% 
  drop_na(population) %>% 
  dplyr::filter(regionname != "Total")

# Sofia (stolitsa) has different name in 2010 and 2011
bg_population$regionname[bg_population$regionname == "Sofia cap."] <- "Sofia (stolitsa)"

# Remove rows with duplicate "regionname" values and keep only the one with the higher "abs_population",
bg_population <- bg_population %>%
  group_by(regionname, year) %>%
  top_n(1, population) %>%
  ungroup()

# Add NUTS3
bg_population <- bg_population %>% 
  left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>% 
  drop_na(NUTS_ID) %>% 
  distinct(year, NUTS_ID, .keep_all = T) %>%
  select(year, NUTS_ID, regionname, population)


## Calculate crude net migration --------------------------------
# Use same calculation of net migration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

bg <- bg_net_migration %>% 
  left_join(select(bg_population, -regionname), by = c("year", "NUTS_ID")) %>% 
  mutate(crude_net_migration = (net_migration/population) * 1000)


## Export ------------------------------

save(bg, file = here("data", "02_external_emigration", "bg", "bg.Rda"))
