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
hpc <- filter(hpc, Date>="2007-02-01" & Date<"2007-02-03")

#make a new variable DateTime
hpc$DateTime <- paste(hpc$Date, hpc$Time)

#convert DateTime and Time to time variables
hpc$Time <- hms(hpc$Time)
hpc$DateTime <- hpc$DateTime <- ymd_hms(hpc$DateTime)

#convert variables to numeric
hpc$Sub_metering_1 <- as.numeric(as.character(hpc$Sub_metering_1))
hpc$Sub_metering_2 <- as.numeric(as.character(hpc$Sub_metering_2))
hpc$Sub_metering_3 <- as.numeric(as.character(hpc$Sub_metering_3))
hpc$Global_reactive_power <- as.numeric(as.character(hpc$Global_reactive_power))
hpc$Voltage <- as.numeric(as.character(hpc$Voltage))
hpc$Global_active_power <- as.numeric(as.character(hpc$Global_active_power))

#open a connection to a file
png(filename="plot4.png", bg="transparent")

#make the graphs
par(mfrow = c(2, 2))

#first linegraph
plot(hpc$DateTime, hpc$Global_active_power, xlab= " ", ylab="Global Active Power", type="l")

#second linegraph
plot(hpc$DateTime, hpc$Voltage, ylab="Voltage", xlab="datetime", type="l")

#third linegraph
plot(y=hpc$Sub_metering_1, x=hpc$DateTime, type="l", xlab=" ", ylab="Energy sub metering", col="black")
lines(y=hpc$Sub_metering_2, x=hpc$DateTime, type="l", col="red")
lines(y=hpc$Sub_metering_3, x=hpc$DateTime, type="l", col="blue")
legend("topright", legend=names(hpc[,7:9]), lty=c(1,1), col=c("black", "red", "blue"), bty="n", cex=1)

#fourth linegraph
plot(hpc$DateTime, hpc$Global_reactive_power, ylab=names(hpc)[4], xlab="datetime", type="l")

#close the connection
dev.off()