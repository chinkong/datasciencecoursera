# datasciencecoursera
MDEC MOOC Github Repository 

Getting and Cleaning Data - Week 4 Submission 

R package required:
* data.table
* tidyr
* plyr

Steps:
1. Read all 6 files into respective variables:
* subject train
* subject test
* activity train
* activity test
* data train
* data test

2. Merge all data into "allData" by row binding 
3. Set the column to appropriate readable names by referring to the features.txt file
4. Filter off unwanted columns (561 columns) to the desired 69 columns containing the means and std values
5. Replace all column names with meaning and appropriate names
6. Perform a select-group by on the allData

There are 10299 rows of data performed by 30 subjects across 6 activities. 
The end tidydata.txt has 180 rows with 69 colums of mean and std values.
