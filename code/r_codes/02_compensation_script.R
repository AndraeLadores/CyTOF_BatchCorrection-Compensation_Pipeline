# Script created on 2/18/25
# This is a script for compensation, make sure necessary packages are installed.

# Set directory (for shell script)
setwd(dirname(getwd()))

# Call the compensation function
source("./code/r_codes/functions/compensation.R")

# Code to let shell script use multiple parameters
args <- commandArgs(trailingOnly = TRUE)

# Setting up arguments to designated file path variable
# Make sure the desired paths are correct.
FCS_files <- args[1] # FCS files/folder
panel_xcl <- args[2] # Panel excel file
md_xcl <- args[3] # Metadata excel file
spillover_file <- args[4] #spillover matrix file

# Using function
compensate(
  FCS_files = FCS_files,
  panel_xcl = panel_xcl,
  md_xcl = md_xcl,
  spillover_file = spillover_file)
