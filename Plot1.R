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
total_pm25 <- NEI %>% 
        group_by(year) %>% 
        summarise(Emissions = sum(Emissions))

png(filename = "Plot1.png")
with(total_pm25, plot(year, Emissions, type = "l", ylab = "Total US Emissions", xlab = "Year", main = "US small particle emissions"))
dev.off()
rm(total_pm25) #Cleanup memory for next analysis
