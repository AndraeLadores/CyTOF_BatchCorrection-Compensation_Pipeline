# Function for batch correction part. Created on 2/12/25

# Run necessary packages
library("cyCombine")
library("magrittr")
library("stringr")
library("dplyr")
library("readxl")

batch_correction <- function(raw_dataset_folder, panel_xcl, md_xcl) {

  # assign the function commands to variables that will be used throughout
  # the script
  data_dir <- raw_dataset_folder
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


  # Function to check if markers in panel match markers
  # and fix them if they don't match
  check_matching_panel_markers <- function(panel, markers){

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

    # Return the "panel" if there are any changes so it can be used downstream
    return(panel)

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

  print("Starting the uncorrected section:")

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
  print("Finished uncorrected section.")

  ## This section is for the corrected
  print("Starting batch correction:")
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
  print("Finished batch correction!")

  # This is for memory optimization
  rm(uncorrected, corrected) # Removes huge uncorrected & corrected obj
  gc() # Forces garbage cleanup

  print("Turning the corrected .RDS into an SCE.")
  # Turning corrected RDS into an SCE
  sce <- df2SCE("./output/batch_corrected/cycombine_raw_corrected.RDS",
                markers = markers,
                sample_col = "sample",
                panel = panel,
                panel_channel = "fcs_colname",
                panel_antigen = "antigen",
                panel_type = "marker_class")
  print("Finished.")

  # This is for memory optimization
  rm(markers_and_panel) # Removes unneeded obj from environment
  gc() # Forces garbage cleanup

  print("Now turning SCE back into FCS files:")
  # Turning SCE into an FCS
  sce2FCS(sce,
          split_by = "sample_id",
          assay = "counts",
          randomize = TRUE,
          outdir = "./output/batch_corrected/batch_corrected_fcs_leukocytes")

  print("Finished.")

  # This is a code to make sure the outputted fcs file names
  # are matching with the original fcs file names which is more convenient

  # Read in the correct names
  correct_names <- md$file_name
  # Read in the wrong named files
  wrong_names <- list.files(
    "./output/batch_corrected/batch_corrected_fcs_leukocytes/")
  # excluding annotation.txt file
  exclude_file <- "annotation.txt"
  wrong_names <- setdiff(wrong_names, exclude_file)
  # Safety check to match number of files to number of names
  if (length(correct_names) != length(wrong_names)) {
  stop("Number of files doesn't match the number of new fcs names, or there is
       an error in the output directory. Please Fix.")
}

  # Rename the files
  for (i in seq_along(wrong_names)) {
    wrong_file_names <- file.path(
      "./output/batch_corrected/batch_corrected_fcs_leukocytes/",
                                  wrong_names[i])
    correct_file_names <- file.path(
      "./output/batch_corrected/batch_corrected_fcs_leukocytes/",
                                    correct_names[i])

    file.rename(wrong_file_names,correct_file_names)
  }

  print("Function has finished running. Check output folder!")

}



