---
title: "Codebook"
author: "udaya"
date: "Sunday, February 22, 2015"
output: html_document
---

#Code Book Getting and Cleaning Data Course Project
This document explains the code inside `run_analysis.R`.



## 1. Read Train and Test data sets and merge them.

#### Read X data test and train and merge them
```r
tmp1 <- read.table("train/X_train.txt")
tmp2 <- read.table("test/X_test.txt")
X <- rbind(tmp1, tmp2)
```
#### Read Y data and merge
```r
tmp1 <- read.table("train/y_train.txt")
tmp2 <- read.table("test/y_test.txt")
Y <- rbind(tmp1, tmp2)
```

#### Read Subjects datasets and merge them
```r
tmp1 <- read.table("train/subject_train.txt")
tmp2 <- read.table("test/subject_test.txt")
S <- rbind(tmp1, tmp2)
names(S) <- "subject"
```
##### Now 
* the merged X_test and X_train data is in X variable
* the merged Y_test and Y_train data is in Y variable
* the Subject train and test data is in S variable and the name of the Variable in Subject is set to _subject_

## 2. Read features and filtering for _mean_ and _stdev_ for each measurement.
```r
features <- read.table("features.txt")
indices <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
```
##### using regular expression extracted the columns related to _mean_ and _stddev_ from features dataset

## 3. Reading activity names, and naming   the activities in the data set.
```r
activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"
```

## 4. Lable the data set with descriptive Activity Names.
```r
data1 <- cbind(S, Y, X)
write.table(data1, "merged_Dataset.txt",row.name=FALSE)
```
##### Merged the data sets with appropriate lable names into a variable _data1_ and writing the result into _merged_DataSet.txt_ text file.

## 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
```r
subjects = unique(S)[,1]    #get unique subjects
no_of_subjects = length(unique(S)[,1])
no_of_activities = length(activities[,1])
no_of_cols = dim(data1)[2]
result = data1[1:(no_of_subjects*no_of_activities), ]
row = 1
for (s in 1:no_of_subjects) {   #loop thorugh the subjects data set
  for (a in 1:no_of_activities) { #for each activity aggregate and find the mean 
    result[row, 1] = subjects[s]
    result[row, 2] = activities[a, 2]
    tmp <- data1[data1$subject==s & data1$activity==activities[a, 2], ]
    result[row, 3:no_of_cols] <- colMeans(tmp[, 3:no_of_cols])
    row = row+1
  }
}
```

## Write the result Averged Data set into the data_set_averaged.txt
```r
write.table(result, "data_set_averaged.txt",row.name=FALSE)
```


