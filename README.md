# Tidy-Data Repo ReadMe

Getting and Cleaning Data Coursera Class Project ReadMe
    - Tidy Accelerometer Data from Samsung Galaxy S smart phones

This read me file for the Tidy-Data Project explains how the scripts work and how they work together.

There is only one script:

run_analysis.R => contains the code for all of the project requirements. It can be run at an R console prompt or in Rstudio.

"run_analysis.R" uses data collected from the accelerometers from the Samsung Galaxy S smartphone. It creates a new dataset (named X) as it merges the training and the test sets, extracting only the measurements on means and standard deviations and assigning descriptive activity and variable names.

"run_analysis.R" creates a second tidy dataset (named Xave) with the average of each variable for each activity and each subject.

(See CodeBook.md for a more in depth description of the data and what was done to accomplish this.)