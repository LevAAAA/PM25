library(dplyr)
library(ggplot2)
#0. Reading and preparation test and train sets

filename <- "exdata_data_NEI_data.zip"

# Checking if zip-file already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if un-zipped folder exists
if (!file.exists("summarySCC_PM25.rds")) { 
  unzip(filename) 
}

# Read NEI from summarySCC_PM25.rds
NEI <- readRDS("summarySCC_PM25.rds")

# Read SCC from Source_Classification_Code.rds
SCC <- readRDS("Source_Classification_Code.rds")

NEI_BAL_LA<-filter(NEI, NEI$fips=="24510"|NEI$fips=="06037" & NEI$type=="ON-ROAD")

# Group NEI by year
NEI_BAL_LA_by_year <- aggregate(Emissions ~ year + fips, NEI_BAL_LA, sum)

ggplot(NEI_BAL_LA_by_year, aes(x=year,y=Emissions,col=fips))+
  geom_point() +
  geom_line() +
  scale_x_binned(n.breaks = 5) +
  ggtitle("PM2.5 emission Baltimor City & LA") +
  scale_colour_discrete(name = "City", labels = c("Los Angeles", "Baltimore"))


ggsave("plot6.png")

# Save changes to file and close file 
dev.off()


