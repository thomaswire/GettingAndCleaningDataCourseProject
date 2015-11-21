### Merge the training and the test sets to create one data set.
featuresFile <- ".\\UCI HAR Dataset\\features.txt"
xTestFile <- ".\\UCI HAR Dataset\\test\\X_test.txt"
yTestFile <- ".\\UCI HAR Dataset\\test\\y_test.txt"
subjectTestFile <- ".\\UCI HAR Dataset\\test\\subject_test.txt"
xTrainFile <- ".\\UCI HAR Dataset\\train\\X_train.txt"
yTrainFile <- ".\\UCI HAR Dataset\\train\\y_train.txt"
subjectTrainFile <- ".\\UCI HAR Dataset\\train\\subject_train.txt"
activityLabelsFile <- ".\\UCI HAR Dataset\\activity_labels.txt"


# Get headers
features <- read.table(featuresFile, sep = "")[,2]

# Get test data
xTest <- read.table(xTestFile, sep = "")

# Set header names
names(xTest) <- features

# Get subjects
testSubjects <- read.table(subjectTestFile, sep = "")
names(testSubjects) <- "subject"
testSubjects$subject <- as.factor(testSubjects$subject)

# Get activity labels
yTest <- read.table(yTestFile, sep = "")
names(yTest) <- "activityLabel"
yTest$activityLabel <- as.factor(yTest$activityLabel)

# Get activity label names
activityLabels <- read.table(activityLabelsFile, sep = "")[,2]
activityLabels <- as.character(activityLabels)

# Convert activity labels from number to descriptive name
levels(yTest$activityLabel)  <-  activityLabels

# Combine subjects, activitylabels and test data
testData <- cbind(testSubjects, yTest, xTest)

# Get train data
xTrain <- read.table(xTrainFile, sep = "")

# Set header names
names(xTrain) <- features

# Get subjects
trainSubjects <- read.table(subjectTrainFile, sep = "")
names(trainSubjects) <- "subject"
trainSubjects$subject <- as.factor(trainSubjects$subject)

# Get activity labels
yTrain <- read.table(yTrainFile, sep = "")
names(yTrain) <- "activityLabel"
yTrain$activityLabel <- as.factor(yTrain$activityLabel)

# Convert activity labels from number to descriptive name
levels(yTrain$activityLabel)  <-  activityLabels

# Combine subjects, activitylabels and test data
trainData <- cbind(trainSubjects, yTrain, xTrain)

# Merge test data and train data
mergedData <- rbind(testData, trainData)

### Extract only the measurements on the mean and standard deviation for each measurement. 

columns <- c(1,2, grep(".*mean.*|.*std.*", names(mergedData)))
mergedDataSubset <- mergedData[,columns]

### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(reshape2)
mergedDataSubsetMelt <- melt(mergedDataSubset, id=c("subject", "activityLabel"), measure.vars = names(mergedDataSubset)[3:81])
averagesData <- dcast(mergedDataSubsetMelt, activityLabel + subject ~ variable, mean)

write.table(averagesData, file = "tidyData.txt", row.names = FALSE)