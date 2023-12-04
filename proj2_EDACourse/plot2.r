library("data.table")

# Set the working directory
path <- getwd()

# Download and unzip the data files
download.file(
  url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
  destfile = file.path(path, "dataFiles.zip")
)
unzip(zipfile = "dataFiles.zip")

# Read data tables from RDS files
SCC <- as.data.table(readRDS(file = "Source_Classification_Code.rds"))
NEI <- as.data.table(readRDS(file = "summarySCC_PM25.rds"))

# Convert 'Emissions' column to numeric
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = "Emissions"]

# Filter data for fips=='24510' and calculate total emissions by year
totalNEI <- NEI[fips == '24510', lapply(.SD, sum, na.rm = TRUE), .SDcols = "Emissions", by = year]

# Save the barplot as a PNG file
png(filename = 'plot2.png')

# Create a barplot
barplot(
  height = totalNEI$Emissions,
  names.arg = totalNEI$year,
  xlab = "Years",
  ylab = "Emissions",
  main = "Emissions over the Years"
)

# Close the PNG device
dev.off()
