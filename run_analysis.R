# change working directory
setwd("/home/inigo/Downloads")

# read files
library(data.table)
pathFiles <- file.path(getwd(), "UCI HAR Dataset")
fSubjectTrain <- fread(file.path(pathFiles, "train", "subject_train.txt"))
fSubjectTest  <- fread(file.path(pathFiles, "test" , "subject_test.txt" ))
fTrainY <- fread(file.path(pathFiles, "train", "y_train.txt"))
fTestY  <- fread(file.path(pathFiles, "test" , "y_test.txt" ))
fTrainX <- data.table(read.table(file.path(pathFiles, "train", "X_train.txt"))) # error in fread
fTestX  <- data.table(read.table(file.path(pathFiles, "test" , "X_test.txt" ))) # error in fread
fLabels<- fread(file.path(pathFiles, "activity_labels.txt"))
fFeatures <- fread(file.path(pathFiles, "features.txt"))

# Concat and merge files
fSubject <- rbind(fSubjectTrain, fSubjectTest)
setnames(fSubject, "V1", "subject")
fX <- rbind(fTrainX, fTestX)
#setnames(fX, "V1", "activityNum")
fY <- rbind(fTrainY, fTestY)
setnames(fY, "V1", "activityNum")
f <- cbind(fSubject, fY)
f <- cbind(f, fX)
setkey(f, subject, activityNum)

# Extracts mean and standard deviation
setnames(fFeatures, names(fFeatures), c("featureNum", "featureName"))
fFeatures <- fFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]
fFeatures$featureCode <- fFeatures[, paste0("V", featureNum)]
select <- c(key(f), fFeatures$featureCode)
f <- f[, select, with=FALSE]

# Use descriptive activity names
setnames(fLabels, names(fLabels), c("activityNum", "activityName"))

#Merge
library(reshape2)
f <- merge(f, fLabels, by="activityNum", all.x=TRUE)
setkey(f, subject, activityNum, activityName)
f <- data.table(melt(f, key(f), variable.name="featureCode"))
f <- merge(f, fFeatures[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE)
f$activity <- factor(f$activityName)
f$feature <- factor(f$featureName)
## 1 cat
f$featJerk <- factor(grepl("Jerk",f$feature), labels=c(NA, "Jerk"))
f$featMagnitude <- factor(grepl("Mag",f$feature), labels=c(NA, "Magnitude"))
## 2 cat
n <- 2
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepl("^t",f$feature), grepl("^f",f$feature)), ncol=nrow(y))
f$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))
x <- matrix(c(grepl("Acc",f$feature), grepl("Gyro",f$feature)), ncol=nrow(y))
f$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepl("BodyAcc",f$feature), grepl("GravityAcc",f$feature)), ncol=nrow(y))
f$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))
x <- matrix(c(grepl("mean()",f$feature), grepl("std()",f$feature)), ncol=nrow(y))
f$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))
## 3 cat
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepl("-X",f$feature), grepl("-Y",f$feature), grepl("-Z",f$feature)), ncol=nrow(y))
f$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

# Create a tidy data set
setkey(f, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
fTidy <- f[, list(count = .N, average = mean(value)), by=key(f)]
fTidy
write.table(fTidy, "tidy.csv")
