##Getting and Cleaning Data - Quiz 3 (Week 3)

##For All Work#############################################################
## set working directory
setwd("/Users/Cindy/Data_Science/datasciencecoursera/Quiz")

##Create a subdirectory called "data" to work in (if it doesn't already exist)
if (!file.exists("./data")) {
    dir.create("./data")
}
##getwd()        ##get working directory - gives directory you are currently in
##list.files()   ##list directories and files in current directory

## Quiz Question 1 - Load, Read, Extract, WHICH ##############################
#The American Community Survey distributes downloadable data about United States
#communities. Download the 2006 microdata survey about housing for the state of
#Idaho using download.file() from here:
    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#and load the data into R. The code book, describing the variable names is here:
    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#Create a logical vector that identifies the households on greater than 10 acres
#who sold more than $10,000 worth of agriculture products. Assign that logical
#vector to the variable agricultureLogical. Apply the which() function like this
#to identify the rows of the data frame where the logical vector is TRUE.
#which(agricultureLogical) What are the first 3 values that result?
#ANS:   25, 36, 45       236, 238, 262      125, 238,262      403, 756, 798

##Allow use of functions from packages [If needed: selected CRAN mirror USA(TN)]
install.packages("data.table")
library(data.table)
install.packages("dplyr")
library(dplyr)

##Download Idaho Community Data
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(dataUrl, destfile="./data/ComIdaho3.csv", method="curl")
dateDownloaded1 <- date()

## read file into a data frame - not using here
##ComIdahoData <- read.csv("./data/ComIdaho3.csv")
##(read.table is generic)
##head("./data/ComIdaho.csv")

##Read Community Idaho data into a data table
##     using fread (to get datatable, read.csv makes a data frame)
##  CIDT = data table containing raw data from input file

CIDT <- fread("./data/ComIdaho3.csv")

#Select only rows we want plus serial number
CIsm <- select (CIDT, SERIALNO, ACR, AGS)

#houses > 10 acres => ACR = 3, sold more than $10,000 => AGS = 6
agricultureLogical <- CIDT[,ACR == 3 & AGS == 6]

#replace NA's with False
agricultureLogical[is.na(agricultureLogical)] <- FALSE

#Execute his command & give first 3 values
which(agricultureLogical)

#ANSWER:  125, 238,262

## Quiz Question 2 -  ###############################################
#Using the jpeg package read in the following picture of your instructor into R
#     https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
#Use the parameter native=TRUE. What are the 30th and 80th quantiles of the
#resulting data? (some Linux systems may produce an answer 638 different for
#                 the 30th quantile)
#ANS:    -15259150 -10575416     -14191406 -10904118
#        -10904118 -10575416     -16776430 -15390165

##Allow use of functions from packages [If needed: selected CRAN mirror USA(TN)]
install.packages("jpeg")
library(jpeg)

##Download picture of Jeff
picUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(picUrl, destfile="./data/jeffpic.jpeg", method="curl")
dateDownloaded2 <- date()

#Read data using readJPEG from the JPEG package (told to use native=TRUE)
pic <-readJPEG("./data/jeffpic.jpeg", native = TRUE)

#calculate 30th and 80th quantile (ie percentile)
quantile(pic, probs = c(0, .30, .50, .80, 1), na.rm=TRUE)
#ANS:    -15259150 -10575416

## Quiz Question 3 -  ###############################################
#Data for questions 3-5
#Load the Gross Domestic Product data for the 190 ranked countries in this data:
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#Load the educational data from this data set:
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
#Match the data based on the country shortcode. How many of the IDs match?
#Sort the data frame in descending order by GDP rank (so United States is last).
#What is the 13th country in the resulting data frame?
#Original data sources:
#    http://data.worldbank.org/data-catalog/GDP-ranking-table
#    http://data.worldbank.org/data-catalog/ed-stats
#ANS:   189 matches, 13th country is St. Kitts and Nevis
#       234 matches, 13th country is St. Kitts and Nevis
#       234 matches, 13th country is Spain
#       190 matches, 13th country is St. Kitts and Nevis
#       190 matches, 13th country is Spain
#       189 matches, 13th country is Spain




## Quiz Question 4 -  ###############################################
#What is the average GDP ranking for the "High income: OECD" and "High income:
#nonOECD" group?
#ANS:  32.96667, 91.91304      133.72973, 32.96667      23, 30      30, 37
#            23, 45            23.966667, 30.91304




## Quiz Question 5 -  ###############################################
#Cut the GDP ranking into 5 separate quantile groups. Make a table versus
#Income.Group. How many countries are Lower middle income but among the 38
#nations with highest GDP?
#ANS:    12    18    0    5