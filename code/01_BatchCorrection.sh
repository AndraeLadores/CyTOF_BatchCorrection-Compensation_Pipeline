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
echo "[1] Please select a folder for the raw dataset:"
select dir in ./data/raw_data/*; do
	if [ -d "$dir" ]; then
		raw_dataset_folder = "$dir"
		break
	else
		echo "Error in selection. Please look carefully and try again."
	fi
done

echo "You selected: $raw_dataset_folder"
echo "------------------------------------------------------------------"

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

Rscript ./r_codes/01_batchcorrection_script.R "$raw_dataset_folder" "$panel_xcl" "$md_xcl"


