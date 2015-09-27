run_analysis <- function(parameters??) {
##Getting and Cleaning Data Coursera Class Project - Tidy-Data
## This program uses data collected from the accelerometers from the Samsung
##    Galaxy S smartphone. It creates a new dataset as it merges the training
##    and the test sets extracting only the measurements on means and standard
##    deviations and assigning descriptive activity and variable names.
##    It creates a second tidy dataset with the average of each variable for
##    each activity and each subject. (See CodeBook.md for an in depth
##    description of the data.)

# you are being asked to produce a average for each combination of subject,
#    activity, and variable

#rm# 1. Merges the training and the test sets to create one data set.
#rm# 2. Extracts only the measurements on the mean and standard deviation
#rm#    for each measurement.
#rm# 3. Uses descriptive activity names to name the activities in the data set
#rm# 4. Appropriately labels the data set with descriptive variable names.
#rm# 5. From the data set in step 4, creates a second, independent tidy data set
#rm#    with the average of each variable for each activity and each subject.

#rm# Data description:
#rm# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#rm# Data file:
#rm# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#rm# getwd()        ##get working directory - gives directory you are currently in
#rm# list.files()   ##list directories and files in current directory
# set working directory
setwd("/Users/Cindy/Data_Science/datasciencecoursera/Tidy_Data_Repo/tidy-Data")

# Load R packages !!rm!! Check if used these !!rm!!
#rm# install.packages("data.table")
#rm# library(data.table)
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)

# Create a subdirectory called "data" to store data, if it doesn't already exist
    if (!file.exists("./data")) {
        dir.create("./data")
    }

# Download the zip file into subdirectory data saving the download date/time
# and unzip it into the data subdirectory
#(Unzipping creates a subdirectory called UCI HAR Dataset)
    zip_url <- "https://d396qusza40orc.cloudfront.net/
            getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(zip_url, destfile="./data/origzipfile.zip", method="curl")
    dateDownloaded <- date()
    unzip("./data/origzipfile.zip", exdir="./data")  #exdir=where to put files

# Read in label files from the highest unzipped directory
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

# From the data set containing all of the data (Xall), select only the metrics
# containing statistcal means (column names containing "mean") or statistical
# standard deviation data (column names containing "std"), while keeping the
# the previously added activity and subject data ("subject" and "activity")
    Xall_meanstd <- cbind(Xall$subject, Xall$activity,
                          select(Xall, contains("mean")),
                          select(Xall, contains("std"))
                         )


length(unique(subtrain)$V1)
[1] 21
> length(unique(subtest)$V1)
[1] 9

> duplicated(xcolname)
[477]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
[491]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE
colnames(Xtestnamed[477])
# [1] "fBodyGyro.bandsEnergy...17.24.1"
colnames(Xtestnamed[491])
# [1] "fBodyGyro.bandsEnergy...17.24.2"