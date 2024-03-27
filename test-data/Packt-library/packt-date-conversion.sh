#!/bin/bash

convert_date() {
  input_date="$1"

  # Check if input date is in M/D/YY format (with potentially single-digit month and day)
  if [[ "$input_date" =~ ^[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}$ ]]; then
    # Convert M/D/YY to YYYY-MM-DDT00:00:00.000Z
    # GNU date does not directly support millisecond precision in output, so we append .000Z manually
    formatted_date=$(date -d "$input_date" +"%Y-%m-%dT00:00:00.000Z")
    if [ $? -eq 0 ]; then
      echo "$formatted_date"
    else
      echo "Error: Failed to convert date from M/D/YY to ISO 8601 format."
    fi
  # Check if input date is in ISO 8601 format
  elif [[ "$input_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T00:00:00.000Z$ ]]; then
    # Convert YYYY-MM-DDT00:00:00.000Z to M/D/YY
    # Since the input format includes a time component, strip it off to parse correctly
    input_date=${input_date:0:10} # Extract YYYY-MM-DD part
    formatted_date=$(date -d "$input_date" +"%m/%d/%y")
    if [ $? -eq 0 ]; then
      echo "$formatted_date"
    else
      echo "Error: Failed to convert date from ISO 8601 to M/D/YY format."
    fi
  else
    echo "Error: Unsupported date format."
  fi
}

# Example usage:
# convert_date "3/11/24"
# convert_date "2024-03-11T00:00:00.000Z"

# Uncomment the next line to use the function with the first command line argument
# convert_date "$1"
