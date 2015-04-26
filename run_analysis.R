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
    raw_data_set <- read_and_merge_raw_data(directory)
    raw_data_set$data <- apply_labels(data_set$data, data_set$labels)
    raw_data_set$data <- mix_in_subjects_and_activities(data_set$data)
    
    final_data_set <- average(raw_data_set$data)
    final_data_set
}

# Read and merge the test and training data from the specified directory. Scans
# specified directory for subdirectories, grabs and merges data from each.
#
# param:  directory - The directory to read data from, default to "" for working directory
# return: A list with the following elements, all data frames except the last:
#         - activity_ref     : Activity indices and labels (e.g., 1 ; STANDING)
#         - labels           : A character vector with main data column labels, read from
#                              features.txt (e.g., "tBodyAcc-mean()-x")
#         - data             : List with merged values from all types (test, train):
#                              readings - main data records (N x 561, numeric data),
#                              subjects - subject index for each record (N x 1, values 1-30),
#                              activities - activity index for each record (N x 1, values 1-6),
#                              inertial_signals - merged data from inertial signal files [with extra
#                                      columns to indicate source (body/total), type (acc/gyro)
#                                      and axis (x, y, z)]
#
read_and_merge_raw_data <- function(directory = "") {
    path <- getwd()
    if (directory != "") { path <- paste(path, directory, sep = "/") }
    
    # Read reference data in top-level directory
    activity_ref = read.table(paste(path, "activity_label.txt", sep = "/"), header = FALSE)
    labels = read.table(paste(path, "/features.txt", sep = "/"), header = FALSE)

    
    # Read measurement data from subdirectories (e.g., "test", "train")
    raw <- list()
    files <- list.files(path)

    for (file in files) {
        if (file.info(file)$isdir) {
            raw[file] <- read_raw(file)
        }
    }
    
    merged_raw <- merge_raw(raw)
    
    # Build and return main container list
    all_data <- list(activity_ref = activity_ref,
                     labels = labels,
                     data = merged_raw)
    all_data
}

# Read raw data from directory
#
# param:  directory - Name of the directory to extract data from
# return: List with elements:
#             - readings (data)
#             - subjects (subject indices 1-30),
#             - activities (activity indices, 1-6)
#             - inertial_signals [DF with cols: type, source, nature, axis, V1-V128]
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
#         data_type - Type of data ("test", "train")
# return: Data frame with inertial data merged from all files in directory, and four columns
#         added: "type" (test/train), "source" (body/total), "nature" (gyro/acc), and axis
#         (x/y/z) -- type from input parameter, others from file name ("body_acc_x_test.txt")
#
read_inertial <- function(directory, data_type) {
    files <- list.files(directory)

    # Initialize return data frame
    all_data <- NULL

    for (file in files) {
        # Read data from file in directory
        data <- read.table(paste(directory, "/", file, sep = ""), header = FALSE)
        data <- as.data.frame(data)
        
        # Add labels to indicate source data file
        file_no_ext <- sub("\\.txt", "", file)
        elts <- strsplit(file_no_ext, split = "_")[[1]]
        len <- length(data$V1)
        
        data_source <- rep(elts[[1]], len)
        nature <- rep(elts[[2]], len)
        axis <- rep(elts[[3]], len)
        
        data <- cbind(data, type = rep(data_type, len))
        data <- cbind(data, source = data_source)
        data <- cbind(data, nature = nature)
        data <- cbind(data, axis = axis)
        
        # Build up data frame
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

# Merge raw sets of readings, subjects, activities, inertial signals into combined
# data frames; return as list with same structure as original lists.
#
# param:  raw_data - List of lists of data. Main list keyed by type ("test", "train"),
#                    each sublist has $readings, $subjects, $activities, $inertial_signals
# return: All raw data merged into equivalent lists of concatenated data.
merge_raw <- function(raw_data) {
    readings <- NULL
    subjects <- NULL
    activities <- NULL
    inertial_signals <- NULL
    
    for (data in raw_data) {
        readings <- rbind(data$readings)
        subjects <- rbind(data$subjects)
        activities <- rbind(data$activities)
        inertial_signals <- rbind(data$inertial_signals)
    }
    
    merged <- list(readings = readings,
                   subjects = subjects,
                   activities = activities,
                   inertial_signals = inertial_signals)
    merged
}

# Apply labels to columns in main data set
#
# param:  data - Main data set (list with $readings, $labels)
# return: nothing
#
apply_labels <- function(data) {
    readings <- data$readings
    labels <- data$labels
    
    replace_col_name_flag = substr(names(readings), 1, 1) == "V"
    colnames(readings)[replace_col_name_flag] <- labels
    
    data$readings <- readings
    data
}

# Add columns for subject (1-30) and activity index (1-6) to data$readings
#
# param:  data - Main data set (list with data frames $readings [N x 561],
#                $subjects [N x 1], $activities [N x 1])
# return: Same data set, but with subjects and activities merged into readings
#
mix_in_subjects_and_activities <- function(data) {
    subjects <- as.data.frame(data$subjects)
    colnames(subjects) <- c("subject")
    
    activities <- as.data.frame(data$activities)
    colnames(activities) <- c("activity_index")
    
    readings <- cbind(data$readings, subjects, activities)
    data$readings <- readings
    
    data
}

# "Slim down" the "readings" data frame to contain only mean and standard deviation data
#
# param:  data - Data frame with numeric data, column names from features.txt
# return: New data frame with only columns of mean and standard deviation data
#
extract_mean_std <- function(data) {
    column_names <- colnames(data)
    is_mean_or_std_dev_flag = grep("(mean|std)", column_names, ignore.case = TRUE)
    desired_columns = column_names[is_mean_or_std_dev_flag]
    
    data[, desired_columns]
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