# Load required libraries
library("data.table")

# Set working directory
path <- getwd()

# Download and unzip the data files
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = file.path(path, "mydata.zip"), method = "curl")
unzip("mydata.zip")
setwd("./UCI HAR Dataset")

# Load datasets
subject_train <- read.table("./train/subject_train.txt", header = FALSE, col.names = "subjectID")
subject_test <- read.table("./test/subject_test.txt", header = FALSE, col.names = "subjectID")
y_train <- read.table("./train/y_train.txt", header = FALSE, col.names = "activity")
y_test <- read.table("./test/y_test.txt", header = FALSE, col.names = "activity")
FeatureNames <- read.table("features.txt", col.names = c("Index", "FeatureName"))
X_train <- read.table("./train/X_train.txt", header = FALSE, col.names = FeatureNames$FeatureName)
X_test <- read.table("./test/X_test.txt", header = FALSE, col.names = FeatureNames$FeatureName)

# Merge training and test datasets
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
alldata <- rbind(train, test)

# Extract columns with "mean" and "std" in the variable name
meancol <- alldata[, .SD, .SDcols = grep('mean()', names(alldata), fixed = TRUE)]
stdcol <- alldata[, .SD, .SDcols = grep('std()', names(alldata), fixed = TRUE)]
keycol <- alldata[, .(subjectID, activity)]
meanstd_data <- cbind(keycol, meancol, stdcol)

# Read activity labels
actlbl <- read.table("activity_labels.txt", col.names = c("activity", "ActivityLabel"))
alldata$activity <- factor(alldata$activity, labels = actlbl$ActivityLabel)

# Label the dataset with descriptive variable names
descriptive_names <- c(
  "tBody" = "TimeDomainBody",
  "tGravity" = "TimeDomainGravity",
  "fBody" = "FrequencyDomainBody",
  "Acc" = "Acceleration",
  "Gyro" = "AngularVelocity",
  "-XYZ" = "3AxialSignals",
  "-X" = "XAxis",
  "-Y" = "YAxis",
  "-Z" = "ZAxis",
  "Mag" = "MagnitudeSignals",
  "-mean()" = "MeanValue",
  "-std()" = "StandardDeviation",
  "-mad()" = "MedianAbsoluteDeviation",
  "-max()" = "LargestValueInArray",
  "-min()" = "SmallestValueInArray",
  "-sma()" = "SignalMagnitudeArea",
  "-energy()" = "EnergyMeasure",
  "-iqr()" = "InterquartileRange",
  "-entropy()" = "SignalEntropy",
  "-arCoeff()" = "AutoRegresionCoefficientsWithBurgOrderEqualTo4",
  "-correlation()" = "CorrelationCoefficient",
  "-maxInds()" = "IndexOfFrequencyComponentWithLargestMagnitude",
  "-meanFreq()" = "WeightedAverageOfFrequencyComponentsForMeanFrequency",
  "-skewness()" = "Skewness",
  "-kurtosis()" = "Kurtosis",
  "-bandsEnergy()" = "EnergyOfFrequencyInterval."
)
names(alldata) <- gsub(names(descriptive_names), descriptive_names, names(alldata), fixed = TRUE)

# Create a tidy dataset
DT <- data.table(alldata)
tidy <- DT[, lapply(.SD, mean), by = c("activity", "subjectID")]

# Save the tidy dataset to a file named "TidyData.txt"
write.table(tidy, file = "TidyData.txt", row.names = FALSE, col.names = TRUE)
print("The script 'run_analysis.R' was executed successfully. As a result, the file 'TidyData.txt' has been saved in the working directory, in the folder 'UCI HAR Dataset'.")
rm(list = ls())
