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
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
coal_index <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
SCC_coal <- SCC[coal_index,]
NEI_coal <- NEI[(NEI$SCC %in% SCC_coal$SCC),]

NEI_coal <- NEI_coal %>% 
        group_by(year) %>%
        summarise(Emissions=sum(Emissions))

png(filename = "Plot4.png", width = 1000, height = 1000)
ggplot(NEI_coal, aes(factor(year), Emissions)) +
        geom_bar(stat = "identity") +
        ggtitle("Coal combustion fine particulate matter emissions in US by year") +
        xlab("Year") +
        ylab(expression("Emissions in kilotons of PM"[2.5])) 
dev.off()

rm(NEI_coal, SCC_coal, coal_index) # Cleanup memory for next analysis
