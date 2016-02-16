getwd()
setwd("H:\\data_science\\coursera\\Clean_Assignment")

#download file
if(!file.exists("./data")){dir.create("./data")}
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
#explore the files
path <- file.path("./data" , "UCI HAR Dataset")
ActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
ActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
FeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
dataname<-c(ActivityTest, SubjectTest,ActivityTrain,SubjectTrain,FeaturesTest,FeaturesTrain )
for (i in dataname) {str(i);}
#Combine Data by rows
Subject <- rbind(SubjectTrain, SubjectTest)
Activity<- rbind(ActivityTrain,ActivityTest)
Features<- rbind(FeaturesTrain, FeaturesTest)
FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
str(FeaturesNames)
str(Subject)
names(Activity)<- c("activity")
names(Subject)<-c("subject")
names(Features)<- FeaturesNames$V2
dataCombine <- cbind(Subject, Activity)
Data <- cbind(Features, dataCombine)
str(data)
#Extracts only the measurements on the mean and standard deviation for each measurement. 
subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
selectedNames<-c(as.character(subFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)
#Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
str(activityLabels)
head(Data$activity,10)
Data$activity<-factor(Data$activity, labels=activityLabels[,2])
head(Data$activity,10)
#Appropriately labels the data set with descriptive variable names
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
#Creates a second,independent tidy data set and ouput it
library(plyr);
DataClean<-aggregate( .~subject + activity, Data, mean)
DataClean<-DataClean[order(DataClean$subject,DataClean$activity),]
write.table(DataClean, file = "CleanedData.txt",row.name=FALSE)
str(DataClean)
ls()
