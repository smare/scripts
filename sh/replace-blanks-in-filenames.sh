#! /bin/bash
# blank-rename.sh
#
# Substitutes underscores for blanks in all the filenames in a directory.

ONE=1    # For getting singular/plural right (see below).
number=0 # Keeps track of how many files actually renamed.
FOUND=0  # Successful return value.

for filename in *; do                 #Traverse all files in directory.
	echo "$filename" | grep -q " "       #  Check whether filename
	if [ $? -eq $FOUND ]; then           #+ contains space(s).
		fname=$filename                     # Yes, this filename needs work.
		n=$(echo $fname | sed -e "s/ /_/g") # Substitute underscore for blank.
		mv "$fname" "$n"                    # Do the actual renaming.
		let "number += 1"
	fi
done

if [ "$number" -eq "$ONE" ]; then # For correct grammar.
	echo "$number file renamed."
else
	echo "$number files renamed."
fi

exit 0
