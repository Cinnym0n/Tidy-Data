run_analysis <- function() {
##Getting and Cleaning Data Coursera Class Project - Tidy-Data
## This program uses data collected from the accelerometers from the Samsung
##    Galaxy S smartphone. It creates a new dataset as it merges the training
##    and the test sets extracting only the measurements on means and standard
##    deviations and assigning descriptive activity and variable names.
##    It creates a second tidy dataset with the average of each variable for
##    each activity and each subject.
##    (See CodeBook.md for a more in depth description of the data.)

## Requirements for the project are:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation
#    for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.

# set working directory
setwd("/Users/Cindy/Data_Science/datasciencecoursera/Tidy_Data_Repo/tidy-Data")

# Load R packages !!rm!! Check if used these !!rm!!
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)

# Create a subdirectory called "data" to store data, if it doesn't already exist
    if (!file.exists("./data")) {
        dir.create("./data")
    }

## READ IN DATA
# Download the zip file into subdirectory data saving the download date/time
# and unzip it into the data subdirectory
#(Unzipping creates a subdirectory called UCI HAR Dataset)
    zip_url <- "https://d396qusza40orc.cloudfront.net/
            getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(zip_url, destfile="./data/origzipfile.zip", method="curl")
    dateDownloaded <- date()
    unzip("./data/origzipfile.zip", exdir="./data")  #exdir=where to put files

# Read in label files from the highest unzipped directory
#    features = labels for the metrics (columns) in Xtest and Xtrain
#    actlabels = labels for the activities (row numeric value code list)
#                in Ytest and Ytrain
# "UCI HAR Dataset" is the unzipped directory name containing all data files
   datadir <- "./data/UCI HAR Dataset/"

   features <- read.table(file = paste(datadir,"features.txt", sep=""))
   actlabel <- read.table(file = paste(datadir,"activity_labels.txt", sep=""))

# Read in test and training subject and activity data files. Each file has
# only one column of data for which a column name was added to each file.
#   Ytest, Ytrain: The activity files' column is labeled "activity"
#   subtest, subtrain: Subject files' column is labeled "subject"
   Ytest  <- read.table(file = paste(datadir,"test/Y_test.txt", sep=""),
                        col.names = "activity")
   Ytrain <- read.table(file = paste(datadir,"train/Y_train.txt", sep=""),
                        col.names = "activity")
   subtest  <- read.table(file = paste(datadir,"test/subject_test.txt",
                                       sep=""), col.names = "subject")
   subtrain <- read.table(file = paste(datadir,"train/subject_train.txt",
                                       sep=""), col.names = "subject")

# Read in test and training metric text files (X_test, X_train) into data frames
# Column names are taken from the second column of the features.txt label file
# Files are in sub directories test/ or train/
# Note: The features data has a few duplicated variable names (477 of 561 are
#       unique), but "check.names = TRUE" will check for duplicates and add
#       ".1" to the end of the first occurrence, ".2" to the end of the second
#       occurrence, etc. thus yeilding all unique column names
    xcolname <- features$V2
    Xtest  <- read.table(file = paste(datadir,"test/X_test.txt", sep=""),
                         col.names = xcolname, check.names = TRUE)
    Xtrain <- read.table(file = paste(datadir,"train/X_train.txt", sep=""),
                         col.names = xcolname, check.names = TRUE)

## 1. MERGE DATA
# Merge the single column of activity data with the corresponding metric data
# for the test and training datasets
# (i.e. merge Ytest with Xtest & Ytrain with Xtrain)
    Xtest_Y  <- cbind(Ytest, Xtest)
    Xtrain_Y <- cbind(Ytrain, Xtrain)

# Merge the the single column of subject data with the corresponding
# metric/activity data for the test and training datasets
# (i.e. merge Xtest_Ysub with Xtrain_Ysub)
    Xtest_Ysub  <- cbind(subtest, Xtest_Y)
    Xtrain_Ysub <- cbind(subtrain, Xtrain_Y)

# Create a new column in both datasets to hold the informaton for subject type,
# (train or test) so this data will not be lost when the datasets are merged
    Xtest_Ysub$subject_type  <- replicate(nrow(Xtest_Ysub), "test")
    Xtrain_Ysub$subject_type <- replicate(nrow(Xtrain_Ysub), "train")

# Merge the test and training datasets (each contains subject, activity,
# metric, and subject_type data) to create one data frame containing all of
# the data (Xall) (i.e. merge Xtest_Ysub with Xtrain_Ysub)
    Xall  <- full_join(Xtest_Ysub, Xtrain_Ysub)

## 2. EXTRACT MEAN & STANDARD DEVIATION MEASUREMENTS
# From the data set containing all of the data (Xall), select only the metrics
# containing statistcal means (column names containing "mean") or statistical
# standard deviation data (column names containing "std"), while keeping the
# previously added columns activity, subject and subject_type.
# Name it simply X since it is the final name for the dataset
    X <- cbind(select(Xall, c(subject, activity, subject_type)),
               select(Xall, contains("mean")),
               select(Xall, contains("std"))
              )

## 3. DESCRIPTIVE ACTIVITY NAMES
# Change the integers in the activity column to factors with the descriptive
# names given in activity_labels.txt (read into variable actlabels)
    X$activity <- actlabel[,2] [match(X$activity, actlabel[,1])]

## 4. DESCRIPTIVE VARIABLE NAMES
# Descriptive variable names from the features.txt file were already added
# the datasets were merged, so just clean up the names:
#    Change 3 or 2 dots in a row to a single dot (3 dots first, so get them all)
#    Change front t to "time", and front f to "freq" to indicate the time and
#        frequency domain variables
    colnames(X) <- gsub("...", ".", colnames(X), fixed = TRUE)
    colnames(X) <- gsub("..", ".", colnames(X), fixed = TRUE)
    colnames(X) <- gsub("^*t", "time", colnames(X))
    colnames(X) <- gsub("^*f", "freq", colnames(X))

## X is the final Dataset

## 5. CREATE TIDY AVERAGE DATASET - GROUPED BY ACTIVITY & SUBJECT
# Make X into a dat frame table and group it by activity and subject
# Summarize data using the mean of each column, grouped by activity and subject
# Make it tidier by arranging it by activity & subject and
#   by adding an "ave." to the front of all the data columns to indicate
#   they are average values. (This is not done automatically by summarize_each)
    Xave <- X   %>%
            tbl_df()  %>%
            group_by (activity, subject)  %>%
            summarize_each(funs(mean), 4:89)  %>%
            arrange(activity, subject)

    colnames(Xave)[3:88] <- paste("ave", colnames(Xave)[3:88], sep = ".")

## Xave is the final tidy average dataset
#Write out a table to put into project submittal
write.table(Xave, file="Xave.txt", row.name=FALSE)

}