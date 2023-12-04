library("data.table")
library("ggplot2")

# Set the working directory
setwd("~/Desktop/datasciencecoursera/4_Exploratory_Data_Analysis/project2")
path <- getwd()

# Download and unzip the data files
download.file(
  url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
  destfile = file.path(path, "dataFiles.zip")
)
unzip(zipfile = "dataFiles.zip")

# Load the NEI & SCC data frames.
NEI <- data.table::as.data.table(x = readRDS("summarySCC_PM25.rds"))
SCC <- data.table::as.data.table(x = readRDS("Source_Classification_Code.rds"))

# Subset NEI data for Baltimore
baltimoreNEI <- NEI[fips == "24510", ]

# Create a bar plot using ggplot2 and save it as a PNG file
png("plot3.png")

ggplot(baltimoreNEI, aes(factor(year), Emissions, fill = type)) +
  geom_bar(stat = "identity") +
  theme_bw() + guides(fill = FALSE) +
  facet_grid(. ~ type, scales = "free", space = "free") +
  labs(x = "Year", y = expression("Total PM"[2.5] * " Emission (Tons)")) +
  labs(title = expression("PM"[2.5] * " Emissions, Baltimore City 1999-2008 by Source Type"))

dev.off()
