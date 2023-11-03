
# Exploratory Data Analysis -----------------------------------------------

## Bulgaria -------------------------------------------------------------

# Plot crude emigration over time

ggplot(bg, aes(x = year, y = crude_emigration, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()


## Croatia -------------------------------------------------------------

# Plot crude emigration over time

ggplot(hr, aes(x = year, y = crude_emigration, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()
