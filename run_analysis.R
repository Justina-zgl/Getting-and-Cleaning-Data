# Getting and Cleaning Data Course Project
setwd("F:/coursera/R/data_UIS")
# 1.Merge the training and test sets to create one data set

# download and unizp data
fileURrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./data/getCleanData.zip")
fileZip <- unzip("./data/getCleanData.zip",exdir ="./data_UIS")

# merge train and test data
train_subject <- read.table("./train/subject_train.txt")
train_x <- read.table("./train/X_train.txt")
train_y <- read.table("./train/y_train.txt")
test_subject <- read.table("./test/subject_test.txt")
test_x <- read.table("./test/X_test.txt")
test_y <- read.table("./test/y_test.txt")

train_all <- cbind(train_subject,train_x,train_y)
test_all <- cbind(test_subject,test_x,test_y)
alldata <- rbind(train_all,test_all)

# 2.Extract only the measurements on the mean and standard deviation for each measurement.
feature_name <- read.table("./features.txt", stringsAsFactors = FALSE)[,2]
feature_id <- grep(("mean\\(\\)|std\\(\\)"), feature_name)
final_data <- alldata[, c(1, 2, feature_id+2)]
colnames(final_data) <- c("subject", "activity", feature_name[feature_id])

#3. Use descreptive activity names to name the activities in the data set
activity_name <- read.table("./activity_labels.txt")
final_data$activity <- factor(final_data$activity, levels=activity_name[,1],labels = activity_name[,2])

#4.Appropriately labels the data set with descriptive variable names

names(final_data) <- gsub("\\()", "", names(final_data))
names(final_data) <- gsub("^t", "time", names(final_data))
names(final_data) <- gsub("^f", "frequence", names(final_data))
names(final_data) <- gsub("-mean", "Mean", names(final_data))
names(final_data) <- gsub("-std", "Std", names(final_data))

#5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(dplyr)
group_data <- final_data %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(group_data, "./meandata.txt", row.names = FALSE)

















