library(xts)
library(ggplot2)
library(readr)
library(dplyr)
library(readxl)

pjm_df <- read.csv("pjm.csv", as.is = TRUE)
shadyoaks_df <- read.csv("shadyoaks.csv", as.is = TRUE)

pjm_df$NewTime <- as.POSIXct(pjm_df$Time, 
                             tz = "America/Chicago", 
                             format = "%m/%d/%Y %T")

pjm_df <- pjm_df[,-c(3:4,1)]
pjm_xts <- xts(pjm_df, order.by = pjm_df$NewTime)
plot(pjm_)

shadyoaks_df$NewTime <- as.POSIXct(shadyoaks_df$Time, 
                                   tz = "America/Chicago", 
                                   format = "%d/%m/%Y %H:%M")

shadyoaks_df <- shadyoaks_df[,-(1:3)]
#shadyoaks_xts <- xts(shadyoaks_df, order.by = shadyoaks_df$NewTime)
