
# Maps --------------------------------------------------------------------

# Load the shapefile
# https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts
nuts3_shape <- st_read(here("data", "NUTS_RG_10M_2021_3035_shp", "NUTS_RG_10M_2021_3035.shp"))

# Get country borders
nuts0_shape <- nuts3_shape %>% dplyr::filter(LEVL_CODE == 0)

# Merge the data
merged_data <- left_join(nuts3_shape, net_migr_nuts3_pp, by = c("NUTS_ID" = "nuts3"))

# Create the map
ggplot() +
  geom_sf(data = merged_data, aes(fill = avg_fct), color = "#333333", lwd = 0.1) +
  geom_sf(data = nuts0_shape, fill = NA, color = "black", lwd = 0.6) +  # highlight national borders
  #coord_sf(xlim = c(-10, 44), ylim = c(35, 70)) + # Coordinate reference system:	4326
  coord_sf(xlim = c(2500000, 7100000), ylim = c(1500000, 5300000)) + # Coordinate reference system:	3035
  scale_fill_brewer(palette = "PRGn") + # Discrete scale
  # scale_fill_viridis_c() + # Continuous scale
  theme_minimal() +
  theme(panel.grid = element_blank(), # remove grid
        axis.title = element_blank(), # remove axis labels
        axis.text = element_blank()) +  # remove axis text
  labs(title = "Average Net Migration 2000–2021 at NUTS3 Level", fill = "Net Migration")


# Define column names
# year_cols <- paste0("year_", 2000:2021, "_fct")
# 
# # Pivot data to longer format
# merged_data_long <- merged_data %>%
#   pivot_longer(cols = all_of(year_cols),
#                names_to = "year",
#                values_to = "value")
# 
# # Remove the '_fct' suffix from the year column
# merged_data_long$year <- str_remove(merged_data_long$year, "_fct")
# 
# ggplot(merged_data_long, aes(fill = value)) +
#   geom_sf() +
#   coord_sf(xlim = c(-10, 46), ylim = c(35, 70)) +
#   scale_fill_brewer(palette = "Spectral") +
#   theme_minimal() +
#   labs(title = " ", fill = "Net Migration") +
#   facet_wrap(~ year, ncol = 9)
