## Code Book: Getting and Cleaning Data Course Project
### Script Description:
* This code book desbribes the script **run_analysis.R** script found in this repository.
* The script summarizes data obtained by measuring data from a Samsung Galaxy S II smart phone on the waist.  
  * A more detailed description of the data can be found here:
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones ](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
* Experiments were performed with 30 volunteers within an age bracket of 19-48 years.  Each person performed six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
* This script averages measurement data for all mean and standard deviation measurements.

### Script Results:
  1) SmartphoneOneRecordPerTest.csv - A tidy data set with one row per test performed (total of 10,299 records).  
  2) SmartphoneTidyDataSet.csv - The final tidy data set for this project, one record per subject and activity with averages for all test measurements (total of 180 records).

### Assumptions:
* The script assumes this data has been downloaded and unzipped into the working directory:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

* I did not use data from the "Inertial Signals" directories since it appears these files have been summarized in the X_test.txt and X_train.txt files.

* I did not keep any meanFreq() or Angle measurements because this did not seem to meet the definition for fields we should keep based on the project description.

###Files Used
* /UCI HAR Dataset/features.txt - Gives names for each field of data in the measurement set.
* /UCI HAR Dataset/test/X_test.txt - Actual measurement data for the test data set.
* /UCI HAR Dataset/train/X_train.txt - Actual measurement data for the train data set.
* /UCI HAR Dataset/test/subject_test.txt - Ties each test back to the subject the test was performed on.
* /UCI HAR Dataset/train/subject_train.txt - Ties each test back to the subject the test was performed on.
* /UCI HAR Dataset/test/y_test.txt - Gives an activity number for the measurement.
* /UCI HAR Dataset/train/y_train.txt - Gives an activity number for the measurement.
* /UCI HAR Dataset/activity_labels.txt - Translates activity numbers into descriptions.  
 

###Acknowledgments:
Reference for using this dataset:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


### Code Design / Script Processing Steps:

####1) Read measurement labels ( /UCI HAR Dataset/features.txt ).

  * Read the file and assign the feature names to a vector.

####2) Read/process measurement data ( /UCI HAR Dataset/test/X_test.txt and /UCI HAR Dataset/train/X_train.txt ).

  * Read in the test data and train data, combine into one data frame.
  * Assign measurement names based on data from step #1.  
  * Filter measure names and remove any label without the word mean() or std().  This is because we only want to keep mean and standard deviation measurements for the tidy data set. _NOTE_ - I did not keep any meanFreq() or Angle measurements because this did not seem to meet the definition for fields we should keep.

####3) Rename measures to more a more readable format.

  * Using substitution, remove abbreviations to make measure names more meaningful.
  * Take the t (time) and f (frequency) prefixes and move them to the end of the variable name.  This makes the data set more readable.

####4)  Create a sequence value named TestID to identify each test uniquely.  
  * NOTE - This is not needed in the final tidy data set but I used this for sorting and for testing the data.

####5)  Read subject identifiers ( /UCI HAR Dataset/test/subject_test.txt and /UCI HAR Dataset/train/subject_train.txt).

  * Read in the test data and train data, combine into one data frame.

####6)  Read activity descriptions and activity codes (UCI HAR Dataset/test/y_test.txt and /UCI HAR Dataset/train/y_train.txt and /UCI HAR Dataset/activity_labels.txt)

  * Read in the test data and train data, combine into one data frame.
  * Combine the data frame containing the sequence from step #4. This is needed to keep the data sorted so it will allign with other data frames when they are merged.
  * Merge activity lables with activity numbers from the tests, keep only the activity label (description).

####7) Combine data frames, summarize by Subject and Activity
  * Combine the three data frames into one (Subjects, Activities, Measurements).
  * Summarize data by subject and activity and calculate the average (mean) for each measurement.
  * Write the final result to a CSV file - *SmartphoneTidyDataSet.csv*
    
### Data Definition:
* This is a definition of the variables in the tidy data set (SmartphoneTidyDataSet.csv)

