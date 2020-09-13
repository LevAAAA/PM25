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

NEI_24510<-filter(NEI, NEI$fips=="24510")

# Group NEI by year
NEI_24510_by_type_year<-group_by(NEI_24510, type, year)

# Calculate summ NEI Emission by year
NEI_24510_sum_by_type_year<-summarise(NEI_24510_by_type_year, PMSum=sum(Emissions))

ggplot(NEI_24510_sum_by_type_year, aes(x=year,y=PMSum))+
  facet_grid(type~.) +
  geom_point() +
  stat_smooth(formula = y ~ x, method = "lm", col = "red", se=FALSE) +
  scale_x_binned(n.breaks = 5) +
  ggtitle("Total PM2.5 emission from Baltimor City")


ggsave("plot3.png")

# Save changes to file and close file 
dev.off()


