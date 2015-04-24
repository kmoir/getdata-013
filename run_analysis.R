features = read.table("features.txt")
features= features[,2]
features
our_features <- grepl("mean|std", features)
our_features

activity_labels = read.table("activity_labels.txt")
activity_labels = activity_labels[,2]

#training data
train_data = read.table("train/X_train.txt")

#training labels
train_labels = read.table("train/y_train.txt")

#Each row identifies the subject who performed the activity for each window sample. 
#Its range is from 1 to 30.
train_subject = read.table("train/subject_train.txt")
names(train_subject) = c("subjectid")

names(train_data) = features
train_data = train_data[,our_features]
head(train_data)

train_labels[,2] = activity_labels[train_labels[,1]]
head(train_labels)

names(train_labels) = c("activityid", "activityname")
tail(train_labels, n=5)

#merge three training data frames together
all_train_data <- cbind(train_subject, train_data, train_labels)

#test set
test_data = read.table("test/X_test.txt")

#test labels
test_labels = read.table("test/y_test.txt")
#Each row identifies the subject who performed the activity for each window sample. 
#Its range is from 1 to 30.
test_subject = read.table("test/subject_test.txt")
names(test_subject) = "subjectid"

names(test_data) = features
test_data = test_data[,our_features]
head(test_data)

test_labels[,2] = activity_labels[test_labels[,1]]
names(test_labels) = c("activityid", "activityname")
tail(test_labels, n=5)

#merge three test data frames together
all_test_data <- cbind(test_subject, test_data, test_labels)

all_data <- rbind(all_train_data, all_test_data)

library(plyr)
all_data_tidy <- aggregate(. ~subjectid + activityname, all_data, mean)
#make names lowercase
names(all_data_tidy) = tolower(names(all_data_tidy))
#clean up variable names so they are more readable
names(all_data_tidy) = sub("bodybody","body",names(all_data_tidy))
names(all_data_tidy) = sub("acc","accelerometer",names(all_data_tidy))
names(all_data_tidy) = sub("gyro","gyroscope",names(all_data_tidy))
names(all_data_tidy) = sub("^f","frequency",names(all_data_tidy))
names(all_data_tidy) = sub("^t","time",names(all_data_tidy))

#should mean results be in a new column?
all_data_tidy <- all_data_tidy[order(all_data_tidy$subjectid,all_data_tidy$activityname),]

