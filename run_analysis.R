#------------------------------------------------------------------------------------
#  Script Name:         run_analysis.R
#  Description:         For detail please see README.md and CodeBook.md
#  Result:              The result of this script is a tidy data set contained in a 
#                       file named SmartphoneTidyDataSet.txt in the working directory
#  Requirements:        - This script assumes the necessary data is included in the
#                         working directory, if it is not please download
#                         and unzip before running this script.  Data can be downloaded
#                         from here:  
#                            https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
#                       - Requires data.table package
#                       - Note, this code was devloped using Mac OS X version 10.7.5
#------------------------------------------------------------------------------------
require(data.table)

#---------------------------------------------
# Check that data set exists, if not stop
#---------------------------------------------
if(!file.exists("./UCI HAR Dataset")) {
        stop("Data files are not available in working directory, please download them first.") 
}

#---------------------------------------------
# Set filenames for all files we will use
#---------------------------------------------
measureNames <-        "./UCI HAR Dataset/features.txt"
testDataFile <-         "./UCI HAR Dataset/test/X_test.txt"
trainDataFile <-        "./UCI HAR Dataset/train/X_train.txt"
testSubjects <-         "./UCI HAR Dataset/test/subject_test.txt"
trainSubjects <-        "./UCI HAR Dataset/train/subject_train.txt"
testActivityTypes <-    "./UCI HAR Dataset/test/y_test.txt"
trainActivityTypes <-   "./UCI HAR Dataset/train/y_train.txt"
activityLabels <-       "./UCI HAR Dataset/activity_labels.txt"

#-------------------------------------------------------
# Read in measurement labels and test/train data,
#   combine and remove fields we don't need
#-------------------------------------------------------
# read measurement labels, create a vector to assign column names
dfmeasureNames <- read.csv(measureNames, sep=" ", header=FALSE)
vtmeasureNames <- as.vector(dfmeasureNames[[2]])

# read measurement data and combine, using dfMeasureLables for column names
dfTestMeasures <- read.csv(testDataFile, sep="", header=FALSE, col.names=vtmeasureNames)
dfTrainMeasures <- read.csv(trainDataFile, sep="", header=FALSE, col.names=vtmeasureNames)
dfCombinedMeasures <- rbind(dfTestMeasures, dfTrainMeasures)

# remove columns we don't care about, keep only std and mean measures
meanMeasures <- grep("mean()", vtmeasureNames, fixed=TRUE)
stdMeasures <- grep("std()", vtmeasureNames, fixed=TRUE)
colsToKeep <- c(meanMeasures, stdMeasures)
dfFinalDetail <- dfCombinedMeasures[,colsToKeep]

# get rid of original large df's, don't need these
dfTestMeasures <- NULL
dfTrainMeasures <- NULL
dfCombinedMeasures <- NULL

#-------------------------------------------------------
# Rename columns to be more meaningful
#-------------------------------------------------------
# substite values
names(dfFinalDetail) <- gsub("Acc", "Acceleration", names(dfFinalDetail))
names(dfFinalDetail) <- gsub(".mean", "Mean", names(dfFinalDetail))
names(dfFinalDetail) <- gsub("std", "StdDev", names(dfFinalDetail))
names(dfFinalDetail) <- gsub("Mag", "Magnitude", names(dfFinalDetail))
names(dfFinalDetail) <- gsub(".", "", names(dfFinalDetail), fixed=TRUE)
names(dfFinalDetail) <- gsub("BodyBody", "Body", names(dfFinalDetail), fixed=TRUE)

# move the initial t/f value to the end of variable name, and convert to time or frequency
timeMeas <- which(substring(names(dfFinalDetail), 1, 1) %in% c("t"))
freqMeas <- which(substring(names(dfFinalDetail), 1, 1) %in% c("f"))
names(dfFinalDetail)[timeMeas] <- paste(substr(names(dfFinalDetail)[timeMeas], 2, 
                        nchar(names(dfFinalDetail)[timeMeas])), "Time", sep="")
names(dfFinalDetail)[freqMeas] <- paste(substr(names(dfFinalDetail)[freqMeas], 2, 
                        nchar(names(dfFinalDetail)[freqMeas])), "Frequency", sep="")

#-------------------------------------------------------
# Create a sequence field to use as TestID
# NOTE:  this isn't needed in final data set but I 
# added it to help with testing along the way
#-------------------------------------------------------
seqTestID <- seq(1, nrow(dfFinalDetail), by=1)
dfTestID <- data.frame(TestID = seqTestID)

#-------------------------------------------------------
# Read subject identifiers
#-------------------------------------------------------
# read test/train files and combine
dfTestSubjects <- read.csv(testSubjects, sep=" ", header=FALSE)
dfTrainSubjects <- read.csv(trainSubjects, sep=" ", header=FALSE)
dfCombinedSubjects <- rbind(dfTestSubjects, dfTrainSubjects)
names(dfCombinedSubjects) <- c("SubjectID")

#-------------------------------------------------------
# Read activity data and activity descriptions
#-------------------------------------------------------
# read test/train files and combine
dfTestActivityNo <- read.csv(testActivityTypes, header=FALSE)
dfTrainActivityNo <- read.csv(trainActivityTypes, header=FALSE)
dfCombinedActivityNo <- rbind(dfTestActivityNo, dfTrainActivityNo)
names(dfCombinedActivityNo) <- c("ActivityID")

# add TestID sequence for sorting
dfCombinedActivityNo <- cbind(dfTestID, dfCombinedActivityNo)

# read activity descriptions
dfActivityDesc <- read.csv(activityLabels, sep=" ", header=FALSE)
names(dfActivityDesc) <- c("ActivityID", "ActivityDescription")

# merge to get activity description based on ActivityID
dfActivityDescMerged <- merge(dfCombinedActivityNo, dfActivityDesc, by="ActivityID")

# keep only the description, we don't need the ActivityID
dfActivityData <- dfActivityDescMerged[c("TestID", "ActivityDescription")]
dfActivityData <- dfActivityData[order(dfActivityData$TestID),]

#-------------------------------------------------------
# Merge subject, activity descriptions and measurement
#   data.  Summarize by subject and activity and 
#   average the measures.
#-------------------------------------------------------
dfFinalDetail = cbind(dfCombinedSubjects, dfActivityData, dfFinalDetail)

# FOR TESTING ONLY:  Not needed as part of the project but this writes the initial 
#   tidy data set, 1 record per test
write.csv(dfFinalDetail, file="SmartphoneOneRecordPerTest.txt")

# remove fields we don't need
fieldsToDrop <- c("TestID")
dfFinalDetail <- dfFinalDetail[,!(names(dfFinalDetail) %in% fieldsToDrop)]

# convert to a table, summarize by subject and activity, re-order
dtFinalSummarized <- data.table(dfFinalDetail)
dtFinalSummarized <- dtFinalSummarized[, lapply(.SD, mean), by="SubjectID,ActivityDescription"]
dtFinalSummarized <- dtFinalSummarized[order(dtFinalSummarized$SubjectID, dtFinalSummarized$ActivityDescription),]

# write final tidy data set to a file
write.csv(dtFinalSummarized, file="SmartphoneTidyDataSet.txt", row.names=FALSE)
