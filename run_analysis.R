## -----------------------------------------------------------------------
## Read, merge, and process the accelerometer data set, producing a tidy
## data set at the end.
## -----------------------------------------------------------------------

# "Master control" function to run everything through.
#
# param:  directory - Directory to read data from, defaults to "data"
# return: A list with two elements:
#         - data     : Original data set, cleaned up as specified
#         - averages : Required "second, independent tidy data set" with averages
#                      of each variable for user and activity
#
master <- function(directory = "data") {
    data_set <- read_and_merge_data(directory)
    data_set$readings <- label(data_set$readings, directory, "features.txt")
}

# Read and merge the test and training data from the specified directory. Scans
# specified directory for subdirectories, grabs and merges data from each.
#
# param:  directory - The directory to read data from, default to "data"
# return: A list with the following elements, all data frames except the last:
#         - activity_ref     : Activity indices and labels (e.g., 1 ; STANDING)
#         - subjects         : Subject index for each record (1 col, 1-30)
#         - readings         : Main data records (561 cols of numeric data)
#         - activities       : Activity index for each record (1 col, 1-6)
#         - inertial_signals : Merged data from inertial signal files, with extra
#                              columns to indicate type (body/gyro/total) and axis (x, y, z)
#         - labels           : A character vector with main data column labels, read from
#                              features.txt (e.g., "tBodyAcc-mean()-x")
#
read_and_merge_data <- function(directory = "data") {
    
}

# Apply labels to columns in main data set
#
# param:  readings - Main data set (a data frame with 561 columns of numeric data)
# param:  labels   - Labels for columns in main data set (character vector)
# return: Same data frame, with column names as specified in "labels" parameter
#
label <- function(readings, labels) {
    
}

# "Slim down" the "readings" data frame to contain only mean and standard deviation data
#
# param:  readings - Data frame with numeric data, column names from features.txt
# return: New data frame with only columns of mean and standard deviation data
#
extract_mean_std <- function(readings) {
    
}

# Merge activity data and apply activity names to the main data frame
#
# param:  readings - Main data frame
# return: Original data frame, with columns added for activity index (1-6) and
#         activity name (e.g,. "STANDING")
#
apply_activity_names <- function(data) {
    
}

# Extract averages from source data, by user and activity
#
# param:  readings - Main data from
# return: Original data with averages by user, activity
#
average <- function(data) {
    
}