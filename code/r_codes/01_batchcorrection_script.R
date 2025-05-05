# Script created on 02/11/2025
# This is for batch correction, make sure necessary packages are installed.

# Set directory (for shell script)
setwd(dirname(getwd()))

# Call the function
source("./code/r_codes/functions/batch_correction.R")

# Code to let shell script use multiple parameters
args <- commandArgs(trailingOnly = TRUE)

# Setting up arguments to designated file path variable
# Make sure the desired paths are correct.
raw_dataset_folder <- args[1] # FCS files/folder
panel_xcl <- args[2] # Panel excel file
md_xcl <- args[3] # Metadata excel file

# Use function
batch_correction(
  raw_dataset_folder = raw_dataset_folder,
  panel_xcl = panel_xcl,
  md_xcl = md_xcl)




