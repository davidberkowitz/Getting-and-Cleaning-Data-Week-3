# run_analysis.R
#
# David Berkowitz

run_analysis <- function ()
{
	cat ("run_analysis()\n")
  
	########
	#
	# Step 1
	#
	########
  
  # Merge the training and the test sets to create one data set.
	cat ("Step 1\n")
  
  # There are 2 directories: train and test
  # In each directory there are 3 files of interest.
  # Assumes we are one level above UCI HAR Dataset

  cat ("Reading X_test:\n")
  X_test = read.table ("UCI HAR Dataset/test/X_test.txt")
  str (X_test)
  
  # now do the same for the training data

	cat ("Reading X_train:\n")
	X_train = read.table ("UCI HAR Dataset/train/X_train.txt")
	str (X_train)
  
  # finally, rbind the test data with the training data
  
  cat ("new_data:")
  new_data = rbind (X_test, X_train)
  str (new_data)
  
  saveRDS (new_data, file="step1.rds")
  
	########
	#
	# Step 2
	#
	########
  
	# Extract only the measurements on the mean and standard deviation for each measurement.   
	cat ("Step 2\n")
  
  # read in the feature names - they are in the second column
  
  cat ("features:")
	features = read.table ("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
  str (features)
  
  cat ("new_data with feature column names")
	names (new_data) = features[,2]
  str (new_data)
  
  # grab all the columns with std or mean in the name
  
	new_data = new_data[,grep ("mean|std", names (new_data))]
  cat ("new_data with only mean|std:")
  str (new_data)
  
  # new_data has a few too many columns
  # specifically it includes columns with names like "meanFreq"
  #
  # I choose to interpret the instructions to mean:
  # produce matched columns of data where there is both a mean and a std
  # and so the "meanFreq" columns need to go
  #
  # note use of -grep to exclude columns
  
	new_data = new_data [,-grep ("meanFreq", names (new_data))]
	cat ("new_data without meanFreq:")
	str (new_data)
  
	saveRDS (new_data, file="step2.rds")
  
  ########
  #
	# Step 3
  #
  ########
	
  # Uses descriptive activity names to name the activities in the data set
	cat ("Step 3\n")
  
  # grab the activity info
  
	cat ("Reading y_test:\n")
	y_test = read.table ("UCI HAR Dataset/test/y_test.txt")
	str (y_test)
  
	cat ("Reading y_train:\n")
	y_train = read.table ("UCI HAR Dataset/train/y_train.txt")
	str (y_train)
  
	cat ("activity_data:")
	activity_data = rbind (y_test, y_train)
	str (activity_data)
  
	# cbind the columns of data together
	
	cat ("new_data:")
	new_data = cbind (activity_data, new_data)
	str (new_data)
  
  # give the new column a name
  
  names (new_data)[1] = "activity"
  cat ("new_data with new column name:")
  str (new_data)
  
  # read in the activity strings
  
	activities = read.table ("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
  cat ("activities:")
  str (activities)
  
  # replace the activity numbers with strings
  
  new_data$activity = factor (new_data$activity, levels=c(1, 2, 3, 4, 5, 6), labels=activities[,2])
  
	saveRDS (new_data, file="step3.rds")
  
	########
	#
	# Step 4
	#
	########
  
  # Appropriately labels the data set with descriptive variable names. 
	cat ("Step 4\n")
  
  # I feel this has already been done by using features.txt in step 1
  # However we haven't read in the subject data yet
  # So do this now
  
	cat ("Reading subject_train:\n")
	subject_train = read.table ("UCI HAR Dataset/train/subject_train.txt")
	str (subject_train)
  
	cat ("Reading subject_test:\n")
	subject_test = read.table ("UCI HAR Dataset/test/subject_test.txt")
	str (subject_test)
  
	cat ("subject_data:")
	subject_data = rbind (subject_test, subject_train)
	str (subject_data)
  
	# cbind the columns of data together
	
	cat ("new_data:")
	new_data = cbind (subject_data, new_data)
	str (new_data)
  
	# give the new column a name
	
	names (new_data)[1] = "subject"
	cat ("new_data with new column name:")
	str (new_data)
  
	saveRDS (new_data, file="step4.rds")
  
	########
	#
	# Step 5
	#
	########
  
	# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	cat ("Step 5\n")
  
  library (ddplyr)
  
	#new_data = ddply(new_data, .(activity, subject), colwise(mean))
	group_by (new_data, activity, subject) %>% summarise_each(funs(mean)) %>% step5_data
  
	saveRDS (step5_data, file="step5.rds")
  
  # the new data set is independent in that it has been saved in a separate "step" RDS file
  # ste4.RDS and step5.RDS can be read independently
  #
  # (of course this is true for EVERY step in this R file)
  # all intermediate results are saved
  
  # we are done
  
  write.table (step5_data, "step5.txt", row.labels=FALSE)
  
  cat ("done\n")
  
  return (new_data)
}