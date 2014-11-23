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
  # Merge the training and the test sets to create one data set.
  #
	########
  
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
	# Extract only the measurements on the mean and standard deviation for each measurement.   
  #
	########
  
	cat ("Step 2\n")
  
  # read in the feature names - they are in the second column
  
  cat ("features:")
	features = read.table ("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
  str (features)
  
  cat ("new_data with feature column names")
	names (new_data) = features[,2]
  str (new_data)
  
  # grab all the columns with std or mean in the name
  
	cat ("new_data with only mean|std:")
	new_data = new_data[,grep ("mean|std", names (new_data))]
  str (new_data)
  
  # new_data has a few too many columns
  # specifically it includes columns with names like "meanFreq"
  #
  # I choose to interpret the instructions to mean:
  # produce matched columns of data where there is both a mean and a std
  # and so the "meanFreq" columns need to go
  #
  # note use of -grep to exclude columns

	cat ("new_data without meanFreq:")
	new_data = new_data [,-grep ("meanFreq", names (new_data))]
	str (new_data)
  
	saveRDS (new_data, file="step2.rds")
  
  ########
  #
	# Step 3
  #
  # Use descriptive activity names to name the activities in the data set
  #
	########
  
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
  
	cat ("new_data with new column name:")
  names (new_data)[1] = "activity"
  str (new_data)
  
  # read in the activity strings

	cat ("activities:")
	activities = read.table ("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
  str (activities)
  
  # replace the activity numbers with strings
  
  new_data$activity = factor (new_data$activity, levels=c(1, 2, 3, 4, 5, 6), labels=activities[,2])
  
	saveRDS (new_data, file="step3.rds")
  
	########
	#
	# Step 4
	#
	# Appropriately labels the data set with descriptive variable names. 
  #
	########
  
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
	
	cat ("new_data with new column name:")
	names (new_data)[1] = "subject"
	str (new_data)
  
	saveRDS (new_data, file="step4.rds")
  
	########
	#
	# Step 5
	#
	# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  #
	########
  
  cat ("Step 5\n")
  
  library (dplyr)
	step5_data = group_by (new_data, activity, subject) %>% summarise_each(funs(mean))
  
  # at this point we have a very wide data set
  # which is close to tidy, but one more step will do it
  # we melt the data frame to collapse the 66 measurement columns into a single "measurement type" column
  
  library (reshape2)
	step5_melt = melt (step5_data, id=c("activity", "subject"), variable.name = "measurement_type", value.name = "mean_value")
  
  # the new data set is independent in that it has been saved in a separate "step" RDS file
  # step4.RDS and step5.RDS can be read independently
  #
  # (of course this is true for EVERY step in this R file)
  # all intermediate results are saved
  
  # we are done
  
	saveRDS (step5_melt, file="step5.rds")
  write.table (step5_melt, file="step5.txt", row.names=FALSE)
  
  # but just for fun,
  # let's create a fun visualization using ggplot
  #
  # I claim that if this can be done easily,
  # while providing a meaningful graph,
  # it suggests that that data is indeed tidy
  
  library (ggplot2)
  
	g = ggplot (step5_melt, aes (x=subject, y=mean_value)) +
    geom_point (alpha = 0.3) + 
    facet_grid (activity ~ measurement_type) +
    theme (strip.text.x = element_text (angle=90))
	ggsave ("step5.png", width = 18, height=14)
  
  cat ("done\n")
  
  return (step5_melt)
}