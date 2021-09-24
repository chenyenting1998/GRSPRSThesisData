pacman::p_load(readxl,
               writexl,
               dplyr,
               tidyr,
               usethis,
               ncdf4)

# read .nc
map_nc_path <- dir(path = "xlsx/GEBCO_2020", pattern = "2020.nc", full.names = T)
map_nc <- nc_open(map_nc_path)

# extract lon. and lat.
Longitude <- ncvar_get(map_nc, "lon")
Latitude <- ncvar_get(map_nc, "lat")
Elevation <- ncvar_get(map_nc, "elevation")

# entries as elevation with each row and columns as lats and longs
map <-
  expand.grid(Longitude = Longitude,
              Latitude = Latitude) %>%
  cbind(Elevation = as.vector(Elevation))

bathy_map <- map

bathy_map <-
  bathy_map %>%
  filter(Longitude < 122 & Longitude > 108) %>%
  filter(Latitude < 25.5 & Latitude > 18)

use_data(bathy_map, overwrite = T)
