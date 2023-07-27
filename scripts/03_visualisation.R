
# Maps --------------------------------------------------------------------

#glimpse(net_migr_nuts3_pp, w)

#net_migr_nuts3_pp %>% select(nuts3, year_2000, year_2001, year_2002) %>% head()


# Load the shapefile
nuts3_shape <- st_read(here("data", "NUTS_RG_20M_2021_3035_shp", "NUTS_RG_20M_2021_3035.shp"))

# Transform to WGS 84
nuts3_shape_wgs84 <- st_transform(nuts3_shape, 4326)

# Merge the data
merged_data <- left_join(nuts3_shape_wgs84, net_migr_nuts3_pp, by = c("NUTS_ID" = "nuts3"))

# Create the map
ggplot() +
  geom_sf(data = merged_data, aes(fill = year_2010_fct)) +
  coord_sf(xlim = c(-10, 46), ylim = c(35, 70)) +
  scale_fill_brewer(palette = "Spectral") +
  theme_minimal() +
  labs(title = " ", fill = "Net Migration")
