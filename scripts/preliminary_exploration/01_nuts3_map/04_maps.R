
# Setup -------------------------------------------------------------------

# Define ggplot parameters
plot_scale <- 3
plot_width <- 2000
plot_height <- 2000
plot_units <-  "px"
plot_dpi <-  300
plot_bg <-  "white"
save_here <- here("documentation")


# Maps --------------------------------------------------------------------

# Load the shapefile for maps
# https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts
nuts3_shape <- st_read(here("data", "NUTS_RG_10M_2021_3035_shp", "NUTS_RG_10M_2021_3035.shp"))
nuts3_shape_2016 <- st_read(here("data", "NUTS_RG_10M_2016_3035_shp", "NUTS_RG_10M_2016_3035.shp"))

# Get country borders
nuts0_shape <- nuts3_shape %>% dplyr::filter(LEVL_CODE == 0)

# Map overlay for Kolloquium Presentation
cee <- c("BG", "HR", "CZ", "EE", "HU", "LV", "LT", "PL", "RO", "SK", "SI") # CEE NUTS0
nuts0_overlay <- nuts0_shape %>% 
  dplyr::filter(!NUTS_ID %in% cee)

# Merge the data
merged_data <- left_join(nuts3_shape, net_migr_nuts3_pp, by = c("NUTS_ID" = "nuts3"))
merged_data_2016 <- left_join(nuts3_shape_2016, net_migr_nuts3_pp, by = c("NUTS_ID" = "nuts3"))


## Map for Research Proposal --------------------------------------------------------------------

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
        axis.text = element_blank(),  # remove axis text
        legend.position = c(0.8, 0.5),  # x, y coordinates for legend. Ranges from 0 to 1.
        legend.text = element_text(size = 18),  # Increase the font size for legend items
        legend.title = element_text(size = 20, face = "bold")  # Increase the font size for the legend title
  ) +
  labs(fill = "Net Migration")
#labs(title = "Average Net (Internal and External) Migration 2000–2021 at NUTS3 Level", fill = "Net Migration")


## Map for Kolloquium Presentation --------------------------------------------------------------------

ggplot() +
  geom_sf(data = merged_data, aes(fill = avg_fct), color = "#333333", lwd = 0.1) +
  geom_sf(data = nuts0_shape, fill = NA, color = "black", lwd = 0.6) +  # highlight national borders
  geom_sf(data = nuts0_overlay, fill = alpha("#FFFFFF", .8)) +  # Toggle Overlay
  coord_sf(xlim = c(2500000, 7100000), ylim = c(1500000, 5300000)) + # Coordinate reference system:	3035
  scale_fill_brewer(palette = "PRGn") + # Discrete scale
  theme_minimal() +
  theme(panel.grid = element_blank(), # remove grid
        axis.title = element_blank(), # remove axis labels
        axis.text = element_blank(),  # remove axis text
        legend.position = c(0.8, 0.5),  # x, y coordinates for legend. Ranges from 0 to 1.
        legend.text = element_text(size = 18),  # Increase the font size for legend items
        legend.title = element_text(size = 20, face = "bold")  # Increase the font size for the legend title
  ) +
  labs(fill = "Net Migration")

ggsave(
  paste0(save_here, "/map_overlay.png"),
  last_plot(),
  scale = plot_scale,
  width = plot_width,
  height = plot_height,
  dpi = plot_dpi,
  units = plot_units,
  bg = plot_bg)



## Plot Map Over Time --------------------------------------------------------------------
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