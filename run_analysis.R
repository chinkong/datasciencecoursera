# Load required package
library(data.table)
library(tidyr)
library(dplyr)

# Remove all objects in workspace - so that each run is a clean run
rm(list = ls())

# All data are put in the ./data subfolder of the working folder
relFilePath <- file.path("./data" , "UCI HAR Dataset")

# Read subject files - ./data/train and ./data/test respectively
dataSubjectTrain <- read.table(file.path(relFilePath, "train", "subject_train.txt"))
dataSubjectTest  <- read.table(file.path(relFilePath, "test" , "subject_test.txt" ))

# Read label files - ./data/train and ./data/test respectively
dataActivityTrain <- read.table(file.path(relFilePath, "train", "y_train.txt"))
dataActivityTest  <- read.table(file.path(relFilePath, "test" , "y_test.txt" ))

# Read data files - ./data/train and ./data/test respectively
dataTrain <- read.table(file.path(relFilePath, "train", "x_train.txt" ))
dataTest  <- read.table(file.path(relFilePath, "test" , "x_test.txt" ))


# Merge the Training and Test sets by row binding  
# for Subject, Activity and Data
allDataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
allDataActivity <- rbind(dataActivityTrain, dataActivityTest)
allData <- rbind(dataTrain, dataTest)

setnames(allDataSubject, "V1", "subject")
setnames(allDataActivity, "V1", "activityNumber")

# Name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
dataFeatures <- read.table(file.path(relFilePath, "features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featureNumber", "featureName"))
colnames(allData) <- dataFeatures$featureName

# Column names for activity labels
activityLabels <- read.table(file.path(relFilePath, "activity_labels.txt"))
setnames(activityLabels, names(activityLabels), c("activityNumber","activityName"))

# Merge columns
allDataSubjectActivity <- cbind(allDataSubject, allDataActivity)
allData <- cbind(allDataSubjectActivity, allData)

# Reading "features.txt" and extracting only the mean and standard deviation
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE) #var name

# Taking only measurements for the mean and standard deviation and add "subject","activityNum"
dataFeaturesMeanStd <- union(c("subject","activityNumber"), dataFeaturesMeanStd)
allData <- subset(allData, select=dataFeaturesMeanStd) 

##enter name of activity into allData
allData <- merge(activityLabels, allData , by="activityNumber", all.x=TRUE)
allData$activityName <- as.character(allData$activityName)

# Apply appropriate labels the data set with descriptive variable names
names(allData)<-gsub("^t", "time", names(allData))
names(allData)<-gsub("^f", "frequency", names(allData))
names(allData)<-gsub("Acc", "Accelerometer", names(allData))
names(allData)<-gsub("Gyro", "Gyroscope", names(allData))
names(allData)<-gsub("Mag", "Magnitude", names(allData))

## create dataTable with variable means sorted by Subject and Activity
allData$activityName <- as.character(allData$activityName)
allDataMean <- aggregate(. ~ subject - activityName, data = allData, mean) 

allDataMean <- arrange(allDataMean, subject, activityName)

write.table(allDataMean, file = "tidydata.txt", row.name=FALSE)
