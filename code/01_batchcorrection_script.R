# Script created on 02/11/2025
# This is for batch correction, make sure necessary packages are installed.

# Call the function
source("./code/functions/batch_correction.R")

# Make sure the desired paths are correct.
# Use the function and replace paths if needed.
batch_correction(
  dataset_folder = "./data/raw_data/test_FCS_files/", # FCS files/folder
  panel_xcl = "./data/panel_md_template/samples_panel_template.xlsx", # Panel excel file
  md_xcl = "./data/panel_md_template/samples_md_template.xlsx") # Metadata excel file




