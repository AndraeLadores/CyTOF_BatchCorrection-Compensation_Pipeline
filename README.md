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
- **It's important to note that these FCS files are already pre-processed, meaning they have gone through normalization and bead removal.**

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


## Instruction for UCSF's Wynton HPC Cluster

1. First thing is to request access and create an account with Wynton.
- Once you have created an account, you can now start using Wynton.

2. Assuming you already have already downloaded the entire github package.
- (Locally): Upload and replace your own designated files to the folder package if needed (ex: raw data files, panel, metadata, etc.).

3. Once you have uploaded your files, then you will need to upload the package into Wynton.



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

### 2/26/25
- Tested with a bigger dataset and vector limit error keeps happening so I'm adding memory optimization codes to help prevent that error in bigger datasets.

### 3/31/25
- Working on integrating pipeline to UCSF Wynton servers with dedicated memory to run huge datasets.
- Quick steps:
1. Log in to servers using bash (cluster first and then development node)
2. Open R studio GUI to make sure it works (will need two terminals and use temp pw provided to open on your local browser)

After making sure R studio runs. We will need to download our project folder so we can use it on Wynton.

3. On your local bash terminal, use this template to download the project folder into your Wynton directory (this is assuming that you have this git repository downloaded on your local computer, which I highly recommend)

### 4/7/25
- Fix some issues with the batch correction code - related to optimization lines I implemented but deleted since we will be running these via server.

### 4/30/25
- Started working on code that caters towards Shell. This is so it will be easier to run the codes on Wynton. This also makes it even more streamlined and easier for users who aren't too experienced in coding.
- Since I organized the files and folders more, there is an issue with the batch correction shell script. It has something to do with the directories. Will work on this to fix asap and then create the respective interactive shell script for the compensation part.

### 5/5/25
- Fix shell script error with directories. Shell script for batch correction works great now. I plan on making another shell script for compensation.
- I will also look into how to make it even more user-friendly since manually putting file paths for each condition can be demanding and it's frustrating to restart due to a small problem or mistake.
- I will most likely look into a way that actually shows the directory and you are able to just choose a specific number for the corresponding file you are looking into. I will also add "if" and "exit" statements for the user to make sure they don't proceed with the wrong file or make an error.

### 5/12/25
- Created shell script for compensation part and also made changes to compensation R codes to accomodate for the compensation shell script.
- I will look into a more user friendly interface but I also need to test it out on Wynton and request a job.
- I will also change the shell script so it's a little bit easier to read and keep up with what it's outputting.

### 5/13/25 - 5/15/25
- Started working on the code so you can easily select the file paths in the directories. There's an error with the specific code and you aren't able to see the actual folders but instead it shows the line of code
- I think I will need to expand the folders and see if I can set it as a variable and then look into the directory.

### 5/19 - 5/20
- Finally was able to fix the `select` code issue with the folder directories. I should be able to apply these with the rest of the codes for both batch correction and compensation.

### 5/21 - 5/22
- Fully changed the shell script to accomodate the `select` code which displays the file/folder paths and automatically accounts for the path when chosen.
- I ran into some issues when trying to integrate this, mostly with pathing issues for R code but I fixed to by getting the absolute path of the directory regardless of where the relative directory is located.
- I will be running this in Wynton with a big dataset.
