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

compensate_bcorrected <- function(b_corrected_fcsfiles,
                                  panel_xcl,
                                  md_xcl,
                                  spillover_file) {

  ## Read in md/panel files and batch corrected FCS files
  # read in desired FCS files
  path_fcs <- b_corrected_fcsfiles
  dataset <- read.flowSet(path=path_fcs, pattern="fcs$")
  # read in metadata
  path_md <- md_xcl
  md <- read_excel(path_md)
  # read in panel
  path_panel <- panel_xcl
  panel <- read_excel(path_panel)
  # spot check panel
  head(data.frame(panel))

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

  # construct SingleCellExperiment
  # Make sure FCS files match md "file_name", fix upstream
  sce <- prepData(dataset, panel, md, features = panel$fcs_colname,
                  md_cols = md_cols)

  ## Compensation section

  # read in spillover matrix
  spillover <- data.frame(read_excel(spillover_file))
  # set rownames to metal channels
  rownames(spillover) <- spillover$...1
  # remove extra column
  spillover <- spillover[,-1]
  # convert percentages to decimals
  spillover <- spillover/100
  # set any NA values to 0
  spillover[is.na(spillover)] <- 0

  # compensate
  # Notice this is "overwrite = TRUE" so it will overwrite and replace old files
  sce <- compCytof(sce, spillover, method = "nnls", overwrite = TRUE)

  # From SCE to FCS files for Cell Engine
  fs <- sce2fcs(sce, split_by = "sample_id", assay = "counts")
  all(c(fsApply(fs, nrow)) == table(sce$sample_id))
  ids <- fsApply(fs, identifier)
  # write out each FCS file to the path specified
  dir.create(file.path("./CATALYST/comp_fcs"))
  for (id in ids) {
    ff <- fs[[id]]                     # subset 'flowFrame'
    fn <- sprintf("comp_%s.fcs", id) # specify output name that includes ID
    fn <- file.path("./CATALYST/comp_fcs", fn)         # construct output path
    write.FCS(ff, fn)                  # write frame to FCS
  }

}




