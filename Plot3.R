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
baltimore <- NEI %>% 
        filter(fips == "24510") %>%
        group_by(year, type) %>%
        summarise(Emissions = sum(Emissions))

png(filename = "Plot3.png", width = 500, height = 500)
ggplot(baltimore, aes(factor(year), Emissions, fill = type)) +
        geom_bar(stat = "identity") +
        facet_grid(.~type) + 
        ggtitle("Emissions in Baltimore by type") +
        xlab("Year") +
        ylab("Emissions") +
        theme(legend.position = "none")
dev.off()

rm(baltimore) #Cleanup memory for next analysis