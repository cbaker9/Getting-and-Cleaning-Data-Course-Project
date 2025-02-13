# Reading all files
# NOTE: Had to set different working directories to import data

library(readr)

#Set Working Directory
setwd("~/Data/UCI HAR Dataset/test")
setwd("~/Data/UCI HAR Dataset/train")
setwd("~/Data/UCI HAR Dataset")


subject_test <- read_table("subject_test.txt", col_names = FALSE)
X_test <- read_table("X_test.txt", col_names = FALSE)
y_test <- read_table("y_test.txt", col_names = FALSE)
subject_train <- read_table("subject_train.txt", col_names = FALSE)
X_train <- read_table("X_train.txt", col_names = FALSE)
y_train <- read_table("y_train.txt", col_names = FALSE)
activity_labels <- read_table("activity_labels.txt", col_names = FALSE)
features <- read_table("features.txt", col_names = FALSE)

# Assigning column names

colnames(subject_test) <- "subject_id"
colnames(X_test) <- features$X2
colnames(y_test) <- "activity_id"

colnames(subject_train) <- "subject_id"
colnames(X_train) <- features$X2
colnames(y_train) <- "activity_id"

colnames(activity_labels) <- c('activity_id', 'activity_types')


# Combining test and train data

test <- cbind(subject_test, X_test, y_test)
train <- cbind(subject_train, X_train, y_train)
test_train_combined <- rbind(train, test)


# Updating the new column names

updated_names <- colnames(test_train_combined)


# Extracts only the measurements on the mean and std deviation for each measurement

mean_std <- test_train_combined[, grepl("subject_id|activity_id|mean|std", updated_names)]


mean_std[1:2] <- TRUE


activity_names_final <- merge(mean_std, activity_labels,
                              by='activity_id',
                              all.x=TRUE)


# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

write.table(activity_names_final, "tidy.txt", row.names = FALSE, quote = FALSE)
