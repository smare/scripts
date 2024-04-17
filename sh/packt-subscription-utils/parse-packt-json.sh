#!/bin/bash

# Path to the JSON file
JSON_FILE="/mnt/c/dev/projects/scripts/test-data/packt-library/packt-owned-books-long.json"

# Output the header
echo "title,ebook_isbn,publicationDate,codeRepoUrl,coverImage,smallImage,ebook_price_us"

# Use jq to parse and extract the required fields
jq -r '.data[] | {
    title: .title,
    ebook_isbn: (.isbns.ebook // ""),
    publicationDate: .publicationDate,
    codeRepoUrl: .codeRepoUrl,
    coverImage: .coverImage,
    smallImage: .smallImage,
    ebook_price_us: (if .prices | type == "object" then .prices.us.ebook.price else "" end // "")
} | [
    .title,
    .ebook_isbn,
    .publicationDate,
    .codeRepoUrl,
    .coverImage,
    .smallImage,
    (.ebook_price_us | tostring)
] | @csv' $JSON_FILE
