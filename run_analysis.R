# run_analysis.R
#
# David Berkowitz

run_analysis <- function ()
{
	cat ("run_analysis()\n")
  
  # Step 1
  # Merge the training and the test sets to create one data set.
	cat ("Step 1\n")
  
  # There are 2 directories: train and test
  # In each directory there are 3 files of interest.
  # Assumes we are one level above UCI HAR Dataset

  cat ("Reading subject_test:\n")
  subject_test = read.table ("UCI HAR Dataset/test/subject_test.txt")
  str (subject_test)
	
	cat ("Reading y_test:\n")
	y_test = read.table ("UCI HAR Dataset/test/y_test.txt")
	str (y_test)
  
  cat ("Reading X_test:\n")
  X_test = read.table ("UCI HAR Dataset/test/X_test.txt")
  str (X_test)

  # cbind these columns of data together
  
  cat ("test_data:")
  test_data = cbind (subject_test, y_test, X_test)
  str (test_data)
  head (test_data)
  
  # now do the same for the training data
  
	cat ("Reading subject_train:\n")
	subject_train = read.table ("UCI HAR Dataset/train/subject_train.txt")
	str (subject_train)
	
	cat ("Reading y_train:\n")
	y_train = read.table ("UCI HAR Dataset/train/y_train.txt")
	str (y_train)
  
	cat ("Reading X_train:\n")
	X_train = read.table ("UCI HAR Dataset/train/X_train.txt")
	str (X_train)
	  
	# cbind these columns of data together
  
  cat ("train_data:")
	train_data = cbind (subject_train, y_train, X_train)
	str (train_data)
	head (train_data)
  
  # finally, rbind the test data with the training data
  
  cat ("merged_data:")
  merged_data = rbind (test_data, train_data)
  str (merged_data)
  head (merged_data)
  
  # give the table some useful column names
  
	features = read.table ("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
  
	# the order of the column names is arbitrary
  # and depends only on the order in which the columns were bound
  column_names = c("subject", "activity", features[,2])
	names (merged_data) = column_names
  cat ("new names:")
  str (merged_data)
  
  saveRDS (merged_data, file="step1.rds")
  
  # Step 2
	# Extract only the measurements on the mean and standard deviation for each measurement.   
	cat ("Step 2\n")
  
  # grab all the columns with std or mean in the name
  
	meanORstd = merged_data[,grep ("mean|std", names (merged_data))]
  cat ("meanORstd:")
  names (meanORstd)
  
  # this new data frame has a few too many columns
  # specifically it includes columns with names like "meanFreq"
  
  # sadly it also excludes subject and activity
  
  # I choose to interpret the instructions to mean:
  # produce matched columns of data where there is both a mean and a std
  # and so the "meanFreq" columns need to go
  # note use of -grep to exclude columns
  
	meanORstd = meanORstd [,-grep ("meanFreq", names (meanORstd))]
	cat ("(updated) meanORstd:")
	names (meanORstd)
  
	saveRDS (meanORstd, file="step2.rds")
  
	# Step 3
	# Uses descriptive activity names to name the activities in the data set
	cat ("Step 3\n")
  
	activities = read.table ("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
  
  # oops - activities is no longer in the data!
  # if it were, this would replace the activity numbers with strings
  
	meanORstd$activity = factor (meanORstd$activity, levels=c(1, 2, 3, 4, 5, 6), labels=activities[,2])
  
	saveRDS (meanORstd, file="step3.rds")
  
	# Step 4
  # Appropriately labels the data set with descriptive variable names. 
	cat ("Step 4\n")
  
  # I feel this has already been done by using features.txt in step 1
  
	# Step 5
	# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	cat ("Step 5\n")

  #  exit
  
  cat ("done\n")
  
  return (meanORstd)
}