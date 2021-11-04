library(doBy)
library(readxl)
library(plyr)
# Diffusive flux

d_files <- dir(pattern="diffuse_o2_profile.rds", full.names = TRUE)

fx <- readRDS(d_files[1])[[1]]
for(i in 2:length(d_files)) fx <- rbind(fx, readRDS(d_files[i])[[1]])
fx$Region <- factor(fx$Region)
fx$Region <- factor(fx$Region, labels=sub("Shoushan", "Kaohsiung", levels(fx$Region)))

# Temperature at profiling experiment
temp <- read.csv("profile_temp.csv")
id1 <- with(fx, paste(Cruise, Deployment, Tube))
id2 <- with(temp, paste(Cruise, Deployment, Tube))
fx$Temperature <- temp$Temperture[match(id1, id2)]

# In situ temperature
# CTD data
ctd <- as.data.frame(read_excel("../GPSC_CTD/GPSC_CTD_2020.07.23.xlsx", sheet=1))
ctd <- splitBy(~Cruise+Station, ctd)

# Function to get average of bottom 3 deepest CTD data
deep_fun <- function(x) {
  dat <- x[order(x$pressure, decreasing=TRUE)[1:3],]
  summaryBy(.~Cruise+Station, data=dat, keep.names=TRUE, na.rm=TRUE)
}

ctd <- lapply(ctd, FUN=deep_fun)
ctd <- ldply(ctd)[, -1]

# Average temperature
ctd$Temperature <- rowMeans(ctd[, c("temperature_T1", "temperature_T2")], na.rm=TRUE)

id1 <- with(ctd, paste(Cruise, Station))
id2 <- with(fx, paste(Cruise, Station))
# Fill station with no CTD data
id2[id2=="OR1_1190 FC2A"] <- "OR1_1190 FC2"
id2[id2=="OR1_1190 GS6"] <- "OR1_1138 GS6"
id2[id2=="OR1_1138 S27"] <- "OR1_1138 GS8(S9)"
id2[id2=="OR1_1138 S27a"] <- "OR1_1138 GS8(S9)"
id2[id2=="OR1_1182 SC2a"] <- "OR1_1182 SC2"
fx$In_situ_temperature <- ctd[match(id2, id1), "Temperature"]

# Apply Q10 (=2, Valiela, 1995) adjustment with in-situ CTD data
q10_fun <- function(t1, t2, r1, q10){
  a <- 10/(t1-t2)
  r1/(q10^(1/a))
}
fx$In_situ_Integrated_Prod <- q10_fun(t1=fx$Temperature, t2=fx$In_situ_temperature, r1=fx$Integrated_Prod, q10=2)
write.csv(fx, file="GPSC_DOU.csv", row.names=FALSE, na="")
#write.csv(summaryBy(Integrated_Prod+In_situ_Integrated_Prod ~ Cruise+Station, data=fx, FUN=c(mean, sd, length)), file="GPSC_DOU_st.csv", row.names=FALSE, na="")



ob <- readRDS(d_files[1])[[2]]
for(i in 2:length(d_files)) ob <- rbind(ob, readRDS(d_files[i])[[2]])
ob$Region <- factor(ob$Region)
ob$Region <- factor(ob$Region, labels=sub("Shoushan", "Kaohsiung", levels(ob$Region)))
write.csv(ob, file="GPSC_o2_profile.csv", row.names=FALSE, na="")

# Bioturbation flux

d_files <- dir(pattern="bioturb_o2_profile.rds", full.names = TRUE)

fx <- readRDS(d_files[1])[[1]]
for(i in 2:length(d_files)) fx <- rbind(fx, readRDS(d_files[i])[[1]])
fx$Region <- factor(fx$Region)
fx$Region <- factor(fx$Region, labels=sub("Shoushan", "Kaohsiung", levels(fx$Region)))
write.csv(fx, file="bioturb_DOU.csv", row.names=FALSE, na="")

ob <- readRDS(d_files[1])[[2]]
for(i in 2:length(d_files)) ob <- rbind(ob, readRDS(d_files[i])[[2]])
ob$Region <- factor(ob$Region)
ob$Region <- factor(ob$Region, labels=sub("Shoushan", "Kaohsiung", levels(ob$Region)))
write.csv(ob, file="bioturb_o2_profile.csv", row.names=FALSE, na="")

de <-readRDS(d_files[1])[[6]]
write.csv(de, file="metadata.csv", row.names=FALSE, na="")
