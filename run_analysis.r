# Source of data for this project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# 1. Read Train and Test data sets and merge.
train <- read.table("train/X_train.txt")
test <- read.table("test/X_test.txt")
X <- rbind(train, train)

train <- read.table("train/subject_train.txt")
test <- read.table("test/subject_test.txt")
S <- rbind(train, test)
names(S) <- "subject"

train <- read.table("train/y_train.txt")
test <- read.table("test/y_test.txt")
Y <- rbind(train, test)


# 2. Read features and filtering for mean and stdev for each measurement.
features <- read.table("features.txt")
indices <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

X <- X[, indices]
names(X) <- features[indices, 2]
names(X) <- tolower(gsub("\\(|\\)", "", names(X)))
#names(X) <- tolower(names(X))

# 3. Reading activity names, and naming   the activities in the data set.
activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"

# 4. Appropriately labels the data set with descriptive activity names.

data1 <- cbind(S, Y, X)
write.table(data1, "merged_Dataset.txt",row.name=FALSE)

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
subjects = unique(S)[,1]
no_of_subjects = length(unique(S)[,1])
no_of_activities = length(activities[,1])
no_of_cols = dim(data1)[2]
result = data1[1:(no_of_subjects*no_of_activities), ]
row = 1
for (s in 1:no_of_subjects) {
  for (a in 1:no_of_activities) {
    result[row, 1] = subjects[s]
    result[row, 2] = activities[a, 2]
    tmp <- data1[data1$subject==s & data1$activity==activities[a, 2], ]
    result[row, 3:no_of_cols] <- colMeans(tmp[, 3:no_of_cols])
    row = row+1
  }
}
write.table(result, "data_set_averaged.txt",row.name=FALSE)