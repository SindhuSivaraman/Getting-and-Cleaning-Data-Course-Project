Getting-and-Cleaning-Data-Course-Project
========================================

Getting and Cleaning Data Course Project

The file `run_analysis.R` describes how the script/flow goes.

First, unzip the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and rename the folder as per your wish.
Make sure both the renamed folder and the run_analysis.R script are placed under the working directory of R.
Then, use source("run_analysis.R") command in RStudio to load the script from the file.
When you run the script file, two output files will be generated as output under the working directory of R:
`merged_data.txt (~7 Mb)` contains a data frame called cleanedData with 10299*68 dimension.
`data_with_means.txt (220 Kb)` contains a data frame called result with 180*68 dimension.
Finally, use the following command in RStudio to read the file.
  data <- read.table("data_with_means.txt")  
Since it is required to get the average of each variable for each activity and subject, and there are 6 activities in total and 30 subjects in total, we have 180 rows with all combinations for each of the 66 features.
