#Load the following libraries. If you haven't installed them, you'll need to run install.packages("package name") first. The packages are "dplyr", "xlsx", "xts".

library(dplyr)
library(xlsx)
library(xts)


#Set your working directory to be wherever you place the weather data.
#setwd("C:/Users/cgervais/Desktop/Weather Data/")

#Read in the list of files. Then create a list of data frames called "all_weather_data" using the lapply function with read.csv(). This will create a list of all of the data frames. Finally, bind the dataframes together using rbind within do.call()

#filenames <- list.files(full.names = TRUE)
#all_weather_data <- lapply(filenames, function(i){
#  read.csv(i, header = TRUE)})
#all_weather_df <- do.call(rbind, all_weather_data)


#Set your working directory to be wherever you place the load data.
setwd("C:/Users/Chris Gervais/Desktop/Term Project/Load/")

#Read in the list of files. Then create a data list of data frames called "all_load_data" using the read.xlsx function in xlsx package. Similar to the weather files, this creates a list of data frames.
filenames <- list.files(full.names = TRUE)
all_load_data <- lapply(filenames, function(i){
  read.xlsx(i,
            sheetIndex=1, 
            rowIndex=c(5:28), 
            colIndex=c(2:32), 
            as.data.frame=TRUE, 
            header=FALSE)})


#Create a custom function to change the underlying dataframes in all_load_data, and return a list of vectors for each month.
change_to_single <- lapply(seq_along(all_load_data), function(i){
  
  df_0 <- all_load_data[[i]]
  df_1 <- df_0[,1]
  for(j in c(2:31)){
    df_1 <- c(df_1, df_0[,j])
  }
  return(df_1)})

#Take the list of vectors, and break it down to a single list of vectors using unlist.
hourly_df <- as.data.frame(unlist(change_to_single))

#Remove the 0's that were introduced by the 31 days / month assumption
hourly_df <- hourly_df[hourly_df$`unlist(change_to_single)`!=0,]

#Create the known time sequence so that we can create an xts object
time_index <- seq(from = as.POSIXct("2016-01-01 01:00"), 
                  to = as.POSIXct("2017-01-01 00:00"), by = "hour")   

#Create the final hourly xts object by including the time_index
hourly_xts <- xts(hourly_df, order.by = time_index)

core <- coredata(hourly_xts)
hourly_msts <- msts(core[,1], seasonal.periods = c(24, 168))
fit_tbats <- tbats(hourly_msts)

#Set the working directory to be the desktop so we can dump the file.
setwd("C:/Users/cgervais/Desktop/")
write.zoo(x = hourly_xts, file = "HourlyLoadFile.csv", sep = ",")
