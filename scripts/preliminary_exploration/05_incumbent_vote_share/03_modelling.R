
# Modelling -------------------------------------------------------------


## Croatia -------------------------------

### 2015 -------------------------------

emigration_hr_2015 <- Emigration %>% 
  dplyr::filter(Country == "Croatia") %>% 
  select(NUTS, emigration_share_2011, emigration_share_2012, emigration_share_2013, emigration_share_2014) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_hr_2015 <- emigration_hr_2015 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_HR_2011_2015, NUTS, incumbent_change), by = "NUTS")

plot(model_hr_2015$average_emigration, model_hr_2015$incumbent_change)
summary(lm(model_hr_2015$incumbent_change ~ model_hr_2015$average_emigration))

### 2016 -------------------------------

emigration_hr_2016 <- Emigration %>% 
  dplyr::filter(Country == "Croatia") %>% 
  select(NUTS, emigration_share_2015) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_hr_2016 <- emigration_hr_2016 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_HR_2015_2016, NUTS, incumbent_change), by = "NUTS")

plot(model_hr_2016$average_emigration, model_hr_2016$incumbent_change)
summary(lm(model_hr_2016$incumbent_change ~ model_hr_2016$average_emigration))

### 2020 -------------------------------

emigration_hr_2020 <- Emigration %>% 
  dplyr::filter(Country == "Croatia") %>% 
  select(NUTS, emigration_share_2016, emigration_share_2017, emigration_share_2018, emigration_share_2019) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_hr_2020 <- emigration_hr_2020 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_HR_2016_2020, NUTS, incumbent_change), by = "NUTS")

plot(model_hr_2020$average_emigration, model_hr_2020$incumbent_change)
summary(lm(model_hr_2020$incumbent_change ~ model_hr_2020$average_emigration))

## Romania -------------------------------

### 2008 -------------------------------

emigration_ro_2008 <- Emigration %>% 
  dplyr::filter(Country == "Romania") %>% 
  select(NUTS, emigration_share_2004, emigration_share_2005, emigration_share_2006, emigration_share_2007) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_ro_2008 <- emigration_ro_2008 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_RO_2004_2008, nuts2016, incumbent_change), by = c("NUTS" = "nuts2016"))

plot(model_ro_2008$average_emigration, model_ro_2008$incumbent_change)
summary(lm(model_ro_2008$incumbent_change ~ model_ro_2008$average_emigration))


### 2012 -------------------------------

emigration_ro_2012 <- Emigration %>% 
  dplyr::filter(Country == "Romania") %>% 
  select(NUTS, emigration_share_2008, emigration_share_2009, emigration_share_2010, emigration_share_2011) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_ro_2012 <- emigration_ro_2012 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_RO_2008_2012, nuts2016, incumbent_change), by = c("NUTS" = "nuts2016"))

plot(model_ro_2012$average_emigration, model_ro_2012$incumbent_change)
summary(lm(model_ro_2012$incumbent_change ~ model_ro_2012$average_emigration))


### 2016 -------------------------------

emigration_ro_2016 <- Emigration %>% 
  dplyr::filter(Country == "Romania") %>% 
  select(NUTS, emigration_share_2012, emigration_share_2013, emigration_share_2014, emigration_share_2015) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_ro_2016 <- emigration_ro_2016 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_RO_2012_2016, nuts2016, incumbent_change), by = c("NUTS" = "nuts2016"))

plot(model_ro_2016$average_emigration, model_ro_2016$incumbent_change)
summary(lm(model_ro_2016$incumbent_change ~ model_ro_2016$average_emigration))


## Poland -------------------------------

### 2007 -------------------------------

emigration_pl_2007 <- Emigration %>% 
  dplyr::filter(Country == "Poland") %>% 
  select(NUTS, emigration_share_2005, emigration_share_2006) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_pl_2007 <- emigration_pl_2007 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_PL_2005_2007, nuts2016, incumbent_change), by = c("NUTS" = "nuts2016"))

plot(model_pl_2007$average_emigration, model_pl_2007$incumbent_change)
summary(lm(model_pl_2007$incumbent_change ~ model_pl_2007$average_emigration))


### 2011 -------------------------------

emigration_pl_2011 <- Emigration %>% 
  dplyr::filter(Country == "Poland") %>% 
  select(NUTS, emigration_share_2007, emigration_share_2008, emigration_share_2009, emigration_share_2010) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_pl_2011 <- emigration_pl_2011 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_PL_2007_2011, nuts2016, incumbent_change), by = c("NUTS" = "nuts2016"))

plot(model_pl_2011$average_emigration, model_pl_2011$incumbent_change)
summary(lm(model_pl_2011$incumbent_change ~ model_pl_2011$average_emigration))

### 2015 --------------

emigration_pl_2015 <- Emigration %>% 
  dplyr::filter(Country == "Poland") %>% 
  select(NUTS, emigration_share_2011, emigration_share_2012, emigration_share_2013, emigration_share_2014) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_pl_2015 <- emigration_pl_2015 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_PL_2011_2015, nuts2016, incumbent_change), by = c("NUTS" = "nuts2016"))

