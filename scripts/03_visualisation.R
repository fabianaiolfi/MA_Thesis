
# Maps --------------------------------------------------------------------

# Load the shapefile for maps
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


# Does NUTS3 border another country? --------------------------------------------------------------------

# Load NUTS3 shapefile and calculate the borders of each NUTS3 region
borders <- st_boundary(nuts3_shape)

# Find which borders intersect with each other
intersections <- st_intersection(borders)

# This gives you a new sf object where each element is a border segment that is shared by two regions.
# The original data from the nuts3 object is preserved, so you can see which regions are involved in each intersection.

# If you want to find which NUTS3 regions border a different country, you could use a separate shapefile with country data.

# Use country shapefile and calculate the borders of each country
country_borders <- st_boundary(nuts0_shape)

# Find which NUTS3 regions intersect with a country border
country_intersections <- st_intersection(borders, country_borders)
# This gives you a new sf object where each element is a border segment that is shared by a NUTS3 region and a country.

country_intersections_edit <- country_intersections %>% 
  dplyr::filter(CNTR_CODE != CNTR_CODE.1)

nuts3_on_border <- country_intersections_edit$NUTS_ID

net_migr_nuts3_pp <- net_migr_nuts3_pp %>% 
  mutate(on_border = if_else(nuts3 %in% nuts3_on_border, TRUE, FALSE))


# Line Plots --------------------------------------------------------------------

# Filter CEE
cee <- c("BG", "HR", "CZ", "EE", "HU", "LV", "LT", "PL", "RO", "SK", "SI")
net_migr_nuts3_pp_cee <- net_migr_nuts3_pp %>% 
  dplyr::filter(country %in% cee)

# Add typologies
nuts3_typologies_pp <- nuts3_typologies %>% select(`NUTS 3 ID (2010)`, `Rural - urban typology`)
net_migr_nuts3_pp_cee <- net_migr_nuts3_pp_cee %>% 
  left_join(nuts3_typologies_pp, by = c("nuts3" = "NUTS 3 ID (2010)"))

net_migr_nuts3_pp_cee <- net_migr_nuts3_pp_cee %>% drop_na(`Rural - urban typology`)


# reshape the data
long_data <- net_migr_nuts3_pp_cee %>%
  pivot_longer(cols = starts_with("year"), # matches("^year_[0-9]{4}$")
               names_to = "year",
               values_to = "value") %>%
  mutate(year = as.numeric(str_remove(year, "year_")))  # convert year to numeric

# create the line plot
ggplot(long_data, aes(x = year, y = value, group = nuts3)) +
  geom_line(size = 0.5, alpha = 0.25) + geom_point(size = 1, alpha = 0.25) +
  geom_hline(yintercept = 0, color = "red") + 
  facet_wrap(~ country) +
  theme_minimal() +
  ylim(-50, 50) +
  theme(panel.grid.minor = element_blank()) +
  labs(x = "Year", y = "Value",
       title = "Line plot over time by country")

long_data %>% dplyr::filter(`Rural - urban typology` == "Urban region") %>%
  ggplot(aes(x = year, y = value, group = nuts3)) +
  geom_line(size = 0.5) + geom_point(size = 1) +
  geom_hline(yintercept = 0, color = "red") + 
  facet_wrap(~ country) +
  theme_minimal() +
  ylim(-20, 20) +
  theme(panel.grid.minor = element_blank()) +
  labs(x = "Year", y = "Change in %",
       title = "Net Migration in NUTS3 Urban Regions")

# Border Regions

long_data %>% dplyr::filter(on_border == F) %>%
  ggplot(aes(x = year, y = value, group = nuts3)) +
  geom_line(size = 0.5) + geom_point(size = 1) +
  geom_hline(yintercept = 0, color = "red") + 
  facet_wrap(~ country) +
  theme_minimal() +
  ylim(-20, 20) +
  theme(panel.grid.minor = element_blank()) +
  labs(x = "Year", y = "Change in %",
       title = "Net Migration in NUTS3 Interior Regions")



