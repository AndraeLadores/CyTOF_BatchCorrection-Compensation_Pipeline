# Script created on 2/18/25
# This is a script for compensation, make sure necessary packages are installed.

# Call the compensation function
source("./code/functions/compensation.R")

# Make sure the desired paths are correct.
# Use the function and replace paths if needed.
compensate(
  FCS_files = "./data/raw_data/test_FCS_files/", # Desired FCS files
  panel_xcl = "./data/panel_md_template/samples_panel_template.xlsx", # Panel excel file
  md_xcl = "./data/panel_md_template/samples_md_template.xlsx", # Metadata excel file
  spillover_file = "./data/spillover/cytof_spillover_matrix_template.xlsx") # Spillover file
