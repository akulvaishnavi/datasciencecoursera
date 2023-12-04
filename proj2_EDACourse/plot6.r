library("data.table")
library("ggplot2")

# Set the working directory
path <- getwd()

# Download and unzip the data files
download.file(
  url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
  destfile = file.path(path, "dataFiles.zip")
)
unzip(zipfile = "dataFiles.zip")

# Load the NEI & SCC data frames.
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Gather the subset of the NEI data which corresponds to vehicles
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case = TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data for Baltimore
vehiclesBaltimoreNEI <- vehiclesNEI[fips == "24510", ]
vehiclesBaltimoreNEI[, city := "Baltimore City"]

# Subset the vehicles NEI data for Los Angeles
vehiclesLANEI <- vehiclesNEI[fips == "06037", ]
vehiclesLANEI[, city := "Los Angeles"]

# Combine data.tables into one data.table
bothNEI <- rbind(vehiclesBaltimoreNEI, vehiclesLANEI)

# Create a bar plot using ggplot2 and save it as a PNG file
png("plot6.png")

ggplot(bothNEI, aes(x = factor(year), y = Emissions, fill = city)) +
  geom_bar(aes(fill = year), stat = "identity") +
  facet_grid(scales = "free", space = "free", . ~ city) +
  labs(x = "Year", y = expression("Total PM"[2.5] * " Emission (Kilo-Tons)")) + 
  labs(title = expression("PM"[2.5] * " Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

dev.off()
