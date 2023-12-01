
# Plot Setup -------------------------------------------------------------------

# Define ggplot parameters
plot_scale <- 3
plot_width <- 900
plot_height <- 1500
plot_units <-  "px"
plot_dpi <-  300
plot_bg <-  "white"
save_here <- here("documentation")

# Exploratory Data Analysis -----------------------------------------------

# Plot crude emigration over time

ggplot(cee_crude_emigration, aes(x = year, y = emigration_yearly_per_1000, group = NUTS_ID)) +
  geom_line() +
  facet_wrap(~ country,
             scales = "free_y",
             ncol = 2) +
  ggtitle("Crude Emigration per 1000 Population at NUTS3 Level") +
  #xlab(" ") +
  ylab(" ") +
  # scale_x_discrete(breaks = seq(min(cee_crude_emigration$year, na.rm = TRUE), 
                                  # max(cee_crude_emigration$year, na.rm = TRUE), by = 5)) +
  theme_minimal()

ggsave(
  paste0(save_here, "/cee_crude_emigration.png"),
  last_plot(),
  scale = plot_scale,
  width = plot_width,
  height = plot_height,
  dpi = plot_dpi,
  units = plot_units,
  bg = plot_bg)

## Bulgaria -------------------------------------------------------------

# Plot crude emigration over time

# ggplot(bg, aes(x = year, y = emigration_yearly_per_1000, line = NUTS_ID)) +
#   geom_line() +
#   theme_minimal()


## Croatia -------------------------------------------------------------

# Plot crude emigration over time

# ggplot(hr, aes(x = year, y = emigration_yearly_per_1000, line = NUTS_ID)) +
#   geom_line() +
#   theme_minimal()


## Poland -------------------------------------------------------------

# Plot schools over time

ggplot(pl, aes(x = year, y = schools_diff, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(average_emigration, aes(x = average_emigration, y = average_schools_diff)) +
  geom_point() +
  theme_minimal()


## EDA for Modelling -------------------------------------------------------------
# Run 03_modelling.R first

hist(anti_incumbent_vote$average_emigration, breaks = 20)

