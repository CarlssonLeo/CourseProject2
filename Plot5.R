# setup and file load -----------------------------------------------------
library(tidyverse)

#check if file is already downloaded and extracted the file, if not, do and clean
if(!file.exists("./summarySCC_PM25.rds")) { 
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileURL, "./FNEI.zip")
        unzip("./FNEI.zip", exdir = ".")
        file.remove("./FNEI.zip")
        rm(fileURL)
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Plot --------------------------------------------------------------------
#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
motor_index <- grepl("Mobile.*Vehicles", SCC$EI.Sector)
SCC_motor <- SCC[motor_index,]
NEI_motor <- NEI[(NEI$SCC %in% SCC_motor$SCC),]

baltimore_motor <- NEI_motor %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarise(Emissions=sum(Emissions))

png(filename = "Plot5.png")
ggplot(baltimore_motor, aes(factor(year), Emissions)) +
        geom_bar(stat = "identity") +
        ggtitle("Motor Vehicle fine particulate matter emissions in Baltimore by year") +
        xlab("Year") +
        ylab(expression("Emissions in kilotons of PM"[2.5])) 
dev.off()

rm(NEI_motor, SCC_motor, motor_index, baltimore_motor) # Cleanup memory for next analysis
