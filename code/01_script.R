# Script created on 02/11/2025
# This is a script to batch correct and compensate.

source("./code/functions/batch_correction.R")

# This is for batch correction, make sure necessary packages are installed
batch_correction(dataset_folder = "./data/raw_data/test_FCS_files/",
           panel_xcl = "./data/panel_md_test/samples_panel_test.xlsx",
           md_xcl = "./data/panel_md_test/samples_md_test.xlsx")




