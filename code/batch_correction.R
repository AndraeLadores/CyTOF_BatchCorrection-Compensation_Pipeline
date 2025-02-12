# Function for batch correction part. Created on 2/12/25

# Run necessary packages
library("cyCombine")
library("magrittr")
library("stringr")
library("dplyr")
library("readxl")

input_data <- function(dataset_folder, panel_xcl, md_xcl) {

  data_dir <- dataset_folder
  path_panel <- panel_xcl
  path_md <- md_xcl
  panel <- read_excel(path_panel)
  md<- read_excel(path_md)

  # Markers of interest (to batch correct on)
  markers <- panel %>%
    dplyr::filter(marker_class != "none") %>%
    pull(antigen) %>%
    str_remove_all("[ _-]")


  check_matching_panel_markers <- function(panel, markers){
    # Function to check if markers in panel match markers and fix them if they don't match
    panel_unmatched <- panel[!pull(panel, antigen) %in% markers,]
    panel_none <- panel[panel$marker_class == "none",]
    if(nrow(panel_unmatched) > nrow(panel_none)){
      # get unmatched markers values
      markers_unmatched <- markers[!markers %in% pull(panel, "antigen")]
      # get unmatched panel values
      panel_unmatched_vector <- pull(panel_unmatched[!panel_unmatched$marker_class == "none",], "antigen")
      # print unmatched values
      print("Warning: Markers do not match panel antigens", quote = FALSE)

      # Create a named vector for replacement
      replacement_map <- setNames(markers_unmatched, panel_unmatched_vector)

      # Print replacements
      cat(paste(panel_unmatched_vector, " is being replaced with ", markers_unmatched, sep = "", collapse = "\n"), "\n")

      # Replace values in 'panel$antigen'
      panel$antigen <- ifelse(panel$antigen %in% panel_unmatched_vector,
                              replacement_map[panel$antigen],
                              panel$antigen)}


  }

  # Check if markers in panel match markers and fix them if they don't match
  panel <- check_matching_panel_markers(panel, markers)

  markers_and_panel <- list(markers, panel)
  return(markers_and_panel)

}

input_data(dataset_folder =
             "./data/raw_data/test_FCS_files/",
           panel_xcl =
             "./data/panel_md_test/samples_panel_test.xlsx",
           md_xcl = "./data/panel_md_test/samples_md_test.xlsx")





