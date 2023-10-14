
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
nuts3_typologies_pp <- nuts3_typologies %>% select(NUTS0, `NUTS 3 ID (2010)`, `Rural - urban typology`)
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


# Bar Plots of Averages --------------------------------------------------------------------
# Averages of Typologies (urban, intermediate, rural, bordering, interior)

net_migr_nuts3_pp_cee_avg <- net_migr_nuts3_pp_cee %>% 
  select(country, `Rural - urban typology`, year_2000:year_2021, on_border) %>% 
  # group_by(country, `Rural - urban typology`) %>%
  group_by(country, on_border) %>%
  summarise_at(vars(starts_with("year_")), mean) %>% # na.rm = TRUE
  ungroup() %>% 
  mutate(across(starts_with("year_"), ~replace(., is.nan(.), NA)))

long_data <- net_migr_nuts3_pp_cee_avg %>% 
  pivot_longer(cols = starts_with("year_"), names_to = "Year", values_to = "Value")

long_data$Year <- gsub('year_', '', long_data$Year)
long_data$Year <- as.numeric(long_data$Year)

long_data <- long_data %>% 
  left_join(eu_accession, by = c("country" = "Country Code"))

# long_data %>% dplyr::filter(`Rural - urban typology` == "Urban region") %>%
long_data %>% dplyr::filter(on_border == T) %>%
  ggplot(aes(x = Year, y = Value)) + 
  geom_bar(aes(fill = Value > 0), stat="identity", show.legend = F) +
  geom_vline(aes(xintercept = year(`Accession Date`)), linetype="dashed") +
  scale_fill_manual(values = c("TRUE" = "light green", "FALSE" = "red")) +
  facet_wrap(~ country) +
  theme_minimal() +
  coord_cartesian(ylim = c(-20, 20)) + # Limit y-axis but larger bars are still displayed
  theme(panel.grid.minor = element_blank()) +
  labs(x = "Year", y = "Change in %",
       # title = "Average Net Migration in NUTS3 Urban Regions")
       title = "Average Net Migration in NUTS3 Border Regions")
