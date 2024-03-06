#!/bin/bash

# Check if the correct number of arguments are passed
if [ $# -ne 2 ]; then
    echo "Usage: $0 <config_file> <html_file>"
    exit 1
fi

echo
echo -e "******** Beginning meta tag processing ********"

CONFIG_FILE="$1"
HTML_FILE="$2"
TEMP_HTML=$(mktemp)

# Convert files to Unix format, simulating dos2unix
sed -i 's/\r$//' "$CONFIG_FILE"
sed -i 's/\r$//' "$HTML_FILE"

# Backup the original HTML content
cp "$HTML_FILE" "$TEMP_HTML"

# Function to process and update meta elements in the HTML file
process_meta_elements() {
    local line key value attributeType comments=""
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ ^# ]]; then
            comments+="$line\n"
            continue
        fi

        IFS='|' read -r keyValue attributeType <<< "$line"
        IFS='=' read -r key value <<< "$keyValue"
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        local existing_meta=$(grep -oP "<meta $attributeType=\"$key\" content=\"[^\"]*\"" "$HTML_FILE")
        local new_meta="<meta $attributeType=\"$key\" content=\"$value\" />"

        # Check if exact meta tag already exists
        if [[ "$existing_meta" == *"$value"* ]]; then
			comments=""
            continue
        fi

        # Remove existing tags for 'name' and 'property', but not for 'http-equiv'
        if [[ "$attributeType" != "http-equiv" ]]; then
            sed -i "/<meta $attributeType=\"$key\"/d" "$TEMP_HTML"
        fi

        # Insert or update the meta tag in the correct position
        sed -i "/<\/head>/i $new_meta" "$TEMP_HTML"
		echo
		echo "Added or replaced meta element: $new_meta"
        # Print comments if any, then clear
        if [ -n "$comments" ]; then
            echo -e "Comments:\n$(echo -e "$comments" | sed 's/^#/\t/g')"
            comments=""
        fi

        
    done < "$CONFIG_FILE"
}

# Call the function to process meta elements
process_meta_elements

# Move the updated content back to the original HTML file
mv "$TEMP_HTML" "$HTML_FILE"
sed -i 's/\r$//' "$HTML_FILE"
echo
echo -e "******** Finished meta tag processing ********"
