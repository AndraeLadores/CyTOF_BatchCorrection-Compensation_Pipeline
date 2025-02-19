## This is an R script to easily streamline the batch correction and compensation part of CyTOF analysis 

By Andrae "Dodge" Ladores from UCSF's Spitzer Lab, created on 02/11/2025. 

This was originally pulled from: https://github.com/sguldberg/pipelines/tree/main on 1/2/2025.
But it is altered to cater towards solely the batch correction & compensation parts.

---

## Instructions

1. Download the entire git package provided here.

2. Open the R project. This is important for working directory purposes.
- There should be, by default, a *code*, *data*, and *output* folder.
- The *code* folder has the **necessary** scripts and functions.

3. Drag and drop the necessary files you need to the correct folders, these are the **panel**, **md**, **raw FCS files**, and **spillover matrix** if you are compensating.
- By default and as an example, there are template files provided.
- **It's important to note that these FCS files are alrady pre-processed, meaning they have gone through normalization and bead removal.**

4. Install all necessary packages or make sure they are installed:
``` 
install.packages('devtools')
install.packages('XML')
install.packages('stringr')
install.packages('tidyverse')
install.packages('cowplot')
install.packages('viridis')
install.packages('RColorBrewer')
install.packages('dplyr')
install.packages('xlsx')
install.packages('devtools')
install.packages('remotes')

BiocManager::install("flowCore")
BiocManager::install("CATALYST")
BiocManager::install("diffcyt")

library(devtools)
install_github("ParkerICI/premessa")
install_github("nolanlab/cytofCore")

# cyCombine is only necessary for batch effect correction
setRepositories(ind = c(1:6, 8))
devtools::install_github("biosurf/cyCombine") 
``` 

5. In **R**, open either *01_batchcorrection_script.R* or *02_compensation_script.R*, this depends on what you want to run.

6. Make sure that the function you are using, for either batch correction or compensation, have the correct directories.

7. After making sure, you can simply run the function and the expected output files should be produced in the *output* folder.

---

## Log

### This section was logged in R markdown

### 1/2/25
- Deleted entire "pre-process" code since our data is already "pre-processed"
- Installing packages takes a very long time, ideally have this all installed overnight if not installed already.

- Had matrix issues with converting files into an SCE and then back into FCS files.
- Solution: our panel had spaces which caused the function to not recognize some antigens which caused missing objects down the line

### 1/16/25 
- Put in a function that checks for spaces in our panel when running the rmd.

- There's also an issue with installing CyCombine on your device, fortunately, this computer already has CyCombine.

### 1/23/25
- Can be a problem with compensate part when creating another SCE; check literal file names in folder

### 1/28/25
- Pay attention to the panel and whether or not "CD235CD61" needs to be a "type" or "none"
- This depends on wether or not it was gated in or out.

- Added a code (chunk 224) that fixes the file names (problem on 1/23/25) so it's more streamlined during the compensating part. 

### 1/29/25
- There's an error: vector memory exhausted (limit reached?) that occurs when making an SCE and/or converting SCE into an FCS.
- This was solved by "overwrite = TRUE" in the compCytof line (chunk 404)
- Not sure if this drastically changes our dataset or not but we will see once we look at it.

### This section was logged in normal R scripts

### 2/12/25
- Started on batch_correction function and fixed some formatting issues while trying to improve the code.

### 2/13/25
- Added the batch correction code in the function and some spot check codes.

### 2/14/25
- Fix the batch correction code section and implemented some more safety code just in case there is something that is missing or wrong down the code.

### 2/18/25
- Finished formatting the batch correction part and created function for compensation section. Tested and working on small files, but will test on a bigger dataset.

### 2/19/25
- Fixed a huge issue when running the compensation script. It basically wouldn't call the function I created, but it's fixed. It's good to remember to make sure you're calling the correct file.
