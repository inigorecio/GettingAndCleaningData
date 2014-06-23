Input data
----------
X_test.txt

X_train.txt

y_test.txt

y_train.txt

subject_test.txt

subject_train.txt

features.txt

activity_labels.txt

Requirements
------------
1- To run the run_analysis.R set the correct path into setwd command. The correct path is the path where you are running the script. 

2- This path must include the "UCI HAR Dataset" folder containing all the data. 

3- "data.table" and "reshape2" packages are required.


Transformations
---------------
1-Merges the training and the test sets to create one data set.

2-Extracts only the measurements on the mean and standard deviation for each measurement.

3-Uses descriptive activity names to name the activities in the data set

4-Labels the data set with descriptive variable names.

5-Creates a tidy data set with the average of each variable for each activity and each subject.


Output data
-----------
The run_analysis script will display the tidy data set in screen and it will create "tidy.csv" file in execution directory.

Columns:

subject

activity

featDomain

featAcceleration

featInstrument

featJerk

featMagnitude

featVariable

featAxis



