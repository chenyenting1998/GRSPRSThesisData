# 2021/07/12
# Chen, Yen-Ting

# Comment:
# The file `env.xlsx` joins the two file `ctd_bw.xlsx` and `sed.xlsx`. The depth of each station 
# is then added to the file.

# library
library(dplyr)
library(tidyr)
library(readxl)
library(writexl)
library(ggplot2)

# read env
bw <- read_xlsx("data/ctd_bw.xlsx")
sed <- read_xlsx("data/sed.xlsx")

# env =  sed + bw
env <-
  bw %>%
  filter(Station %in% sed$Station) %>%
  full_join(sed, by = c("Cruise", "Station"))

# add location
env$Location <-
  ifelse(test = env$Station %in% c("S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "GC1", "GS1"),
         "GRS",
         "PRS")

# relocate `Location`
env <-
  env %>% 
  relocate(Location, .after = Cruise)

# remove deep sea stations
# second thought : no need to do that
#env <-
#  env %>%
#  filter(!(Station %in% c("GC1", "GS1")))

# add depth
depth <- read_xlsx("data/depth.xlsx")
env <- left_join(depth, env, by = c("Cruise", "Station"))

# relocate depth
env <-
  env %>% 
  relocate(Depth, .after = pressure) 

# remove pressure
env$pressure <- NULL

# write env.xlsx
write_xlsx(env, "data/env.xlsx")
