# 2021/07/11
# Chen, Yen-Ting
# curate env

# Comment:
# The `Section` column was removed. Data type by column was transferred.

pacman::p_load(readxl,
               writexl,
               dplyr,
               tidyr,
               usethat,
               GRSPRSThesisData)

sed_dir <-
  dir(path = "xlsx",
      pattern = "Sediment",
      full.names = T)

sed <- read_xlsx(sed_dir,
                 col_types = c(rep("text",4), rep("numeric", 16))) # explicitly state col_types to avoid odd values

# remove redundant columns for analysis
sed$Deployment <- NULL
sed$Section <- NULL

# write xlsx
write_xlsx(sed, path = "xlsx/sed.xlsx")
