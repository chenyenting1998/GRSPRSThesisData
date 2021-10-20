# do not save this file
pacman::p_load(usethat,testthat,rmarkdown, roxygen2, knitr, devtools, readxl)

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
mgc <- conversion_factors[conversion_factors$Conversion_factors == "J / mgC", c("Taxon", "Mean")]

ANN_parameters$ConFac_j2mgwm <- mgwm[match(ANN_parameters$Taxon, mgwm$Taxon), "Mean"]
ANN_parameters$ConFac_j2mgc  <- mgc[match(ANN_parameters$Taxon, mgc$Taxon), "Mean"]
# match is confusing as fuck
# let match(a, b)
# in brief, match tells you the new location of b in terms of a
ANN_parameters <- data.frame(ANN_parameters)
use_data(ANN_parameters, overwrite = T)

document()

load_all()

test_that()
