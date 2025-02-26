# NOTE: Had to set different working directories to import data

library(readr)
library(reshape2)
library(base)
library(dplyr)

# Load Data
setwd("~/Data/UCI HAR Dataset/test")
subject_test <- read_table("subject_test.txt", col_names = FALSE)
X_test <- read_table("X_test.txt", col_names = FALSE)
y_test <- read_table("y_test.txt", col_names = FALSE)

setwd("~/Data/UCI HAR Dataset/train")
subject_train <- read_table("subject_train.txt", col_names = FALSE)
X_train <- read_table("X_train.txt", col_names = FALSE)
y_train <- read_table("y_train.txt", col_names = FALSE)

setwd("~/Data/UCI HAR Dataset")
activity_labels <- read_table("activity_labels.txt", col_names = FALSE)
features <- read_table("features.txt", col_names = FALSE)

# Merge Training and Test Sets
X_data <- rbind(X_test, X_train)
y_data <- rbind(y_test, y_train)
subject_data <- rbind(subject_test, subject_train)

# Apply Activity Names & Join Tables
names(subject_data) <- "Subject"
names(activity_labels) <- c("ActivityID", "Activity")
y_data <- left_join(y_data, activity_labels, by = c("X1" = "ActivityID"))


# Label the Data Sets
names(y_data) <- c("Activity ID", "Activity")
names(X_data) <- features$X1
final_data <- cbind(subject_data, y_data["Activity"], X_data)

# Extract Mean and Standard Deviation Measurements
mean_std_cols <- grep("mean\\(\\)|std\\(\\)", names(final_data))
final_data <- final_data[, c(1, 2, mean_std_cols)]

# Create Tidy Data Set with Averages
tidy_data <- final_data %>%
  group_by(Subject, Activity) %>%
  summarise(across(everything(), mean))

# Create the Tidy Data Text File
write.table(tidy_data, "tidy_data.txt", row.name = FALSE, quote = FALSE)

