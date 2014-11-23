---
output: pdf_document
---
# Getting-and-Cleaning-Data-Week-3

### Code Book

#### Intro

As dicussed in README.md [link pending], the assignment is: 

> You should create one R script called run_analysis.R that does the following. 
>
> 1. Merges the training and the test sets to create one data set.
>
> 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
>
> 3. Uses descriptive activity names to name the activities in the data set
>
> 4. Appropriately labels the data set with descriptive variable names. 
>
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

We are given a zip file which expands into this hierarchy of files:
Davids-MacBook-Air:Getting-And-Cleaning-Data-Week-3 davidberkowitz$ ls -lR UCI\ HAR\ Dataset/
total 64
-rwxr-xr-x@ 1 davidberkowitz  staff   4453 Dec 10  2012 README.txt
-rwxr-xr-x@ 1 davidberkowitz  staff     80 Oct 10  2012 activity_labels.txt
-rwxr-xr-x@ 1 davidberkowitz  staff  15785 Oct 11  2012 features.txt
-rwxr-xr-x@ 1 davidberkowitz  staff   2809 Oct 15  2012 features_info.txt
drwxr-xr-x@ 6 davidberkowitz  staff    204 Nov 29  2012 test
drwxr-xr-x@ 6 davidberkowitz  staff    204 Nov 29  2012 train

UCI HAR Dataset//test:
total 51712
drwxr-xr-x@ 11 davidberkowitz  staff       374 Nov 29  2012 Inertial Signals
-rwxr-xr-x@  1 davidberkowitz  staff  26458166 Nov 29  2012 X_test.txt
-rwxr-xr-x@  1 davidberkowitz  staff      7934 Nov 29  2012 subject_test.txt
-rwxr-xr-x@  1 davidberkowitz  staff      5894 Nov 29  2012 y_test.txt

UCI HAR Dataset//train:
total 128992
drwxr-xr-x@ 11 davidberkowitz  staff       374 Nov 29  2012 Inertial Signals
-rwxr-xr-x@  1 davidberkowitz  staff  66006256 Nov 29  2012 X_train.txt
-rwxr-xr-x@  1 davidberkowitz  staff     20152 Nov 29  2012 subject_train.txt
-rwxr-xr-x@  1 davidberkowitz  staff     14704 Nov 29  2012 y_train.txt

#### Step 1

> 1. Merges the training and the test sets to create one data set.

The data sets to be merged are:
./UCI HAR Dataset/test/y_test.txt
./UCI HAR Dataset/train/y_train.txt

We will assume the dataset has been unzipped and lives in the current directory as directory hierarchy starting at "UCI HAR Dataset".

The intermediate result is saved in the file:
step1.rds

#### Step 2

> 2. Extracts only the measurements on the mean and standard deviation for each measurement.

The current merged data set has no column labels. We now need them to determine which are mean and standard deviation or std.

The column labels are contained in the file:
./UCI HAR Dataset/features.txt

A quick grep of mean() and std() reveals there are unwanted columns of the form *meanFreq* which are removed in a second step.

The intermediate result is saved in the file:
step2.rds

#### Step 3

> 3. Uses descriptive activity names to name the activities in the data set

This is a straightforward replacement of a numeric value in one column from domain  [1:6] to a character string held in the following file:

At the same time the activity column is given the name: "activity".

The intermediate result is saved in the file:
step3.rds

#### Step 4

> 4. Appropriately labels the data set with descriptive variable names. 

For the most part this has already been done in steps 2. The question is: is this "descriptive" enough? For example is it meaningful enough that variables of the form t<something> are time-domain while those of the form f<something> are frequency-domain? Explaining Fourier transforms seems beyond the scope of this project and the reader should consult other readily available sources findable with Google for example.

For the moment I have decided that the variable names are sufficiently descriptive. If I have sufficient time and interest I might make some small improvements. In any case you are directed to the following file which does quite a good job of decribing the data columns:
./UCI HAR Dataset/features_info.txt

The intermediate result is saved in the file:
step4.rds

#### Step 5

> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This is perhaps the most complex data transformation in this project. There are 30 subjects and 6 activities. Which means there will be at most 180 rows in this final result (if all activities were captured for all subjects).

The final result is saved in the file:
step5.rds
as well as an exported text file:
step5.txt

