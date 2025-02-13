# Function for batch correction part. Created on 2/12/25

# Run necessary packages
library("cyCombine")
library("magrittr")
library("stringr")
library("dplyr")
library("readxl")

input_data <- function(dataset_folder, panel_xcl, md_xcl) {

  # assign the function commands to variables that will be used throughout
  # the script
  data_dir <- dataset_folder
  path_panel <- panel_xcl
  path_md <- md_xcl
  panel <- read_excel(path_panel)
  md <- read_excel(path_md)

  print("Data directory:")
  print(data_dir)
  print("Panel:")
  print(panel)
  print("Metadata:")
  print(md)

  # Markers of interest (to batch correct on)
  markers <- panel %>%
    dplyr::filter(marker_class != "none") %>%
    pull(antigen) %>%
    str_remove_all("[ _-]")


  check_matching_panel_markers <- function(panel, markers){
    # Function to check if markers in panel match markers
    #and fix them if they don't match
    panel_unmatched <- panel[!pull(panel, antigen) %in% markers,]
    panel_none <- panel[panel$marker_class == "none",]
    if(nrow(panel_unmatched) > nrow(panel_none)){
      # get unmatched markers values
      markers_unmatched <- markers[!markers %in% pull(panel, "antigen")]
      # get unmatched panel values
      panel_unmatched_vector <- pull(
        panel_unmatched[!panel_unmatched$marker_class == "none",], "antigen")
      # print unmatched values
      print("Warning: Markers do not match panel antigens", quote = FALSE)

      # Create a named vector for replacement
      replacement_map <- setNames(markers_unmatched, panel_unmatched_vector)

      # Print replacements
      cat(paste(panel_unmatched_vector,
                " is being replaced with ",
                markers_unmatched, sep = "", collapse = "\n"), "\n")

      # Replace values in 'panel$antigen'
      panel$antigen <- ifelse(panel$antigen %in% panel_unmatched_vector,
                              replacement_map[panel$antigen],
                              panel$antigen)}


  }

  # Check if markers in panel match markers and fix them if they don't match
  panel <- check_matching_panel_markers(panel, markers)

  # returns both the markers and the panel to spot check
  markers_and_panel <- list(markers, panel)
  print("This is the markers and panels to spot check:")
  print(markers_and_panel)

  ## set file path to 'output' folder
  output_folder <- file.path("./output/", "batch_corrected")

  # create new folder
  dir.create(output_folder)

  ## This section is for the uncorrected

  # Compile fcs files and preprocess
  uncorrected <- prepare_data(data_dir = data_dir,
                              markers = markers,
                              metadata = md,
                              sample_ids = "sample_id", # column in metadata
                              batch_ids = "run", # column in metadata
                              filename_col = "file_name", # column in metadata
                              anchor = "anchor", # column in metadata
                              # condition = "condition", # column in metadata
                              down_sample = FALSE,
                              # sample_size = 500000,
                              seed = 1234,
                              cofactor = 5)
  file_name = "./output/batch_corrected/cycombine_raw_uncorrected.RDS"
  saveRDS(uncorrected, file = file_name)

  ## This section is for the corrected

  # Run batch correction using anchors
  corrected <- uncorrected %>%
    batch_correct(markers = markers,
                  # "rank" is recommended when combining data
                  # with heavy batch effects
                  norm_method = "scale",
                  # Consider a larger value,
                  # if results are not convincing (e.g. 100)
                  rlen = 10,
                  # covar = "condition",
                  anchor = "anchor")
  file_name = "./output/batch_corrected/cycombine_raw_corrected.RDS"
  saveRDS(corrected, file = file_name)

}

input_data(dataset_folder =
             "./data/raw_data/test_FCS_files/",
           panel_xcl =
             "./data/panel_md_test/samples_panel_test.xlsx",
           md_xcl = "./data/panel_md_test/samples_md_test.xlsx")

dataset_folder = "./data/raw_data/test_FCS_files/"
panel_xcl = "./data/panel_md_test/samples_panel_test.xlsx"
md_xcl = "./data/panel_md_test/samples_md_test.xlsx"



