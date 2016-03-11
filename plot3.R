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
hpc <- select(hpc, Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3)
hpc <- filter(hpc, Date>="2007-02-01" & Date<"2007-02-03")

#make a new variable DateTime
hpc$DateTime <- paste(hpc$Date, hpc$Time)

#convert DateTime and Time to time variables
hpc$Time <- hms(hpc$Time)
hpc$DateTime <- hpc$DateTime <- ymd_hms(hpc$DateTime)

#convert sub_metering_x to numeric
hpc$Sub_metering_1 <- as.numeric(as.character(hpc$Sub_metering_1))
hpc$Sub_metering_2 <- as.numeric(as.character(hpc$Sub_metering_2))
hpc$Sub_metering_3 <- as.numeric(as.character(hpc$Sub_metering_3))

#open a connection to a file
png(filename="plot3.png", bg="transparent")

#make the linegraph
plot(y=hpc$Sub_metering_1, x=hpc$DateTime, type="l", xlab=" ", ylab="Energy sub metering", col="black")
lines(y=hpc$Sub_metering_2, x=hpc$DateTime, type="l", col="red")
lines(y=hpc$Sub_metering_3, x=hpc$DateTime, type="l", col="blue")
legend("topright", legend=names(hpc[,3:5]), lty=c(1,1), col=c("black", "red", "blue"))


#close the connection
dev.off()