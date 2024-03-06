#!/bin/bash

# Default directory for both input and output files
default_dir="/mnt/c/dev/data/onetab"

# Path to the awk script
awk_script="/mnt/c/dev/projects/scripts/awk/generate_webpage_from_onetab_export.awk"


# Function to display help/usage information
show_help() {
    echo 
	echo "Usage: $0 <filename> <output_file>"
    echo "Transforms a Onetab export file into a webpage using awk."
    echo
	echo "NOTE: Assumes awk script path is $awk_script"
	echo
    echo "Options:"
    echo "  -h, --help    Display this help message and exit."
    echo
    echo "Arguments:"
    echo "  filename      The filename of the Onetab export file. Assumes the file is in $default_dir unless a path is specified."
    echo "  output_file   The filename where the transformed webpage will be saved. Assumes the file is in $default_dir unless a path is specified."
}

# Check for help option
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Incorrect number of arguments provided."
    show_help
    exit 1
fi

# Determine if the first argument includes a directory path
if [[ "$1" == */* ]]; then
    input_file="$1"
else
    input_file="$default_dir/$1"
fi

# Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "File $input_file not found."
    exit 1
fi

# Determine if the second argument includes a directory path
if [[ "$2" == */* ]]; then
    output_file="$2"
else
    output_file="$default_dir/$2"
fi

# Extract directory path from the output filename
dir=$(dirname "$output_file")

# Create output directory if it doesn't exist
if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
fi

# Execute the awk script with the provided filename and redirect output to the specified output file
# Redirect standard error to the console
awk -f "$awk_script" "$input_file" > "$output_file" 2>&1

if [ $? -ne 0 ]; then
    echo "An error occurred during the execution of the awk script."
    exit 1
else
    echo "Onetab backup transformed successfully."
fi
