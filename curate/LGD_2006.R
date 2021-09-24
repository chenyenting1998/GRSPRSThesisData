# curate LGD_2006

# Comment:
# Macrofauna of LGD_2006
# The size of each individuals are calculated with the series of homemade functions `assign_method`,
# `calculate_biovolume`, and `define_ophiuroid_size`.
# The WM of each individuals were by multipling the volume with a specific weight of 1.13,
# following the assumption of (inset references here).



pacman::p_load(readxl,
               writexl,
               dplyr,
               tidyr,
               easypipe,
               ecomaestro)

#view <- function(df) View(df)

# read LGD_2006 -----------------------------------------------------------
macro <- read_xlsx("data-raw/macrofauna/LGD-2006_macro_size_final.xlsx")

polychaete <-
  read_xlsx("data-raw/macrofauna/LGD_2006 polychaeta size.xlsx",
            col_types = c(rep("guess", 7),
                          rep("text", 2),
                          rep("guess", 8))) %>%
  mutate(Habitat = "Shelf") %>%
  mutate(Deployment = 1) %>%
  mutate(Section = "0-10")

grouping_vairables <- c("Cruise","Habitat","Station","Deployment","Tube","Section")

# calculate size
macro_size <-
  macro %>%
  full_join(polychaete) %>%
  assign_method() %>%
  calculate_biovolume() %>%
  define_ophiuroid_size(protocol_ophiuroid = "all_arms",
                        grouping_variables = grouping_vairables) %>%
  mutate(WM = Size * 1.13) # WM

# change the name "method" to "type"
macro_size$Type <- NULL
colnames(macro_size)[17] <- "Type"

# remove hydrozoa stalk
macro_size <-
  macro_size %>%
  filter(!(Taxon == "Hydrozoa" & Note == "Stalk"))

# write xlsx --------------------------------------------------------------
# write: LGD_2006_macrofauna_size.xlsx
macro_size %>%
  write_xlsx("data/LGD_2006_macrofauna_size.xlsx")

# write: LGD_2006_macrofauna_count.xlsx
# write_xlsx(macro_abu, "data/LGD_2006_macrofauna_count.xlsx")
