features = read.table("features.txt")
features= features[,2]
our_features <- grepl("mean|std", features)

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

train_labels[,2] = activity_labels[train_labels[,1]]

names(train_labels) = c("activityid", "activityname")

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

test_labels[,2] = activity_labels[test_labels[,1]]
names(test_labels) = c("activityid", "activityname")

#merge three test data frames together
all_test_data <- cbind(test_subject, test_data, test_labels)

all_data <- rbind(all_train_data, all_test_data)

all_tidy_data <- aggregate(. ~subjectid + activityname, all_data, mean)
#make names lowercase
names(all_tidy_data) = tolower(names(all_tidy_data))
#clean up heading names so they are more readable
names(all_tidy_data) = sub("bodybody","body",names(all_tidy_data))
names(all_tidy_data) = sub("acc","accelerometer",names(all_tidy_data))
names(all_tidy_data) = sub("gyro","gyroscope",names(all_tidy_data))
names(all_tidy_data) = sub("^f","frequency",names(all_tidy_data))
names(all_tidy_data) = sub("^t","time",names(all_tidy_data))

#clean up the activityname column so the activities are in lowercase and remove "_"
all_tidy_data[,2] = sub("_","",all_tidy_data[,2])
all_tidy_data[,2] = tolower(all_tidy_data[,2])

all_tidy_data <- all_tidy_data[order(all_tidy_data$subjectid,all_tidy_data$activityname),]

write.table(all_tidy_data, file="all_tidy_data.txt", row.name=FALSE)
 