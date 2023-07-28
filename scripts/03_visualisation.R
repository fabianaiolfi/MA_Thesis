
# Maps --------------------------------------------------------------------

#glimpse(net_migr_nuts3_pp, w)

#net_migr_nuts3_pp %>% select(nuts3, year_2000, year_2001, year_2002) %>% head()


# Load the shapefile
# https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts
#nuts3_shape <- st_read(here("data", "NUTS_RG_20M_2021_3035_shp", "NUTS_RG_20M_2021_3035.shp"))
nuts3_shape <- st_read(here("data", "NUTS_RG_20M_2021_4326_shp", "NUTS_RG_20M_2021_4326.shp"))
# nuts3_shape <- st_read(here("data", "NUTS_RG_20M_2021_3857_shp", "NUTS_RG_20M_2021_3857.shp"))
#nuts3_shape <- st_read(here("data", "NUTS_RG_60M_2021_3035_shp", "NUTS_RG_60M_2021_3035.shp"))
#nuts3_shape <- st_read(here("data", "NUTS_RG_01M_2021_3035_shp", "NUTS_RG_01M_2021_3035.shp"))

nuts0_shape <- nuts3_shape %>% dplyr::filter(LEVL_CODE == 0)

# Transform to WGS 84
# nuts3_shape_wgs84 <- st_transform(nuts3_shape, 4326)

# Merge the data
merged_data <- left_join(nuts3_shape, net_migr_nuts3_pp, by = c("NUTS_ID" = "nuts3"))

# Create the map
ggplot() +
  geom_sf(data = merged_data, aes(fill = year_2009_fct), color = "#666666", size = 0.1) +
  geom_sf(data = nuts0_shape, fill = NA, color = "black", size = 5) +  # highlight national borders
  coord_sf(xlim = c(-10, 44), ylim = c(35, 70)) +
  scale_fill_brewer(palette = "PRGn") +
  theme_minimal() +
  theme(panel.grid = element_blank(), # remove grid
        axis.title = element_blank(), # remove axis labels
        axis.text = element_blank()) +  # remove axis text
  labs(title = " ", fill = "Net Migration")



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
#   facet_wrap(~ year)
