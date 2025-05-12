# This was created on 2/18/25
# This is the compensation code section.

# Load necessary packages
library(CATALYST)
library(flowCore)
library(ggplot2)
library(readxl)
library(RColorBrewer)
library(cowplot)
library(viridis)
library(diffcyt)
library(dplyr)

compensate <- function(FCS_files,
                       panel_xcl,
                       md_xcl,
                       spillover_file) {

  ## Read in md/panel files and batch corrected FCS files
  # read in desired FCS files
  print("Reading in all desired files")

  path_fcs <- FCS_files
  files <- list.files(path_fcs, pattern = "fcs$", full.names = TRUE)
  dataset <- read.flowSet(files,
                          transformation = FALSE,
                          truncate_max_range = FALSE)
  # read in metadata
  path_md <- md_xcl
  md <- read_excel(path_md)
  # read in panel
  #read in panel information
  if(exists("panel_xcl") == TRUE) {
    panel <- read_excel(panel_xcl) %>%
      dplyr::filter(marker_class != "none")
  } else {
    stop("Panel path not provided")
  }
  head(data.frame(panel))
  #spot check that panel matches flowset
  all(panel$fcs_colname %in% colnames(dataset))
  print("If 'False', please check if you're using the correct FCS files")

  print("Finished reading in files")

  ## Creating SCE object
  # specify levels for conditions & sample IDs to assure desired ordering
  md$anchor <- factor(md$anchor) #levels=c("iso","PD1"))
  md$sample_id <- factor(md$sample_id) #levels = md$sample_id[order(md$anchor)])
  #specify columns in metadata (file_name and sample_id are the necessary ones)
  md_cols = list(file = "file_name",
                 id = "sample_id",
                 factors = c("anchor", "run"))

  ## set file path to 'output' folder
  output_folder <- file.path("./output/", "compensation")

  # create new folder
  dir.create(output_folder)

  print("Creating SCE object from inputted FCS files")
  # construct SingleCellExperiment
  # Make sure FCS files match md "file_name", fix upstream
  sce <- prepData(dataset, panel, md, features = panel$fcs_colname,
                  md_cols = md_cols)

  print("Finished creating SCE object")

  ## Compensation section

  # read in spillover matrix
  print("Reading in spillover matrix")
  spillover <- data.frame(read_excel(spillover_file))
  # set rownames to metal channels
  rownames(spillover) <- spillover$...1
  # remove extra column
  spillover <- spillover[,-1]
  # convert percentages to decimals
  spillover <- spillover/100
  # set any NA values to 0
  spillover[is.na(spillover)] <- 0

  print("Starting compensation")
  # compensate
  # Notice this is "overwrite = TRUE" so it will overwrite and replace old files
  sce <- compCytof(sce, spillover, method = "nnls", overwrite = TRUE)

  print("Compensation finished")

  print("Converting SCE to FCS files for Cell Engine")
  # From SCE to FCS files for Cell Engine
  fs <- sce2fcs(sce, split_by = "sample_id", assay = "counts")
  all(c(fsApply(fs, nrow)) == table(sce$sample_id))
  ids <- fsApply(fs, identifier)
  # write out each FCS file to the path specified
  dir.create(file.path("./output/compensation/comp_fcs"))
  for (id in ids) {
    ff <- fs[[id]]                     # subset 'flowFrame'
    fn <- sprintf("comp_%s.fcs", id) # specify output name that includes ID
    # construct output path
    fn <- file.path("./output/compensation/comp_fcs", fn)
    write.FCS(ff, fn)                  # write frame to FCS
  }

  print("Function has finished running. Check for the expected output files")
}



