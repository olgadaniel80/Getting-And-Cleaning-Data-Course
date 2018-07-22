library(dplyr)
#test variables
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
x_test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
y_test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)

#table of test variables
test_table <- data.frame(subject_test, x_test, y_test)

#train variables
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
x_train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
y_train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)

#table of train variables
train_table <- data.frame(subject_train, x_train, y_train)

#join train and test tables
joint_table <- rbind(test_table, train_table)

#column names of joint table
features <- read.csv("UCI HAR Dataset/features.txt", sep = "", header = FALSE)
column_names <- as.vector(features[,2])


colnames(joint_table) <- c("subject_id", "activity_labels", column_names)
activity_labels_var <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)

#only mean or standars deviations
joint_table_no_dupl <- joint_table[, !duplicated(colnames(joint_table))]
joint_table_mean_std <- select(joint_table_no_dupl, "subject_id", "activity_labels", matches("(.mean|.std)\\(\\)"))

joint_table_mean_std$activity_labels <- as.character(activity_labels_var[match(joint_table_mean_std$activity_labels, activity_labels_var$V1), 'V2'])

joint_table_summarized <- joint_table_mean_std %>% group_by(subject_id, activity_labels) %>% summarize_all(funs(mean))
write.table(joint_table_mean_std, file="joint_table_summarized.txt", row.names = FALSE)