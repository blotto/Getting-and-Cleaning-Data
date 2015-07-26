this.dir <- dirname(parent.frame(2)$ofile)
setwd(paste(this.dir, '/UCI HAR Dataset/', sep = ""))

### You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Merges the training and the test sets to create one data set.
withHeader = FALSE
# load training set
features <- read.table('./features.txt', header=withHeader)
activityLabels <- read.table('./activity_labels.txt', header=withHeader)
subjectTrain <- read.table('./train/subject_train.txt', header=withHeader)
xTrain <- read.table('./train/x_train.txt', header=withHeader)
yTrain <- read.table('./train/y_train.txt', header=withHeader)

# load test data
subjectTest <- read.table('./test/subject_test.txt', header=withHeader)
xTest <- read.table('./test/x_test.txt', header=withHeader)
yTest <- read.table('./test/y_test.txt', header=withHeader)

# humanize columns with names, and easy when merging
colnames(activityLabels) <- c('aId','aType')
colnames(subjectTrain) <- "sId"
colnames(xTrain) <- features[,2] # maps feature names to training set
colnames(yTrain) <- "aId"

colnames(subjectTest) <- colnames(subjectTrain)
colnames(xTest) <- colnames(xTrain)
colnames(yTest) <- colnames(yTrain)

# merge 
trainingSet <- cbind(yTrain,
                   subjectTrain,
                   xTrain)

testData <- cbind(yTest,
                  subjectTest,
                  xTest)

allData <- rbind(trainingSet, testData)

#intersect(names(trainingSet), names(testData))

#mergedData <- merge(trainingSet, testData, all=TRUE)


### Extracts only the measurements on the mean and standard deviation for each measurement. 

filteredData <- allData[ ,
                        c(
                          "aId",
                          "sId",
                          colnames(allData)[grep("mean\\(\\)|std\\(\\)", colnames(allData))]
                          )
                        ]

#### Use descriptive activity names to name the activities in the data set

# resolve Activity with Labels
presentableData <- merge(filteredData,
                         activityLabels,
                         by='aId',
                         all.x=TRUE)

names(presentableData) <- gsub("Acc", "-Accelerometer", names(presentableData))
names(presentableData) <- gsub("^t", "Time-", names(presentableData))
names(presentableData) <- gsub("^f", "Frequency-", names(presentableData))
names(presentableData) <- gsub("mean\\(\\)", "Mean", names(presentableData))
names(presentableData) <- gsub("std\\(\\)", "StandardDev", names(presentableData))
names(presentableData) <- gsub("Mag", "-Magnitude", names(presentableData))


### From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.

tidyData <- aggregate(presentableData[ ,names(presentableData) != c('aId','sId', 'aType')],
                      by=list(aId = presentableData$aId, sId = presentableData$sId),
                      mean)

write.table(tidyData, './tidyData.txt',row.names=FALSE,sep='\t');


