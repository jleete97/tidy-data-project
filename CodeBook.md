# Code book for Tidy Data Project

The read_and_merge_raw_data() function merges the test and train data into a single data set with the following attributes:

- activity_ref : a data frame listing the activities (1 - WALKING, 2 - WALKING_UPSTAIRS, etc.)
- labels : a data frame listing the labels for each column in the primary measurement data (1 - tBodyAcc-mean()-X, etc.)
- data : the main data set, see below.

The "data" section of the main data set holds the test and training readinds, with the following structure:

- readings : a data frame with N observations of 561 variables.
- subjects : a data frame with N observations of 1 variable, the subject (1-30), corresponding to the readings.
- activities : a data frame with N observations of 1 variable, the activity (1-6), corresponding to the readings. The activity number matches the first column of activity_ref in the overall data set.
- inertial_signals : a data frame containing the inertial signal data, with columns V1 to V128 for the initial data, and added columns "type" (train/test), "source" (body/total), nature (acc/gyro), and axis (x/y/z).

The final output has averages of all variables, grouped by user and activity.

The source data come from the UCI Machine Learning Repository at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. The included README.txt file has further information about the particulars of the activities measured, data normalization, etc.

