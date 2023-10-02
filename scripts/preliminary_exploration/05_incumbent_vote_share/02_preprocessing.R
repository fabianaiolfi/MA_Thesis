
# Preprocessing -----------------------------------------------------------

## Romania ---------------

df <- ned %>% 
  dplyr::filter(country == "Romania") %>% 
  dplyr::filter(type == "Parliament")
unique(df$year)
# [1] 2004 2008 2012 2016

### 2008 --------------

Election_RO_2004_2008_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2004) %>% 
  dplyr::filter(party_abbreviation == "PNL-PD") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2004 = party_share)

Election_RO_2004_2008_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2008) %>% 
  dplyr::filter(party_abbreviation == "PNL") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2008 = party_share)

Election_RO_2004_2008 <- Election_RO_2004_2008_t0 %>% 
  left_join(Election_RO_2004_2008_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2008 - incumbent_share_2004)

### 2012 --------------

Election_RO_2008_2012_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2008) %>% 
  dplyr::filter(party_abbreviation == "PDL") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2008 = party_share)

Election_RO_2008_2012_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2012) %>% 
  dplyr::filter(party_abbreviation == "ARD") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2012 = party_share)

Election_RO_2008_2012 <- Election_RO_2008_2012_t0 %>% 
  left_join(Election_RO_2008_2012_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2012 - incumbent_share_2008)

### 2016 --------------

Election_RO_2012_2016_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2012) %>% 
  dplyr::filter(party_abbreviation == "USL") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2012 = party_share)

Election_RO_2012_2016_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2016) %>% 
  dplyr::filter(party_abbreviation == "PSD") %>% # https://en.wikipedia.org/wiki/Social_Liberal_Union#Dissolution
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2016 = party_share)

Election_RO_2012_2016 <- Election_RO_2012_2016_t0 %>% 
  left_join(Election_RO_2012_2016_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2016 - incumbent_share_2012)


## Poland ---------------

df <- ned %>% 
  dplyr::filter(country == "Poland") %>% 
  dplyr::filter(type == "Parliament")
unique(df$year)
# [1] 2001 2005 2007 2011 2015 2019

### 2007 --------------

Election_PL_2005_2007_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2005) %>% 
  dplyr::filter(party_abbreviation == "PIS") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2005 = party_share)

Election_PL_2005_2007_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2007) %>% 
  dplyr::filter(party_abbreviation == "PIS") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2007 = party_share)

Election_PL_2005_2007 <- Election_PL_2005_2007_t0 %>% 
  left_join(Election_PL_2005_2007_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2007 - incumbent_share_2005)

### 2011 --------------

Election_PL_2007_2011_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2007) %>% 
  dplyr::filter(party_abbreviation == "PO") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2007 = party_share)

Election_PL_2007_2011_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2011) %>% 
  dplyr::filter(party_abbreviation == "PO") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2011 = party_share)

Election_PL_2007_2011 <- Election_PL_2007_2011_t0 %>% 
  left_join(Election_PL_2007_2011_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2011 - incumbent_share_2007)

### 2015 --------------

Election_PL_2011_2015_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2011) %>% 
  dplyr::filter(party_abbreviation == "PO") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2011 = party_share)

Election_PL_2011_2015_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2015) %>% 
  dplyr::filter(party_abbreviation == "PO") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2015 = party_share)

Election_PL_2011_2015 <- Election_PL_2011_2015_t0 %>% 
  left_join(Election_PL_2011_2015_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2015 - incumbent_share_2011)

### 2019 --------------

Election_PL_2015_2019_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2015) %>% 
  dplyr::filter(party_abbreviation == "PIS") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2015 = party_share)

Election_PL_2015_2019_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year == 2019) %>% 
  dplyr::filter(party_abbreviation == "PIS") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2019 = party_share)

Election_PL_2015_2019 <- Election_PL_2015_2019_t0 %>% 
  left_join(Election_PL_2015_2019_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2019 - incumbent_share_2015)


## Bulgaria ---------------

df <- ned %>% 
  dplyr::filter(country == "Bulgaria") %>% 
  dplyr::filter(type == "Parliament")
unique(df$year)
# [1] 2005 2009 2013 2014 2017

### 2009 --------------

Election_BG_2005_2009_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(nuts2016 != "BGZZZ") %>% 
  dplyr::filter(year == 2005) %>% 
  dplyr::filter(party_abbreviation == "KB") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2005 = party_share)

Election_BG_2005_2009_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>%
  dplyr::filter(nuts2016 != "BGZZZ") %>% 
  dplyr::filter(year == 2009) %>% 
  dplyr::filter(party_abbreviation == "KB") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2009 = party_share)

Election_BG_2005_2009 <- Election_BG_2005_2009_t0 %>% 
  left_join(Election_BG_2005_2009_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2009 - incumbent_share_2005)


### 2013 --------------

Election_BG_2009_2013_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(nuts2016 != "BGZZZ") %>% 
  dplyr::filter(year == 2009) %>% 
  dplyr::filter(party_abbreviation == "GERB") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2009 = party_share)

Election_BG_2009_2013_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>%
  dplyr::filter(nuts2016 != "BGZZZ") %>% 
  dplyr::filter(year == 2013) %>% 
  dplyr::filter(party_abbreviation == "GERB") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2013 = party_share)

Election_BG_2009_2013 <- Election_BG_2009_2013_t0 %>% 
  left_join(Election_BG_2009_2013_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2013 - incumbent_share_2009)

### 2014 --------------

Election_BG_2013_2014_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(nuts2016 != "BGZZZ") %>% 
  dplyr::filter(year == 2013) %>% 
  dplyr::filter(party_abbreviation == "KB") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2013 = party_share)

Election_BG_2013_2014_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>%
  dplyr::filter(nuts2016 != "BGZZZ") %>% 
  dplyr::filter(year == 2014) %>% 
  dplyr::filter(party_abbreviation == "KB") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2014 = party_share)

Election_BG_2013_2014 <- Election_BG_2013_2014_t0 %>% 
  left_join(Election_BG_2013_2014_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2014 - incumbent_share_2013)

### 2017 --------------

Election_BG_2014_2017_t0 <- ned %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(nuts2016 != "BGZZZ") %>% 
  dplyr::filter(year == 2014) %>% 
  dplyr::filter(party_abbreviation == "GERB") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2014 = party_share)

Election_BG_2014_2017_t1 <- ned %>% 
  dplyr::filter(type == "Parliament") %>%
  dplyr::filter(nuts2016 != "BGZZZ") %>% 
  dplyr::filter(year == 2017) %>% 
  dplyr::filter(party_abbreviation == "GERB") %>% 
  select(nuts2016, party_share) %>% 
  rename(incumbent_share_2017 = party_share)

Election_BG_2014_2017 <- Election_BG_2014_2017_t0 %>% 
  left_join(Election_BG_2014_2017_t1, by = "nuts2016") %>% 
  mutate(incumbent_change = incumbent_share_2017 - incumbent_share_2014)
