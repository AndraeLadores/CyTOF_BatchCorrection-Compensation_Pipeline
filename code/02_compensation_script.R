# Script created on 2/18/25
# This is a script for compensation, make sure necessary packages are installed.

# Call the compensation function
source("./code/functions/compensation.R")

# Make sure the desired paths are correct.
# Use the function and replace paths if needed.
compensate(
  FCS_files = "./data/raw_data/test_FCS_files/", # Desired FCS files
  panel_xcl = "./data/panel_md_test/samples_panel_test.xlsx", # Panel excel file
  md_xcl = "./data/panel_md_test/samples_md_test.xlsx", # Metadata excel file
  spillover_file = "./data/cytof_spillover_matrix_wDi.xlsx") # Spillover file
