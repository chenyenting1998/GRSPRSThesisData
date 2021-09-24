pacman::p_load(readxl,
               writexl,
               dplyr,
               tidyr,
               usethis)

grs_map_name <- dir(path = "xlsx", pattern = ".xyz", full.names = T)
grs_map <- read.table(grs_map_name)
names(grs_map) <- c("Longitude", "Latitude", "Elevation")

use_data(grs_map, overwrite = T)
