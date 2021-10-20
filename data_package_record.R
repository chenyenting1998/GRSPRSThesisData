# do not save this file
pacman::p_load(usethat,testthat,rmarkdown, roxygen2, knitr, devtools, readxl, dplyr)

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

document()

load_all()

test_that()
