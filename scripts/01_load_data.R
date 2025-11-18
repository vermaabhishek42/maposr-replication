# ---------------------------------
# script: 01_load_data.R
# Purpose: load the MapOSR dataset for replication
# --------------------------------------

# ------------------------------
# install the tidyverse pacakage (contains readr, dplyr, ggplot2, data manipulation tools etc.)
# install.pacakages("tidyverse") required ony once

# load the pacakage.
library(tidyverse)

# read the maposr csv file
maposr <- read_csv("data/mapOSR_data_V5_9_3_220419_coded_clean.csv")

# look at the structure of the data sets
glimpse(maposr)

# look at the first few rows
head(maposr)

# quick summary of the year variable , no column wiht the year in it 
summary(maposr$year)

# cheking the number of columns 
colnames(maposr)

# checking the column publication year insted of year
maposr$`Publication Year`

# quick summary of the Publication Year
summary(maposr$`Publication Year`)

# This will give output like:
#Minimum year
#Maximum year
#Median year
#Mean year
#Quartiles
#Missing values


# checking if all the acion categories are clean or not (to replicate the figure 2)
table(maposr$Action)
