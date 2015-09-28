# Tidy-Data Repo ReadMe

##Getting and Cleaning Data Coursera Class Project Code Book - Tidy Accelerometer Data from Samsung Galaxy S smart phones

This code book for the Tidy-Data Project describes the variables, the data, and all transformations performed on the data.

The data used in this project is linked to the course website and was collected from the accelerometers from the Samsung Galaxy S smartphone. 

##Raw Data

###Raw Data Source
The raw data description is available in the “UCI HAR Dataset” README.txt file and from:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The original raw data was downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

###Raw Data Files
When the file was downloaded and unzipped it produced a directory called “UCI HAR Dataset” containing:
Type        | Name
------------|---------------------
file        | activity_labels.txt
file        | features_info.txt
file        | features.txt
file        | README.txt
subdirectory| test
subdirectory| train

subdirectory "test" contained:
Type        | Name
------------|---------------------
file        | subject_test.txt
file        | X_test.txt
file        | y_test.txt
subdirectory| Inertial Signals
(Inertial Signals subdiectory contained 9 files not used here so deleted)

subdirectory "train" contained:
Type        | Name
------------|---------------------
file        | subject_train.txt
file        | X_train.txt
file        | y_train.txt
subdirectory| Inertial Signals
(Inertial Signals subdiectory contained 9 files not used here so deleted)

###Data file Descriptions and Abbreviations
X* = data from X_test.txt & X_train.txt
     contains 561 types of metric data, with thousands of observations in each

Y* = data from Y_test.txt & Y_train.txt
     activity data corresponding to each observation in X*
     these are number coded (1-6)
     names corresponding to the numbers are in activity_labels.txt

subject* = data from subject_test.txt & subject_train.txt
           subject/participant data corresponding to each observation in X*
           These are in the form of integers numbered 1-30

## Changes to the Raw Data

###Simplified data names (X*, Y*, subject*)

While reading in the data files (X*, Y*, subject*): The underscore and extension were removed when naming the objects (example: X_test.txt => Xtest)

###Added descriptive column names to data (X*, Y*, subject*)

When reading in the data files (X*, Y*, subject*):
column names were added to make the data more readable. 

The X* metric data files column names were taken from the second column of the “features.txt” file.  
Note:
1. Each non-alphanumeric character in the column names was changed to “.” automatically
2. The features data has a few duplicated variable names (477 of 561 are unique), but during the read in, suffixes were added to the end of the duplicate column names to make them all unique. (More specifically, ”.1” was appended to the first occurrence, ".2" to the the second occurrence, etc.)

The Y_t* activity data files had only one column, and it was labeled “activity”.

The subject_t* subject/participant files had only one column, and it was labeled “subject”.

###Added activity data (Y*) to corresponding metric data (X*)
The single column of activity data (Y* files) was conbined with the corresponding metric data (X*) for the test and training datasets. Dataset names reflect the change:   
        Ytest + Xtest = Xtest_Y 
        Ytrain + Xtrain = Xtrain_Y

###Added subject/participant data (subject*) to corresponding metric data (X*)
The single column of subject data (subject* files) was conbined with the corresponding metric/activity data for the test and training datasets. Dataset names reflect the change:
        Xtest_Y + subtest = Xtest_Ysub
        Xtrain_Y + subtest = Xtrain_Ysub

###Added new column to hold subject type (train or test)
Create a new column in both datasets to hold the informaton for subject type, (train or test) so this data will not be lost when the datasets are merged. (Data set names were not changed in this step)
All rows of the test data set contain the word "test".
All rows of the training data set contain the word "train".

###Merged the test and training datasets
Merged the test and training datasets (each containing: subject, activity, 561 metrics, and subject_type data) to create one data frame containing all of the data (Xall) using a full join of the dataset. (since all of the columns were the same in both datasets more than one the type of join could have been used here.)
        Xtest_Ysub + Xtrain_Ysub = Xall

###Extracted the mean and standard deviation Metrics
From the data set containing all of the data (Xall), selected only the metrics containing statistcal means (column names containing "mean") or statistical standard deviation  (column names containing "std") data, while keeping the previously added columns activity, subject, and subject type data ("subject", "activity", & "subject_type"). Put the result in a data frame named simply "X" since it will contain the final version of the dataset.

###Added descriptive acivity names
Changed the integer values in the activity column to factors with the descriptive names given in activity_labels.txt (read into variable actlabels)

### Refined descriptive variable names
Descriptive variable names from the features.txt file were already added to the datasets when they were merged, so the names were just cleaned at this point as follows:
1. Changed 3 or 2 dots/periods in a row to a single dot/period (3 dots first, to be sure to get them all)
2. Change front t to "time", and front f to "freq" to more clearly indicate the time and       frequency domain variables

###X is the final merged and cleaned dataset


## Create a tidy Average Dataset grouped by activity and subject
Made X into a data frame table then grouped it by activity and subject
Made it tidier by arranging it by activity & subject and by adding an "ave." to the front of all the data columns to indicate they are average values. (This is not done automatically by summarize_each.)

###Xave is the final tidy average dataset grouped by activity and subject
