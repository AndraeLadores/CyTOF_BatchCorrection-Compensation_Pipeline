#!/bin/bash

# This is a shell script to further streamline the CyTOF batch correction and compensation sections
# Created by Andrae "Dodge" Ladores

# Welcome message to users
echo "This is The Batch Correction Part of the script!"
echo "If you wanted to Compensate, please use the other shell script."
echo "------------------------------------------------------------------"

# This sets the parent directory of where the shell script is located (main project folder)
cd "$(dirname "$0")"

##################################DATASET_FOLDER###########################################

# Input file path for raw dataset folder
echo "[1] Please select a folder corresponding to the number for the raw dataset:"

# Make folder/directories into an array
folders=(../data/raw_data/*)

# Display folder options for dataset via select
select dir in "${folders[@]}"; do
	if [ -d "$dir" ]; then
		raw_dataset_folder="$dir"
		break
	else
		echo "Error in selection. Please look carefully and try again."
	fi
done

echo "You selected: $raw_dataset_folder"

# Convert absolute path of folder to avoid any issues
raw_dataset_folder=$(cd "$raw_dataset_folder"; pwd)

echo "------------------------------------------------------------------"

##################################PANEL_FILE################################################

# Input file path for panel file
echo "[2] Please input the file path for the panel excel file:"

# Make directories into an array
folders=(../data/panel_md_template/*)

# Display panel file options via select
select dir in "${folders[@]}"; do
	if [ -f "$dir" ]; then
		panel_xcl="$dir"
		break
	else
		echo "Error in selection. Please look carefully and try again."
	fi
done

echo "You selected: $panel_xcl"

# Convert absolute path of file to avoid any issues
panel_xcl=$(cd "$(dirname "$panel_xcl")"; pwd)/$(basename "$panel_xcl")

echo "------------------------------------------------------------------"

##################################MD_FILE###################################################

# Input the file path for the metadata(md)
echo "[3] Please input the file path for the metadata(md) excel file:"

# Make directories into an array
folders=(../data/panel_md_template/*)

# Display md file options via select
select dir in "${folders[@]}"; do
	if [ -f "$dir" ]; then
		md_xcl="$dir"
		break
	else
		echo "Error in selection. Please look carefully and try again."
	fi
done

echo "You selected: $md_xcl"

# Convert to absolute path of file to avoid any issues
md_xcl=$(cd "$(dirname "$md_xcl")"; pwd)/$(basename "$md_xcl")

echo "------------------------------------------------------------------"

##################################OVERVIEW##################################################

# File paths overview
echo "Batch Correction will start with the following inputted files:"
echo "Raw data folder: $raw_dataset_folder"
echo "Panel sheet: $panel_xcl"
echo "Metadata file: $md_xcl"

Rscript ./r_codes/01_batchcorrection_script.R "$raw_dataset_folder" "$panel_xcl" "$md_xcl"


