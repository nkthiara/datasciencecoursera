## Data for the project:
##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Instructions:You should create one R script called run_analysis.R that does the following.

# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names.
# 5) From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

#set the working directory
setwd("~/Documents/datasciencecoursera/UCI HAR Dataset")


# 1) Merge the training and the test sets:

# reading training data 
features      <- read.table("./features.txt", header = FALSE)
activityLabel <- read.table("./activity_labels.txt", header = FALSE)
subjectTrain  <- read.table("./train/subject_train.txt", header = FALSE)
xTrain        <- read.table("./train//X_train.txt", header = FALSE)
yTrain        <- read.table("./train/y_train.txt", header = FALSE)


# Assign column names to training data
  colnames(activityLabel) <- c("activity_id","activity_type")
  colnames(subjectTrain)  <- "sub_id"
  colnames(xTrain)        <- features[,2]
  colnames(yTrain)        <- "activity_id"
  
  
# Merge the training Data
  trainData <- cbind(yTrain,subjectTrain,xTrain)

  
# Reading the test Data
  subjectTest <- read.table("./test/subject_test.txt", header = FALSE)
  xTest       <- read.table("./test/X_test.txt", header = FALSE)
  yTest       <- read.table("./test/y_test.txt", header = FALSE)
  
  
# Assign column names to test data
  colnames(subjectTest) <- "sub_id"
  colnames(xTest)       <- features[,2]  
  colnames(yTest)       <- "activity_id"  
  
  
# Merge test data
  testData <- cbind(yTest,subjectTest,xTest)

  
# Final merge data
  finalData <- rbind(trainData,testData)
  
  
# Make a vector for the column names
  colNames <- colnames(finalData);
  
  
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
  Data_mean_std <- finalData[,grepl("mean|std|sub_id|activity_id",colnames(finalData))]

  
# 3) Uses descriptive activity names to name the activities in the data set
  library(plyr)
  
  Data_mean_std <- join(Data_mean_std, activityLabel, by = "activity_id", match = "first")  
  Data_mean_std <- Data_mean_std[,-1]

# 4) Appropriately labels the data set with descriptive variable names.

# Remove parentheses 
  names(Data_mean_std) <- gsub("\\(|\\)","",names(Data_mean_std), perl = TRUE)
  
  
# correct syntax in names
  names(Data_mean_std) <- make.names(names(Data_mean_std))
  
# add descriptive names
  names(Data_mean_std) <- gsub("Acc","Acceleration", names(Data_mean_std))
  names(Data_mean_std) <- gsub("^t", "Time",names(Data_mean_std))  
  names(Data_mean_std) <- gsub("^f", "Frequency", names(Data_mean_std))
  names(Data_mean_std) <- gsub("BodyBody", "Body", names(Data_mean_std))
  names(Data_mean_std) <- gsub("mean", "Mean", names(Data_mean_std))
  names(Data_mean_std) <- gsub("std", "Std", names(Data_mean_std))
  names(Data_mean_std) <- gsub("Freq", "Frequency", names(Data_mean_std))
  names(Data_mean_std) <- gsub("Mag", "Magnitude", names(Data_mean_std))
  
#creates a second independent tidy data set with the average of each variable for
#each activity and subject.
  
Tidy_dataset_average_subject <- ddply(Data_mean_std, c("sub_id", "activity_id"), numcolwise(mean))
 
write.table(Tidy_dataset_average_subject, file = "tidydata.txt")
