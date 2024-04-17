#!/bin/bash

# Define file paths
sourceHtml="/mnt/c/dev/data/onetab/onetab-export-1.html"
targetHtml="/mnt/c/dev/data/onetab/onetab-export.html"
tempLinks="/mnt/c/Users/seanm/AppData/Local/Temp/temp_links.txt"
# awkScript="/mnt/c/dev/projects/scripts/awk/extract-links-from-onetab-html.awk"

# Function to display help message
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "This script copies all the links from a source OneTab HTML export"
	echo "to a target OneTab HTML export, then deletes the source file."
    echo ""
    echo "Options:"
    echo "  -h, --help            Show this help message and exit."
    echo "  -s, --source FILE     Specify the source HTML file. Default is 'source.html'."
    echo "  -t, --target FILE     Specify the target HTML file. Default is 'target.html'."
    echo ""
    echo "Example:"
    echo "  $0 --source onetab-export-1.html --target onetab-export.html"
}

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) show_help; exit 0 ;;
        -s|--source) sourceHtml="$2"; shift ;;
        -t|--target) targetHtml="$2"; shift ;;
        *) echo "Unknown option: $1" >&2; show_help; exit 1 ;;
    esac
    shift
done

# Check if source HTML file exists
if [ ! -f "$sourceHtml" ]; then
    echo "Error: Source HTML file '$sourceHtml' not found."
    exit 1
fi

# Check if target HTML file exists
if [ ! -f "$targetHtml" ]; then
    echo "Error: Target HTML file '$targetHtml' not found."
    exit 1
fi

# Extract links from source HTML
awk -F '"' '/<a / {for (i=1; i<=NF; i++) if ($i ~ /href=/) print $(i)"\""$(i+1)"\""$(i+2)"\""$(i+3)"\""$(i+4)}' $sourceHtml > $tempLinks
# awk -F '"' -f "$awkScript" "$sourceHtml" > "$tempLinks"
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract links from '$sourceHtml'."
    exit 1
fi

# Check if temporary file with links is empty
if [ ! -s "$tempLinks" ]; then
    echo "No links found in '$sourceHtml'. Exiting." >&2
    rm $tempLinks
    exit 0
fi

# Insert links into target HTML before the closing body tag
# Backup original target HTML file
cp "$targetHtml" "${targetHtml}.bak"
# Use sed for in-place editing with backup for safety
sed -i "/<\/body>/i $(awk '{print}' ORS='\\n' "$tempLinks")" "$targetHtml"
if [ $? -ne 0 ]; then
    echo "Error: Failed to insert links into '$targetHtml'." >&2
    # Restore the original file in case of error
    mv "${targetHtml}.bak" "$targetHtml"
    exit 1
else
    rm "${targetHtml}.bak" # Remove backup if successful
fi

# Clean up
rm $tempLinks
