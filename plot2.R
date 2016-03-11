#load the libraries
library(dplyr)
library(lubridate)

# set the download location
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"

#create a temporary file
temp <- tempfile()

#download the file
download.file(fileUrl,temp, method="curl")

#read the data
hpc <- read.csv(unz(temp, "household_power_consumption.txt"), sep = ";")

#remove the temporaryfile
unlink(temp)

#convert hpc to a table dataframe
hpc <- tbl_df(hpc)

#convert the date variable to a proper date
hpc$Date <- dmy(hpc$Date)

#subset hpc
hpc <- select(hpc, Date, Time, Global_active_power)
hpc <- filter(hpc, Date>="2007-02-01" & Date<"2007-02-03")

#make a new variable DateTime
hpc$DateTime <- paste(hpc$Date, hpc$Time)

#convert DateTime and Time to time variables
hpc$Time <- hms(hpc$Time)
hpc$DateTime <- hpc$DateTime <- ymd_hms(hpc$DateTime)

#convert global_active_power to numeric
hpc$Global_active_power <- as.numeric(as.character(hpc$Global_active_power))

#open a connection to a file
png(filename="plot2.png", bg="transparent")

#make the linegraph
plot(hpc$DateTime, hpc$Global_active_power, xlab= " ", ylab="Global Active Power (kilowatts)", type="l")

#close the connection
dev.off()