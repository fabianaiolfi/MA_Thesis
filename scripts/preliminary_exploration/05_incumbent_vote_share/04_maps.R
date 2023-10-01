
# Get country borders
nuts0_shape <- nuts3_shape %>% dplyr::filter(LEVL_CODE == 0)

# Romania -----------------------------------------------------------------

# Merge the data
merged_data <- left_join(nuts3_shape, model_pl_2019, by = c("NUTS_ID" = "NUTS"))
merged_data <- merged_data %>% drop_na(incumbent_change)

# Factor
summary(merged_data$incumbent_change)
bins <- c(-40, -20, -10, 0, 10, 20, 40) # define bin edges
labels <- c("More than 20% decrease", "-20% - 10%", "-10% - 0%", "0% - 10%", "10% - 20%", "More than 20% increase") # labels for the intervals
merged_data$incumbent_change_factor <- cut(merged_data$incumbent_change, breaks = bins, labels = labels, right = TRUE, include.lowest = TRUE)

ggplot() +
  geom_sf(data = merged_data, aes(fill = incumbent_change_factor), color = "#333333", lwd = 0.1) +
  geom_sf(data = nuts0_shape, fill = NA, color = "black", lwd = 0.3) +
  #coord_sf(xlim = c(5000000, 6000000), ylim = c(2400000, 3000000)) + # Coordinate reference system:	3035
  coord_sf(xlim = c(2500000, 7100000), ylim = c(1500000, 5300000)) + # Coordinate reference system:	3035
  scale_fill_brewer(palette = "Spectral") + # Discrete scale
  theme_minimal() +
  theme(panel.grid = element_blank(), # remove grid
        axis.title = element_blank(), # remove axis labels
        axis.text = element_blank())  # remove axis text
