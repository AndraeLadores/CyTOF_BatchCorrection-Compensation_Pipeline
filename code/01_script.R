# Script created on 02/11/2025

# Load all necessary packages
library("cyCombine")
library("magrittr")
library("stringr")
library("dplyr")
library("readxl")

# create new folder for bath_corrected items

## set file path to 'output folder
output_folder <- file.path("./output/", "batch_corrected")

# create new folder
dir.create(output_folder)



