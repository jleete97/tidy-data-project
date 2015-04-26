## -----------------------------------------------------------------------
## Read, merge, and process the accelerometer data set, producing a tidy
## data set at the end.
## -----------------------------------------------------------------------

# "Master control" function to run everything through.
#
# param:  directory - Directory to read data from, defaults to "" for working directory
# return: A list with two elements:
#         - data     : Original data set, cleaned up as specified
#         - averages : Required "second, independent tidy data set" with averages
#                      of each variable for user and activity
#
master <- function(directory = "") {
    data_set <- read_and_merge_data(directory)
    data_set$readings <- label(data_set$readings, directory, "features.txt")
}

# Read and merge the test and training data from the specified directory. Scans
# specified directory for subdirectories, grabs and merges data from each.
#
# param:  directory - The directory to read data from, default to "" for working directory
# return: A list with the following elements, all data frames except the last:
#         - activity_ref     : Activity indices and labels (e.g., 1 ; STANDING)
#         - labels           : A character vector with main data column labels, read from
#                              features.txt (e.g., "tBodyAcc-mean()-x")
#         - readings         : List with main data records (561 cols of numeric data),
#                              activity index for each record (1 col, 1-6),
#                              subject index for each record (1 col, 1-30),
#                              merged data from inertial signal files [with extra
#                              columns to indicate type (body/gyro/total) and axis (x, y, z)]
#
read_and_merge_data <- function(directory = "") {
    path <- getwd()
    if (directory != "") { path <- path + "./" + directory }
    
    # Read reference data in top-level directory
    activity_ref = read.table(path + "/activity_label.txt")
    labels = read.table(path + "/features.txt")

    
    # Read measurement data from subdirectories (e.g., "test", "train")
    raw <- list()
    files <- list.files(path)

    for (file in files) {
        if (file.info(file)$isdir) {
            raw[file] <- read_raw(file)
        }
    }
    
    # Build and return main container list
    all_data <- list(activity_ref = activity_ref, subjects = subjects, readings = readings,
                    activities = activities, inertial_signals = inertial_signals, labels = labels)
    all_data
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