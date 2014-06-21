To run the run_analysis.R set the correct path into setwd command. The correct path is the path where you are running the script. This path must include the "UCI HAR Dataset" folder containing all the data.

The run_analysis script will display the tidy data set.

The script works as indicated below:
Read all files from "UCI HAR Dataset"
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Labels the data set with descriptive variable names. 
Creates a tidy data set with the average of each variable for each activity and each subject.
