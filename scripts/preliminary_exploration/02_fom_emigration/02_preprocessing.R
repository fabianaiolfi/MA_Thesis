
# Preprocessing -------------------------------------------------------------

net_int_migration <- net_int_migration_raw %>% 
  dplyr::filter(Country != "Slovakia") # Not enough data available
