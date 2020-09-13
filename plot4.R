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

# Filter coal
SCC_coal <- SCC[grepl("coal", SCC$Short.Name, ignore.case = T),]
NEI_coal <- NEI[NEI$SCC %in% SCC_coal$SCC,]

# Group NEI by year
NEI_coal_by_year<-group_by(NEI_coal, year)

# Calculate summ NEI Emission by year
NEI_coal_sum_by_year<-summarise(NEI_coal_by_year, PMSum=sum(Emissions))

# Create png device
png("plot4.png", width=480, height = 480)

# Plot graph without axes
plot(NEI_coal_sum_by_year$year, NEI_coal_sum_by_year$PMSum, 
     xlab="Years", ylab = "PM2.5 emission", main = "Total PM2.5 emission from coal", 
     axes=FALSE)

# Plot axes to show unique years from data
axis(side=1, at=c(unique(NEI_coal_sum_by_year$year)))
axis(side=2, at=c(unique(NEI_coal_sum_by_year$PMSum)))

# Plot box around graph
box()

# Plot regression line
abline(lm(NEI_coal_sum_by_year$PMSum ~ NEI_coal_sum_by_year$year))

# Save changes to file and close file 
dev.off()


