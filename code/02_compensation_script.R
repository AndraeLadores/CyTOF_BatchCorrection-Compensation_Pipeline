# Script created on 2/18/25
# This is a script for compensation.

# Call the compensation function
source("./code/functions/compensation.R")

# Make sure the desired paths are correct
compensate(FCS_files = "./data/raw_data/test_FCS_files/",
           panel_xcl = "./data/panel_md_test/samples_panel_test.xlsx",
           md_xcl = "./data/panel_md_test/samples_md_test.xlsx",
           spillover_file = "./data/cytof_spillover_matrix_wDi.xlsx")
