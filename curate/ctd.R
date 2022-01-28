# 2021/07/11
# Chen, Yen-Ting
# curate ctd data

# Comment:
#
# The CTD data of four cruises were extracted (i.e. OR1_1219, OR3_2077, OR1_1242, and LGD_2006).
# I first take the mean of temperature and salinity replicate measurements (if replicates were
# available);
# I then remove the stations that are irrelevant to my analysis;
# I also added a `Location` column to indicate the differences between the two shelf sites.
# The finalized `ctd.xlsx` file were used to plot the characteristics of the whole water column.
#
# In addition, bottom water characteristics were extracted into a separate file `CTD_bw.xlsx`
# for later environmental analysis.


# library
pacman::p_load(readxl,
               writexl,
               dplyr,
               tidyr,
               usethat,
               GRSPRSThesisData)

# curate ctd data ---------------------------------------------------------


# load ctd file names
ctd_dir <- dir(path = "xlsx",
               pattern = "CTD.xlsx",
               full.names = T)

# read ctd files
ctd <- NULL
for(i in ctd_dir){
  ctd <- rbind(ctd, read_xlsx(i))
}

# subsetting cruises
ctd <-
  ctd %>%
  filter(Cruise %in% c("OR1_1219", "OR3_2077", "OR1_1242" ,"LGD_2006"))

# mean the temperatures and salinities
ctd <-
  ctd %>%
  mutate(Temperature =
           if_else(!Cruise %in% "OR3_2077", (temperature_T1 + temperature_T2) / 2, temperature_T1),
         Salinity =
           if_else(!Cruise %in% "OR3_2077", (salinity_T1C1 + salinity_T2C2) / 2, salinity_T1C1),
         Theta =
           if_else(!Cruise %in% "OR3_2077", (density_T1C1...11 + density_T2C2...12) / 2, density_T1C1...11),
         Density =
           if_else(!Cruise %in% "OR3_2077", (density_T1C1...13 + density_T2C2...14) / 2, density_T1C1...13))

# remove none shelf stations
ctd <-
  ctd %>%
  filter(!Station %in% c("GS4", "KP1", "KP2", "KP3", "KP4", "KP5"))

# selecting columns
ctd <-
  ctd %>%
  select(Cruise, Station, date, Latitude, Longitude, # date & location
         pressure, Temperature, Salinity,  # CTD
         Density, Theta, # density
         Oxygen, fluorometer, transmissometer, Beam_Attn) # others

# add location
ctd$Location <- if_else(ctd$Station %in% c(paste("S", 1:8,sep= ""), "GS1", "GC1"), "GRS", "PRS")
ctd <- relocate(ctd, Location, .before = Station)

# write ctd.xlsx
ctd_profile <- ctd
usethis::use_data(ctd_profile, overwrite = T)

# extract bottom water characteristics -----------------------------

ctd_bw <-
  ctd %>%
  group_by(Cruise, Location, Station) %>%
  select(-Density, - Theta) %>%
  filter(pressure == max(pressure))

# prevent excel overreacting to date information
ctd_bw$date <- ymd(ctd_bw$date)

# write ctd_bw.xlsx
write_xlsx(ctd_bw, "xlsx/ctd_bw.xlsx")
