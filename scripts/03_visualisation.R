
# Maps --------------------------------------------------------------------

# Load the shapefile
# https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts
nuts3_shape <- st_read(here("data", "NUTS_RG_10M_2021_3035_shp", "NUTS_RG_10M_2021_3035.shp"))
nuts3_shape_2016 <- st_read(here("data", "NUTS_RG_10M_2016_3035_shp", "NUTS_RG_10M_2016_3035.shp"))

# Get country borders
nuts0_shape <- nuts3_shape %>% dplyr::filter(LEVL_CODE == 0)

# Merge the data
merged_data <- left_join(nuts3_shape, net_migr_nuts3_pp, by = c("NUTS_ID" = "nuts3"))
merged_data_2016 <- left_join(nuts3_shape_2016, net_migr_nuts3_pp, by = c("NUTS_ID" = "nuts3"))

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


ggplot() +
  geom_sf(data = merged_data, aes(fill = year_2000_fct), color = "#333333", lwd = 0.1) +
  geom_sf(data = nuts0_shape, fill = NA, color = "black", lwd = 0.6) +  # highlight national borders
  coord_sf(xlim = c(2500000, 7100000), ylim = c(1500000, 5300000)) + # Coordinate reference system:	3035
  scale_fill_brewer(palette = "PRGn")


# Plot Map Over Time
for (year in 2000:2021) {
  column_name <- paste0("year_", year, "_fct")
  p <- ggplot() +
    geom_sf(data = merged_data_2016, aes_string(fill = column_name), color = "#333333", lwd = 0.05) +
    geom_sf(data = nuts0_shape, fill = NA, color = "black", lwd = 0.3) +
    coord_sf(xlim = c(2500000, 7100000), ylim = c(1500000, 5300000)) +
    scale_fill_brewer(palette = "PRGn") +
    theme_minimal() +
    theme(panel.grid = element_blank(), # remove grid
          axis.title = element_blank(), # remove axis labels
          axis.text = element_blank()) +  # remove axis text
    labs(title = year, fill = "Net Migration")
  
  ggsave(paste0(here("scripts", "shiny_app", "www", "/"), "map_", year, ".png"), plot = p)
}

