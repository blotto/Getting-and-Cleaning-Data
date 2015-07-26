# Getting-and-Cleaning-Data


# Purpose

This document describes the variables, the data, and any transformations performed to clean up the data.

# Source 

The data set was obtained from UC Irvine Machine Learning Repository.  It represents 'Human Activity Recognition Using Smartphones'  built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

* Reference : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
* Data Set:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the README.txt file for further details about this dataset. 

A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: [Web Link](http://www.youtube.com/watch?v=XOEN9W05_4A)


## Attribute Information:

For each record in the dataset it is provided: 
*  Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
*  Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

# Approach to Transformations

## 1. Load the data

Both the training set and subject data were loaded and normalized with the provided features. Features.txt provided the column names for x_test.txt and y_train.txt.  X_train.txt and y_train.txt represents the activity id which will later be transformed into activity labels. Similarly, subject_train.txt and subject_test.txt represents the subject id.

This data is then merged into ```allData``` data frame as such:

```R
allData <- rbind(trainingSet, testData)
```

## 2. Extraction

Only the mean and standard deviation from the data set are required.  A basic regex extraction was used based on the feature name using the following expression:

```R
"mean\\(\\)|std\\(\\)"
```

##  3. Humanize labels

The labeling is a bit cryptic.  In order to make them more readable some more regex was used to find and replace more obscure text with a bit more human friendly context.  For example:

* "std" transformed to  "StandardDev"
* "Mag" transformed to  "Magnitude"

## 4. Finalized data

The data was tidied for averages on each activity per test subject.  ```aggregate``` function was used for this purpose.  

```R
tidyData <- aggregate(presentableData[ ,names(presentableData) != c('aId','sId', 'aType')],
                      by=list(aId = presentableData$aId, sId = presentableData$sId),
                      mean)
```

This data frame is then exported as tidyData.txt.


