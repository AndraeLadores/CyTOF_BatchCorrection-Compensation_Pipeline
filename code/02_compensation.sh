#!/bin/bash

# This is a shell script to further streamline the CyTOF compensation section
# Created by Andrae "Dodge" Ladores

# Welcome message to users
echo "This is The COMPENSATION part of the script!"
echo "If you wanted to Batch Correct, please use the other shell script."
echo "------------------------------------------------------------------"

# This sets the parent directory of where the shell script is located (main project folder)
cd "$(dirname "$0")"

# Input file path for raw dataset folder
echo "[1] Please input the file path for the raw dataset (most likely in the dataset folder):"
read dataset_folder

# Input file path for panel file
echo "[2] Please input the file path for the panel excel file:"
read panel_xcl

# Input the file path for the metadata(md)
echo "[3] Please input the file path for the metadata(md) excel file:"
read md_xcl

# Input spillover matrix file
echo "[4] Please input the file path for the spillover matrix file:"
read spillover_matrix

# File paths overview
echo "Compensation will start with these following files:"
echo "FCS data file(s): $dataset_folder"
echo "Panel sheet: $panel_xcl"
echo "Metadata file: $md_xcl"
echo "Spillover matrix: $spillover_matrix"  
 
Rscript ./r_codes/02_compensation_script.R "$dataset_folder" "$panel_xcl" "$md_xcl" "$spillover_matrix"   