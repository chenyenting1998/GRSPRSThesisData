# curate OR1_1242

# Comment:
#
# First filling the metadata, and then calculate the biovolume of each individuals
# with the series of homemade functions `assign_method`, `calculate_biovolume`, and
# `define_ophiuroid_size`. The WM of each individuals were by multiplying the volume
# with a specific weight of 1.13, following the assumption of (inset references here).
pacman::p_load(readxl,
               writexl,
               dplyr,
               tidyr,
               usethat,
               GRSPRSThesisData)
# source("source/ggplot_theme_func.R")
# theme_set(large)

# read OR1_1242 -----------------------------------------------------------
macro <- read_xlsx("xlsx/OR1_1242_macro_size_final.xlsx")
polychaete <-
  read_xlsx("xlsx/OR1_1242_polychaeta_size.xlsx") %>%
  mutate(Habitat = if_else(Station %in% "GC1", "Canyon",
                           if_else(Station %in% "GS1", "Slope", "Shelf"))) %>%
  mutate(Section = "0-10")

# Note that volume of polychaetes were estimated via geometric shapes (i.e. cylinder, ellipse)
# and I am going to overwrite the volume data with LWR

# calculate size
grouping_vairables <- c("Cruise","Habitat","Station","Deployment","Tube","Section")

macro_size <-
  macro %>%
  full_join(polychaete) %>%
  assign_method(method_file = biovolume_methods) %>%
  calculate_biovolume() %>%
  define_ophiuroid_size(protocol_ophiuroid = "all_arms",
                        grouping_variables = grouping_vairables) %>%
  mutate(WM = Size * 1.13)


macro_size$Type <- NULL
colnames(macro_size)[17] <- "Type"

# remove hydrozoa stalk
macro_size <-
  macro_size %>%
  filter(!(Taxon == "Hydrozoa" & Note == "Stalk"))

# write: OR1_1242_macrofauna_size
OR1_1242<- macro_size
use_data(OR1_1242, overwrite = T)
