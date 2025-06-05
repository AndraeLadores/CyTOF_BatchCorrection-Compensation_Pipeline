#!/bin/bash

# This is a shell script to further streamline the CyTOF compensation section
# Created by Andrae "Dodge" Ladores

# Welcome message to users
echo "This is The COMPENSATION part of the script!"
echo "If you wanted to Batch Correct, please use the other shell script."
echo "------------------------------------------------------------------"

# This sets the parent directory of where the shell script is located (main project folder)
cd "$(dirname "$0")"

##################################DATASET_FOLDER############################################

# Input file path for raw dataset folder
echo "[1] Please input the file path for the raw dataset (most likely in the dataset folder):"

# Make folder/directories into an array
folders=(../data/raw_data/*)

# Display folder options for dataset via select
select dir in "${folders[@]}"; do
	if [ -d "$dir" ]; then
		dataset_folder="$dir"
		break
	else
		echo "Error in selection. Please look carefully and try again."
	fi
done

echo "You selected: $dataset_folder"

# Convert absolute path of folder to avoid any issues
dataset_folder=$(cd "$dataset_folder"; pwd)

echo "------------------------------------------------------------------"

##################################PANEL_FILE#################################################

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


##################################MD_FILE####################################################

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

##################################SPILLOVER###################################################

# Input spillover matrix file
echo "[4] Please input the file path for the spillover matrix file:"

# Make directories into an array
folders=(../data/spillover/*)

# Display spillover matrix file options via select
select dir in "${folders[@]}"; do
	if [ -f "$dir" ]; then
		spillover_matrix="$dir"
		break
	else
		echo "Error in selection. Please look carefully and try again."
	fi
done

echo "You selected: $spillover_matrix"

# Convert to absolute path of file to avoid any issues
spillover_matrix=$(cd "$(dirname "$spillover_matrix")"; pwd)/$(basename "$spillover_matrix")

echo "------------------------------------------------------------------"

##################################OVERVIEW####################################################

# File paths overview
echo "Compensation will start with these following files:"
echo "FCS data file(s): $dataset_folder"
echo "Panel sheet: $panel_xcl"
echo "Metadata file: $md_xcl"
echo "Spillover matrix: $spillover_matrix"  
 
Rscript ./r_codes/02_compensation_script.R "$dataset_folder" "$panel_xcl" "$md_xcl" "$spillover_matrix"   