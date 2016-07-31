#!/bin/bash

# This script was first developed to download 
# all the free books being offered here:
#     https://blogs.msdn.microsoft.com/mssmallbiz/2016/07/10/free-thats-right-im-giving-away-millions-of-free-microsoft-ebooks-again-including-windows-10-office-365-office-2016-power-bi-azure-windows-8-1-office-2013-sharepoint-2016-sha/
#
# It is slowly being genericized to effectively
# download any files from any list of URLs.
#
# Reads an input file of URLs and downloads the
# document at each.  As the URLs may be redirects,
# we first get the location (curl -sI) from the 
# server, then download the file and rename it
# using the filename from the location header.
#
# The "echoes" are used to track fallout (files
# that are not downloaded for one reason or
# another) through a consistent logging pattern.

filename="$1"
while read -r line
do    
    echo -e "\nBEGIN"
    
    url="$line"
    echo "URL:$url"
    
    location=`curl -sI $url | grep -o -E 'Location:.*$' | cut -c 11-`
    echo "LOCATION:$location"
    
    bookname=$(basename "$location")
    echo "BOOKNAME:$bookname"
    
    curl -Lo $bookname $url
        
    echo -e "END\n"
done < "$filename"
