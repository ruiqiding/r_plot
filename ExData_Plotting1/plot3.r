
# plot 3
date <- read.csv(pipe("cut -f1 -d ';' household_power_consumption.txt"))
row22 <- which.max(date$Date == "2/2/2007")
row21 <- which.max(date$Date == "1/2/2007")
length <- (row22 - row21) * 2
sample <- read.csv("household_power_consumption.txt", sep = ";", header = TRUE, skip = row21 -1 , nrow = length)
colnames <- names(read.csv("household_power_consumption.txt", sep = ";", header = TRUE, nrow = 1))
colnames(sample) <- colnames

datetime <- strptime(paste(sample$Date, sample$Time), "%e/%m/%Y %H:%M:%S")
sample <- cbind(datetime, sample)
sample <-sample[,c(1,4,5,6,7,8,9,10)]

png("plot3.png", width = 480, height = 480)
with(sample, plot(Sub_metering_1 ~ datetime, col = "black", main = "", xlab = "", ylab = "Energy sub metering",type="l"))
with(sample, lines(Sub_metering_2 ~ datetime, col = "red"))
with(sample, lines(Sub_metering_3 ~ datetime, col = "blue"))
legend("topright", pch=1,col=c("black","blue", "red"), legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
dev.off()