| Column Name                   | Description                                                                | Units |
|-------------------------------|----------------------------------------------------------------------------|-------|
|SubjectID|Test subject identifier from subject_test.txt and subject_train.txt files|N/A|
|ActivityDescription|Describes the activity being performed during the test|N/A|
|BodyAccelerationMeanXTime|Body acceleration on X axis, average of mean values|standard gravity units|
|BodyAccelerationMeanYTime|Body acceleration on Y axis, average of mean values|standard gravity units|
|BodyAccelerationMeanZTime|Body acceleration on Z axis, average of mean values|standard gravity units|
|GravityAccelerationMeanXTime|Gravity acceleration on X axis, average of mean values|standard gravity units|
|GravityAccelerationMeanYTime|Gravity acceleration on Y axis, average of mean values|standard gravity units|
|GravityAccelerationMeanZTime|Gravity acceleration on Z axis, average of mean values|standard gravity units|
|BodyAccelerationJerkMeanXTime|Body linear acceleration and angular velocity, average of mean values|standard gravity units|
|BodyAccelerationJerkMeanYTime|Body linear acceleration and angular velocity, average of mean values|standard gravity units|
|BodyAccelerationJerkMeanZTime|Body linear acceleration and angular velocity, average of mean values|standard gravity units|
|BodyGyroMeanXTime|Angular velocity measured by the gyroscope, average of mean values|radians per second|
|BodyGyroMeanYTime|Angular velocity measured by the gyroscope, average of mean values|radians per second|
|BodyGyroMeanZTime|Angular velocity measured by the gyroscope, average of mean values|radians per second|
|BodyGyroJerkMeanXTime|Body linear acceleration and angular velocity, average of mean values.|radians per second|
|BodyGyroJerkMeanYTime|Body linear acceleration and angular velocity, average of mean values.|radians per second|
|BodyGyroJerkMeanZTime|Body linear acceleration and angular velocity, average of mean values.|radians per second|
|BodyAccelerationMagnitudeMeanTime|Average of mean values, calculated using the Euclidean norm.|standard gravity units|
|GravityAccelerationMagnitudeMeanTime|Average of mean values, calculated using the Euclidean norm.|standard gravity units|
|BodyAccelerationJerkMagnitudeMeanTime|Average of mean values, calculated using the Euclidean norm.|standard gravity units|
|BodyGyroMagnitudeMeanTime|Average of mean values, calculated using the Euclidean norm.|radians per second|
|BodyGyroJerkMagnitudeMeanTime|Average of mean values, calculated using the Euclidean norm.|radians per second|
|BodyAccelerationMeanXFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|standard gravity units|
|BodyAccelerationMeanYFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|standard gravity units|
|BodyAccelerationMeanZFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|standard gravity units|
|BodyAccelerationJerkMeanXFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|standard gravity units|
|BodyAccelerationJerkMeanYFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|standard gravity units|
|BodyAccelerationJerkMeanZFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|standard gravity units|
|BodyGyroMeanXFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|radians per second|
|BodyGyroMeanYFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|radians per second|
|BodyGyroMeanZFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|radians per second|
|BodyAccelerationMagnitudeMeanFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|standard gravity units|
|BodyAccelerationJerkMagnitudeMeanFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|standard gravity units|
|BodyGyroMagnitudeMeanFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|radians per second|
|BodyGyroJerkMagnitudeMeanFrequency|Calculated using Fast Fourier Transform (FFT), average of mean values|radians per second|
|BodyAccelerationStdDevXTime|Body acceleration on X axis, average of standard deviations|standard gravity units|
|BodyAccelerationStdDevYTime|Body acceleration on Y axis, average of standard deviations|standard gravity units|
|BodyAccelerationStdDevZTime|Body acceleration on Z axis, average of standard deviations|standard gravity units|
|GravityAccelerationStdDevXTime|Gravity acceleration on X axis, average of standard deviations|standard gravity units|
|GravityAccelerationStdDevYTime|Gravity acceleration on X axis, average of standard deviations|standard gravity units|
|GravityAccelerationStdDevZTime|Gravity acceleration on X axis, average of standard deviations|standard gravity units|
|BodyAccelerationJerkStdDevXTime|Body linear acceleration and angular velocity, average of std deviations|standard gravity units|
|BodyAccelerationJerkStdDevYTime|Body linear acceleration and angular velocity, average of std deviations|standard gravity units|
|BodyAccelerationJerkStdDevZTime|Body linear acceleration and angular velocity, average of std deviations|standard gravity units|
|BodyGyroStdDevXTime|Angular velocity measured by the gyroscope, average of std deviations|radians per second|
|BodyGyroStdDevYTime|Angular velocity measured by the gyroscope, average of std deviations|radians per second|
|BodyGyroStdDevZTime|Angular velocity measured by the gyroscope, average of std deviations|radians per second|
|BodyGyroJerkStdDevXTime|Body linear acceleration and angular velocity, average of std deviations.|radians per second|
|BodyGyroJerkStdDevYTime|Body linear acceleration and angular velocity, average of std deviations.|radians per second|
|BodyGyroJerkStdDevZTime|Body linear acceleration and angular velocity, average of std deviations.|radians per second|
|BodyAccelerationMagnitudeStdDevTime|Average of std deviations, calculated using the Euclidean norm.|standard gravity units|
|GravityAccelerationMagnitudeStdDevTime|Average of std deviations, calculated using the Euclidean norm.|standard gravity units|
|BodyAccelerationJerkMagnitudeStdDevTime|Average of std deviations, calculated using the Euclidean norm.|standard gravity units|
|BodyGyroMagnitudeStdDevTime|Average of std deviations, calculated using the Euclidean norm.|radians per second|
|BodyGyroJerkMagnitudeStdDevTime|Average of std deviations, calculated using the Euclidean norm.|radians per second|
|BodyAccelerationStdDevXFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|standard gravity units|
|BodyAccelerationStdDevYFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|standard gravity units|
|BodyAccelerationStdDevZFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|standard gravity units|
|BodyAccelerationJerkStdDevXFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|standard gravity units|
|BodyAccelerationJerkStdDevYFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|standard gravity units|
|BodyAccelerationJerkStdDevZFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|standard gravity units|
|BodyGyroStdDevXFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|radians per second|
|BodyGyroStdDevYFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|radians per second|
|BodyGyroStdDevZFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|radians per second|
|BodyAccelerationMagnitudeStdDevFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|standard gravity units|
|BodyAccelerationJerkMagnitudeStdDevFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|standard gravity units|
|BodyGyroMagnitudeStdDevFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|radians per second|
|BodyGyroJerkMagnitudeStdDevFrequency|Calculated using Fast Fourier Transform (FFT), average of std deviations|radians per second|
