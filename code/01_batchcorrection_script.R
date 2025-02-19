# Script created on 02/11/2025
# This is for batch correction, make sure necessary packages are installed

# Call the function
source("./code/functions/batch_correction.R")


# make sure the desired paths are correct
batch_correction(dataset_folder = "./data/raw_data/test_FCS_files/",
           panel_xcl = "./data/panel_md_test/samples_panel_test.xlsx",
           md_xcl = "./data/panel_md_test/samples_md_test.xlsx")




