
# Import Data -------------------------------------------------------------

# https://v-dem.net/data/v-party-dataset/
v_dem <- readRDS(here("data", "V-Dem-CPD-Party-V2.rds"))

# NED
ned <- read.csv(here("data", "eu_ned_joint.csv"))
