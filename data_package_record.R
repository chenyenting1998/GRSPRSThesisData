# do not rerun this file
pacman::p_load(usethat,testthat,rmarkdown, roxygen2, knitr,
               devtools, readxl, dplyr)

has_devel()

# create package
# path <- "C:/Users/tumha/Desktop/Lab Work/R_packages/GRSPRSThesisData"
# create_package(path = path)


# read files --------------------------------------------------------------

## biovolume method ------------------------------------------------------
biovolume_methods <- read_xlsx("xlsx/biovolume_method.xlsx")
use_data(biovolume_methods, overwrite = T)


## coarse taxa -----------------------------------------------------------
coarse_taxa <- read_xlsx("xlsx/coarse_taxa.xlsx")
use_data(coarse_taxa, overwrite = T)


## conversion factors ----------------------------------------------------
conversion_factors <- read_xlsx("xlsx/BenthicPB_import.xlsx", sheet = 1)
View(conversion_factors)
use_data(conversion_factors, overwrite = T)


## ANN parameters --------------------------------------------------------
ANN_parameters <- read_xlsx("xlsx/BenthicPB_import.xlsx", sheet = 2)
# View(ANN_parameters)
mgwm <- conversion_factors[conversion_factors$Conversion_factors == "J / mgWM", c("Taxon", "Mean")]
colnames(mgwm)[2] <- "ConFac_j2mgwm"

mgc <- conversion_factors[conversion_factors$Conversion_factors == "J / mgC", c("Taxon", "Mean")]
colnames(mgc)[2] <- "ConFac_j2mgc"

ANN_parameters <-
  ANN_parameters %>%
  select(-ConFac_j2mgwm , -ConFac_j2mgc ) %>%
  left_join(mgwm, by = "Taxon") %>%
  relocate(ConFac_j2mgwm, .after = Taxon) %>%
  left_join(mgc, by = "Taxon") %>%
  relocate(ConFac_j2mgc, .after = ConFac_j2mgwm)

# match is confusing as fuck
# let match(a, b)
# in brief, match tells you the new location of b in terms of a
use_data(ANN_parameters, overwrite = T)


# # oxygen consumptoin ----------------------------------------------------

GRS_TOU <- # mmol/m2/day
  read_xlsx("xlsx/GPSC_incubation_2021.08.11.xlsx", sheet = 2) %>%
  filter(Cruise %in% c("OR1_1242", "OR1_1219", "LGD_2006")) %>% # subset cruises
  filter(! Station %in% c("GS1", "GC1")) %>%
  mutate(TOU =  abs(In_situ_DO_flux)) %>%
  group_by(Cruise, Station) %>%
  summarise(Depth = mean(Depth), TOU = mean(TOU))

GRS_DOU <- # nmol cm-2 s-1
  read.csv("xlsx/GPSC_DOU.csv") %>%
  filter(Cruise %in% c("OR1_1242", "OR1_1219", "LGD_2006")) %>%
  filter(!Station %in% c("GS1", "GC1")) %>%
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

env <- env[-7] %>% left_join(OU, by = c("Cruise", "Station"))

use_data(env, overwrite = T)
use_data_raw("env")

# final testing -----------------------------------------------------------
document()

load_all()

test_that()
