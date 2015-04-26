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
    data_set$readings <- apply_labels(data_set$readings)
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
#                              columns to indicate source (body/total), type (acc/gyro)
#                              and axis (x, y, z)]
#
read_and_merge_data <- function(directory = "") {
    path <- getwd()
    if (directory != "") { path <- path + "./" + directory }
    
    # Read reference data in top-level directory
    activity_ref = read.table(path + "/activity_label.txt", header = FALSE)
    labels = read.table(path + "/features.txt", header = FALSE)

    
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

# Read raw data from directory
#
# param:  directory - Name of the directory to extract data from
# return: List with elements "readings" (data), "subjects" (subject indices 1-30),
#         "activities" (activity indices, 1-6), and "inertial_signals"
#
read_raw <- function(directory) {
    data_type <- last_element(directory)
    subject_file <- paste(directory, "/", "subject_", data_type, ".txt", sep = "")
    reading_file <- paste(directory, "/", "X_", data_type, ".txt", sep = "")
    activity_file <- paste(directory, "/", "y_", data_type, ".txt", sep = "")
    inertial_dir <- paste(directory, "/Inertial Signals", sep = "")
    
    raw <- list(readings = read.table(reading_file, header = FALSE),
                subjects = read.table(subject_file, header = FALSE),
                activities = read.table(activity_file, header = FALSE),
                inertial_signals = read_inertial(inertial_dir, data_type))
    raw
}

# Read inertial signals from directory
#
# param:  directory - Name of the directory to extract data from
# return: Data frame with inertial data merged from all files, and four columns
#         added: "type" (test/train), "source" (body/total), "nature" (gyro/acc), and axis (x/y/z)
#
read_inertial <- function(directory, data_type) {
    files <- list.files(directory)

    # Initialize return data frame
    all_data <- NULL

    for (file in files) {
        # Get data
        data <- read.table(paste(directory, "/", file, sep = ""), header = FALSE)
        data <- as.data.frame(data)
        len <- length(data$V1)
        
        # Add labels to indicate source data file
        file_no_ext <- sub("\\.txt", "", file)
        elts <- strsplit(file_no_ext, split = "_")[[1]]
        data_source <- rep(elts[[1]], len)
        nature <- rep(elts[[2]], len)
        axis <- rep(elts[[3]], len)
        data <- cbind(data, type = rep(data_type, len))
        data <- cbind(data, source = data_source)
        data <- cbind(data, nature = nature)
        data <- cbind(data, axis = axis)
        
        if (is.null(all_data)) {
            all_data <- data
        } else {
            all_data <- rbind(all_data, data)
            rm(data)
        }
    }
    
    all_data
}

# Find the last path element of a directory path
#
# param:  path - Name of directory; e.g., "/my/directory/path/here"
# return: Last element in path: e.g., "here"
last_element <- function(path) {
    elts <- strsplit(path, split = "/")
    last_elt <- elts[[1]][[length(elts[[1]])]]
    last_elt
}

# Apply labels to columns in main data set
#
# param:  readings - Main data set (list with all readings, labels)
# return: Same data frame, with column names as specified in "readings/labels" element
#
apply_labels <- function(readings) {
    
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