# tidy-data-project
Course project for "Getting and Cleaning Data" (Coursera Data Science track)

Prerequisite: have the data set in the working directory, or a subdirectory thereof.

Steps:

1. Load the script with:

      source "run_analysis.R"


2. Run the master function, assigning a variable to the output:

      dataset <- master()

   If the Samsung data is in a subdirectory (e.g., "data"), pass that subdirectory to master():

      dataset <- master("data")

The assigned variable will then have the tidy data set.

