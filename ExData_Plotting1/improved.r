library(sqldf)
### Download and Unzip Data File
download.file('http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
		destfile = 'household_power_consumption.zip')
unzip('household_power_consumption.zip')

### Read in data.
household <- read.csv.sql("household_power_consumption.txt", 
		sql = "select * from file where Date = '1/2/2007' OR Date ='2/2/2007' ",
		header = T, sep =';')
	### The above statement reads in only data for the required dates, using sql-lke syntax. 

#### DATE AND TIME SECTION

x <- data.frame(
	date = as.Date(household$Date, format = "%d/%m/%Y"), "%d-%m-%Y" , 
	time = unlist(
		lapply(
			strsplit(as.character(
				strptime(household$Time, format = "%H:%M:%S")), 
			split = ' '), 
		function(x) x[2]))
	
		)
	### This is a helper data.frame, to manipulate the dates and times.


x2 <- within(x, { timestamp=format(as.POSIXct(paste(date, time)), "%d-%m-%Y %H:%M:%S") })
	### This combines the date and time into a single column. 


# Subplot 3

plot(range(strptime(x2$timestamp, format = "%d-%m-%Y %H:%M:%S")), range(household$Sub_metering_1), type = "n",
	 ylab = "Energy sub metering",
		xlab = "")
lines(datetime,household[,7], col = 'black')
lines(datetime,household[,8], col = 'orangered1')
lines(datetime,household[,9], col = 'blue')
legend("topright", legend = colnames(household)[7:9], 
		lwd = 1, lty = 1, col = c('black', 'orangered1', 'blue'), bty ='n'  )

### Handle files
# Download data if needed.
if (!file.exists("household_power_consumption.txt")) {
    temp <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", method="curl", temp)
    unzip(temp)
    unlink(temp)
}

# Read data into temporary data.table and extract the 2-days of data 
#     into the working data.table.
library("data.table")
tmp <- suppressWarnings(fread("household_power_consumption.txt"))
setkey(tmp,Date)
data <- tmp[c("1/2/2007", "2/2/2007")]
rm(tmp)