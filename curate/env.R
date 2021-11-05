# 2021/07/12
# Chen, Yen-Ting

# Comment:
# The file `env.xlsx` joins the two file `ctd_bw.xlsx` and `sed.xlsx`. The depth of each station
# is then added to the file.

# library
pacman::p_load(readxl,
               writexl,
               dplyr,
               tidyr,
               usethat,
               GRSPRSThesisData)
# read env
bw <- read_xlsx("xlsx/ctd_bw.xlsx")
sed <- read_xlsx("xlsx/sed.xlsx")

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

# # add depth
# depth <- read_xlsx("xlsx/depth.xlsx")
# env <- left_join(depth, env, by = c("Cruise", "Station"))
#
# # relocate depth
# env <-
#   env %>%
#   relocate(Depth, .after = pressure)

# remove redundant variables
env$pressure <- NULL
env$WW <- NULL
env$DW <- NULL

# # oxygen consumptoin ----------------------------------------------------
GRS_TOU <- # mmol/m2/day
  read_xlsx("xlsx/GPSC_incubation_2021.08.11.xlsx", sheet = 2) %>%
  filter(Cruise %in% c("OR1_1242", "OR1_1219", "LGD_2006")) %>% # subset cruises
  mutate(TOU =  abs(In_situ_DO_flux)) %>%
  group_by(Cruise, Station) %>%
  summarise(Depth = mean(Depth), TOU = mean(TOU))

GRS_DOU <- # nmol cm-2 s-1
  read.csv("xlsx/GPSC_DOU.csv") %>%
  filter(Cruise %in% c("OR1_1242", "OR1_1219", "LGD_2006")) %>%
  mutate(DOU = In_situ_Integrated_Prod / 1000000 * 10000 * 60 * 60 * 24) %>%
  #                                      mmol      m-2     day-1
  group_by(Cruise, Station) %>%
  summarize(DOU = mean(abs(DOU)),
            OPD = mean(OPD/10000)) # um to cm

PRS_OU <-
  read_xlsx("xlsx/LGD2006_Oxygen utility data.xlsx") %>%
  mutate(Depth = `Water depth`,
         Station = Site,
         Cruise = "LGD_2006") %>% # - to _
  select(Cruise, Station, Depth, TOU, DOU, BOU, OPD)


OU <-
  left_join(GRS_DOU, GRS_TOU, by = c("Cruise", "Station")) %>%
  mutate(BOU = TOU - DOU) %>%
  full_join(PRS_OU) %>%
  relocate(DOU, .before = BOU) %>%
  relocate(OPD, .after = BOU)

env <- env %>% left_join(OU, by = c("Cruise", "Station"))

# write env.xlsx
use_data(env, overwrite = T)
