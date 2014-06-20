# Step1. A single dataset is created by merging the training and the test sets.
# Set the working directory where the downloaded data is present
# Read the data from the "x_train" file
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
# see the dimensions of the data
dim(trainData) # 7352*561
# Display and view the head of the data
head(trainData)
# Read the data from the "y_train" file
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
table(trainActivity)
# Read the data from the "subject_train" file
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
# Read the data from all the files under "test" folders
testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
dim(testData) # 2947*561
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt") 
table(testActivity) 
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
# Join both the test and train data by "row bind"
joinTrainAndTestData <- rbind(trainData, testData)
dim(joinTrainAndTestData) # 10299*561
# Join both the test and train label data by "row bind"
joinTrainAndTestActivity <- rbind(trainActivity, testActivity)
dim(joinTrainAndTestActivity) # 10299*1
# Join both the test and train subject data by "row bind"
joinTrainAndTestSubject <- rbind(trainSubject, testSubject)
dim(joinTrainAndTestSubject) # 10299*1

# Step2. Extracts only the measurements on the mean and standard 
# deviation for each measurement. 
features <- read.table("./UCI HAR Dataset/features.txt")
dim(features)  # 561*2
# find mean from the "features" data
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
length(meanStdIndices) # 66
joinTrainAndTestData <- joinTrainAndTestData[, meanStdIndices]
dim(joinTrainAndTestData) # 10299*66
names(joinTrainAndTestData) <- gsub("\\(\\)", "", features[meanStdIndices, 2]) # remove "()"
names(joinTrainAndTestData) <- gsub("mean", "Mean", names(joinTrainAndTestData)) # capitalize M
names(joinTrainAndTestData) <- gsub("std", "Std", names(joinTrainAndTestData)) # capitalize S
names(joinTrainAndTestData) <- gsub("-", "", names(joinTrainAndTestData)) # remove "-" in column names 

# Step3. Uses descriptive activity names to name the activities in 
# the data set
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
activityLabel <- activity[joinTrainAndTestActivity[, 1], 2]
joinTrainAndTestActivity[, 1] <- activityLabel
names(joinTrainAndTestActivity) <- "activity"

# Step4. Appropriately labels the data set with descriptive activity 
# names. 
names(joinTrainAndTestSubject) <- "subject"
cleanedData <- cbind(joinTrainAndTestSubject, joinTrainAndTestActivity, joinTrainAndTestData)
dim(cleanedData) # 10299*68
write.table(cleanedData, "merged_data.txt") # write out the 1st dataset

# Step5. Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
subjectLen <- length(table(joinTrainAndTestSubject)) # 30
activityLen <- dim(activity)[1] # 6
columnLen <- dim(cleanedData)[2]
tidyData <- matrix(NA, nrow=subjectLen*activityLen, ncol=columnLen) 
tidyData <- as.data.frame(tidyData)
colnames(tidyData) <- colnames(cleanedData)
row <- 1
for(i in 1:subjectLen) {
        for(j in 1:activityLen) {
                tidyData[row, 1] <- sort(unique(joinTrainAndTestSubject)[, 1])[i]
                tidyData[row, 2] <- activity[j, 2]
                bool1 <- i == cleanedData$subject
                bool2 <- activity[j, 2] == cleanedData$activity
                tidyData[row, 3:columnLen] <- colMeans(cleanedData[bool1&bool2, 3:columnLen])
                row <- row + 1
        }
}
head(tidyData)
write.table(tidyData, "tidy_data.txt") # write out the tidy data to a text file named `tidy_data.txt`

# data <- read.table("./tidy_data.txt")