plot(model_pl_2015$average_emigration, model_pl_2015$incumbent_change)
summary(lm(model_pl_2015$incumbent_change ~ model_pl_2015$average_emigration))

### 2019 --------------

emigration_pl_2019 <- Emigration %>% 
  dplyr::filter(Country == "Poland") %>% 
  select(NUTS, emigration_share_2015, emigration_share_2016, emigration_share_2017, emigration_share_2018) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-NUTS), na.rm = TRUE)) %>%
  ungroup()

model_pl_2019 <- emigration_pl_2019 %>% 
  select(NUTS, average_emigration) %>% 
  left_join(select(Election_PL_2015_2019, nuts2016, incumbent_change), by = c("NUTS" = "nuts2016"))

plot(model_pl_2019$average_emigration, model_pl_2019$incumbent_change)
summary(lm(model_pl_2019$incumbent_change ~ model_pl_2019$average_emigration))


## Bulgaria -------------------------------

### 2009 -------------------------------

emigration_bg_2009 <- net_migr_nuts3 %>% 
  dplyr::filter(str_detect(`GEO (Codes)`, "^BG")) %>% 
  dplyr::filter(str_length(`GEO (Codes)`) == 5) %>% 
  select(`GEO (Codes)`, `GEO (Labels)`, `2005`, `2006`, `2007`, `2008`) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-c(`GEO (Codes)`, `GEO (Labels)`)), na.rm = TRUE)) %>%
  mutate(average_emigration = average_emigration * -1) %>% 
  ungroup()

model_bg_2009 <- emigration_bg_2009 %>% 
  select(`GEO (Codes)`, average_emigration) %>% 
  left_join(select(Election_BG_2005_2009, nuts2016, incumbent_change), by = c("GEO (Codes)" = "nuts2016"))

plot(model_bg_2009$average_emigration, model_bg_2009$incumbent_change)
summary(lm(model_bg_2009$incumbent_change ~ model_bg_2009$average_emigration))


### 2013 -------------------------------

emigration_bg_2013 <- net_migr_nuts3 %>% 
  dplyr::filter(str_detect(`GEO (Codes)`, "^BG")) %>% 
  dplyr::filter(str_length(`GEO (Codes)`) == 5) %>% 
  select(`GEO (Codes)`, `GEO (Labels)`, `2009`, `2010`, `2011`, `2012`) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-c(`GEO (Codes)`, `GEO (Labels)`)), na.rm = TRUE)) %>%
  mutate(average_emigration = average_emigration * -1) %>% 
  ungroup()

model_bg_2013 <- emigration_bg_2013 %>% 
  select(`GEO (Codes)`, average_emigration) %>% 
  left_join(select(Election_BG_2009_2013, nuts2016, incumbent_change), by = c("GEO (Codes)" = "nuts2016"))

plot(model_bg_2013$average_emigration, model_bg_2013$incumbent_change)
summary(lm(model_bg_2013$incumbent_change ~ model_bg_2013$average_emigration))

### 2014 -------------------------------

emigration_bg_2014 <- net_migr_nuts3 %>% 
  dplyr::filter(str_detect(`GEO (Codes)`, "^BG")) %>% 
  dplyr::filter(str_length(`GEO (Codes)`) == 5) %>% 
  select(`GEO (Codes)`, `GEO (Labels)`, `2013`) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-c(`GEO (Codes)`, `GEO (Labels)`)), na.rm = TRUE)) %>%
  mutate(average_emigration = average_emigration * -1) %>% 
  ungroup()

model_bg_2014 <- emigration_bg_2014 %>% 
  select(`GEO (Codes)`, average_emigration) %>% 
  left_join(select(Election_BG_2013_2014, nuts2016, incumbent_change), by = c("GEO (Codes)" = "nuts2016"))

plot(model_bg_2014$average_emigration, model_bg_2014$incumbent_change)
summary(lm(model_bg_2014$incumbent_change ~ model_bg_2014$average_emigration))

### 2017 -------------------------------

emigration_bg_2017 <- net_migr_nuts3 %>% 
  dplyr::filter(str_detect(`GEO (Codes)`, "^BG")) %>% 
  dplyr::filter(str_length(`GEO (Codes)`) == 5) %>% 
  select(`GEO (Codes)`, `GEO (Labels)`, `2014`, `2015`, `2016`) %>% 
  rowwise() %>%
  mutate(average_emigration = mean(c_across(-c(`GEO (Codes)`, `GEO (Labels)`)), na.rm = TRUE)) %>%
  mutate(average_emigration = average_emigration * -1) %>% 
  ungroup()

model_bg_2017 <- emigration_bg_2017 %>% 
  select(`GEO (Codes)`, average_emigration) %>% 
  left_join(select(Election_BG_2014_2017, nuts2016, incumbent_change), by = c("GEO (Codes)" = "nuts2016"))

plot(model_bg_2017$average_emigration, model_bg_2017$incumbent_change)
summary(lm(model_bg_2017$incumbent_change ~ model_bg_2017$average_emigration))
