# curate OR1_1219
pacman::p_load(readxl,
               writexl,
               dplyr,
               tidyr,
               devtools,
               GRSPRSThesisData)

# read OR1_1219 -----------------------------------------------------------
macro <-
  read_xlsx("xlsx/OR1_1219_macro_size_final.xlsx",
            col_types = c(rep("guess", 7),
                          rep("text", 2),
                          rep("guess", 8))) %>%
  mutate(Section = "0-10")

# read Ms. Yen Li's mea.
polychaete <-
  read_xlsx("xlsx/OR1_1219_polychaeta_size.xlsx") %>%
  mutate(Deployment = as.numeric(gsub(".*-", "", Station))) %>%
  mutate(Station = gsub("-.*", "", Station)) %>%
  mutate(Habitat = if_else(Station %in% "GC1", "Canyon",
                           if_else(Station %in% "GS1", "Slope", "Shelf"))) %>%
  mutate(Section = "0-10")

# View(macro)
grouping_vairables <- c("Cruise","Habitat","Station","Deployment","Tube","Section")

# # add a new method for the stony coral
# method <- biovolume_method
# # colnames(method)
# scler <- data.frame(Taxon = "Scleractinia",
#            Note = NA_character_,
#            Method = "Cylinder",
#            C = NA_real_,
#            C_orgin = NA_character_,
#            Comment = NA_character_)
# method <-
#   full_join(method, scler)

#
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

# write: OR1_1219_macrofauna_size.xlsx
OR1_1219 <- macro_size
OR1_1219$Region <- "GRS"
size_OR1_1219 <- OR1_1219[, c("Cruise", "Habitat", "Region", "Station","Deployment", "Tube", "Section", "Taxon","Family", "Genus", "Condition", "L","W", "a", "b", "Size","Note", "Type", "C", "WM")]
use_data(size_OR1_1219, overwrite = T)
