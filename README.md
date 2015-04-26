# tidy-data-project
Course project for "Getting and Cleaning Data" (Coursera Data Science track)

Prerequisite: have the data set in the working directory, or a subdirectory thereof. The data are included in this repository in the default location, for convenience.

Steps:

1. Load the script with:

      source "run_analysis.R"


2. Run the master function, assigning a variable to the output:

      dataset <- master()

   If the Samsung data is in a subdirectory (e.g., "data"), pass that subdirectory to master():

      dataset <- master("data")

The master() function scans the appropriate directory for reference files (features.txt and activity_labels.txt), then finds any subdirectories (test, train), building raw data sets from the contained files (including the Inertial Signals subdirectorty within).

Once the raw data are loaded and merged, the master() function labels the data appropriately, extracts the mean and standard deviation data from the main data set, and puts in activity names. This produces a clean, merged, legible data set with only the desired data.

The master() function then builds the final data set from the clean raw data, calculating averages on the remaining values by user and activity.

When the master() function returns, the assigned variable will then have the tidy data set.

Running this script requires the **dplyr** library.

