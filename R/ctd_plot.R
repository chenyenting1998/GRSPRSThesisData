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
  filter(Cruise %in% c("OR1_1219", "OR1_1242" ,"LGD_2006"))
# mean the temperatures and salinities
ctd <-
  ctd %>%
  mutate(Temperature = (temperature_T1 + temperature_T2) / 2,
         Salinity = (salinity_T1C1 + salinity_T2C2) / 2,
         theta = (density_T1C1...11 + density_T2C2...12)/2,
         Density = (density_T1C1...13 + density_T2C2...14)/2)

# selecting columns
ctd <-
  ctd %>%
  select(Cruise, Station, date, Latitude, Longitude, # date & location
         pressure, Temperature, Salinity, theta, Density,# CTD
         Oxygen, fluorometer, transmissometer)#, Beam_Attn) # others


# remove none shelf stations
ctd <-
  ctd %>%
  filter(!Station %in% c("GC1", "GS1", "GS4", "KP1", "KP2", "KP3", "KP4", "KP5"))

ctd %>% View

library(ggplot2)
ctd %>%
  pivot_longer(cols = 7:13, names_to = "Variables", values_to = "Values") %>%
  ggplot(aes(x = Values, y = pressure))+
  geom_path()+
  scale_y_reverse()+
  facet_grid(Cruise~Variables, scales = "free_x")

