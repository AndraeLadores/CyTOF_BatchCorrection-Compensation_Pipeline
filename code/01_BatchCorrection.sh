#!/bin/bash

# This is a shell script to further streamline the CyTOF batch correction and compensation sections
# Created by Andrae "Dodge" Ladores

# Welcome message to users
echo "This is The Batch Correction Part of the script!"
echo "If you wanted to Compensate, please use the other shell script."
echo "------------------------------------------------------------------"

# This sets the parent directory of where the shell script is located (main project folder)
cd "$(dirname "$0")"

# Input file path for raw dataset folder
echo "[1] Please input the file path for the raw dataset (this is usually placed in the raw dataset folder under data):"
read raw_dataset_folder

# Input file path for panel file
echo "[2] Please input the file path for the panel excel file:"
read panel_xcl

# Input the file path for the metadata(md)
echo "[3] Please input the file path for the metadata(md) excel file:"
read md_xcl

# File paths overview
echo "Batch Correction will start with the following inputted files:"
echo "Raw data folder: $raw_dataset_folder"
echo "Panel sheet: $panel_xcl"
echo "Metadata file: $md_xcl"

Rscript ./TESTCOPY01_batchcorrection_script.R "$raw_dataset_folder" "$panel_xcl" "$md_xcl"


