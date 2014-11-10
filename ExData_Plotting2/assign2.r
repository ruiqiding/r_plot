# Plot 1

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

emission <- NEI[,c("Emissions","year")]
data1 <- aggregate(Emissions ~ year, emission, sum)
png("plot1.png", width = 480, height = 480)
plot(data1, type="b", main="National PM2.5")
dev.off()

# Plot 2

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimore_emission <- subset(NEI[,c("Emissions", "year", "fips")], fips == 24510)
data2 <- aggregate(Emissions ~ year, baltimore_emission, sum)
png("plot2.png", width = 480, height = 480)
plot(data2, type="b", main="Baltimore PM2.5")
dev.off()

# Plot 3

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(reshape)
baltimore_emission_with_type <- subset(NEI[,c("Emissions", "year", "fips", "type")], fips == 24510)
baltimore.point <- subset(baltimore_emission_with_type, type=="POINT")
baltimore.nonpoint <- subset(baltimore_emission_with_type, type=="NONPOINT")
baltimore.onroad <- subset(baltimore_emission_with_type, type=="ON-ROAD")
baltimore.nonroad <- subset(baltimore_emission_with_type, type=="NON-ROAD")
data3.1 <- aggregate(Emissions ~ year, baltimore.point, sum)
data3.2 <- aggregate(Emissions ~ year, baltimore.nonpoint, sum)
data3.3 <- aggregate(Emissions ~ year, baltimore.onroad, sum)
data3.4 <- aggregate(Emissions ~ year, baltimore.nonroad, sum)
colnames(data3.1) = list("year","point")
colnames(data3.2) = list("year","nonpoint")
colnames(data3.3) = list("year","onroad")
colnames(data3.4) = list("year","nonroad")
data3 <- merge(merge(merge(data3.1, data3.2), data3.3), data3.4)
data3.final <- melt(data3, id.vars="year")
colnames(data3.final) = list("year", "type", "emissions")
png("plot3.png", width = 480, height = 480)
ggplot(data3.final, aes(x=year, y=emissions, colour = type)) + geom_line()
dev.off()

# Plot 4

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

industry <- unique(SCC[,4])
emission.coal <- subset(SCC, EI.Sector == industry[1] | EI.Sector == industry[6] | EI.Sector == industry[11])
emission.coal.scc <- emission.coal$SCC

emission <- NEI[,c("Emissions","year","SCC")]
emission <- subset(emission, SCC %in% emission.coal.scc)

data4 <- aggregate(Emissions ~ year, emission, sum)
png("plot4.png", width = 480, height = 480)
plot(data4, type="b", main="National Coal Combustion-related")
dev.off()

# Plot 5

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

industry <- unique(SCC[,4])
motor.industry <- industry[21:24]
emission.motor <- subset(SCC, EI.Sector %in% motor.industry)
emission.motor.scc <- emission.motor$SCC

baltimore_emission <- subset(NEI[,c("Emissions", "year", "fips", "SCC")], fips == 24510)
baltimore_emission.motor <- subset(baltimore_emission, SCC %in% emission.motor.scc)
data5 <- baltimore_emission.motor[,c("year", "Emissions")]
data5 <- aggregate(Emissions ~ year, data5, sum)
png("plot5.png", width = 480, height = 480)
plot(data5, type="b", main="Baltimore Motor Emission")
dev.off()

# Plot 6

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

industry <- unique(SCC[,4])
motor.industry <- industry[21:24]
emission.motor <- subset(SCC, EI.Sector %in% motor.industry)
emission.motor.scc <- emission.motor$SCC

baltimore_emission <- subset(NEI[,c("Emissions", "year", "fips", "SCC")], fips == 24510)
baltimore_emission.motor <- subset(baltimore_emission, SCC %in% emission.motor.scc)
baltimore_emission.motor <- baltimore_emission.motor[,c("year", "Emissions")]
baltimore_emission.motor.sum <- aggregate(Emissions ~ year, baltimore_emission.motor, sum)

la_emission <- subset(NEI[,c("Emissions", "year", "fips", "SCC")], fips == "06037")
la_emission.motor <- subset(la_emission, SCC %in% emission.motor.scc)
la_emission.motor <- la_emission.motor[,c("year", "Emissions")]
la_emission.motor.sum <- aggregate(Emissions ~ year, la_emission.motor, sum)

rng <- range(baltimore_emission.motor.sum, la_emission.motor.sum, na.rm=T)
png("plot6.png", width = 480, height = 480)
par(mfrow = c(1,2))
plot(baltimore_emission.motor.sum, ylim = range(baltimore_emission.motor.sum), main="Baltimore", type="b")
plot(la_emission.motor.sum, ylim = range(la_emission.motor.sum), main="LA", type="b")
dev.off()
