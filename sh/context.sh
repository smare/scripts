#!/bin/sh
##########################################################################
# Shellscript:	context - find line, print context
# Author     :	Sean Mare 
# Category   :	Text Utilities
# Date       :	15.07.01
##########################################################################
# Description
#    - Searches textstring, print some lines before and after the text
#
# Changes
##########################################################################

PN=`basename "$0"`			# Program name
VER=`echo '$Revision: 1.2 $' | cut -d' ' -f2`

: ${AWK:=awk}

Lines=3					# No. of context lines

Usage () {
    echo "$PN - find string, print context, $VER
usage: $PN [-n context] pattern [file ...]
    -n: number of lines to print before and after match (default $Lines)" >&2
    exit 1
}

# Check arguments
set -- `getopt hn: "$@"`
while [ $# -gt 0 ]
do
    case "$1" in
	-n)	Lines="$2"; shift;;
	--)	shift; break;;
	-h)	Usage;;
	-*)	Usage;;
	*)	break;;			# First file name
    esac
    shift
done

: ${Lines:=3}

[ $# -lt 1 ] && Usage

Pattern="$1"; shift
$AWK '
    # Lines *before* pattern found are stored into a circular
    # buffer, Lines *after* pattern are printed immediately.
    BEGIN {
	k   = '$Lines'		# Lines to print before/after pattern
	n   = k			# Size of circular buffer
	pos = 0			# Next position in circular buffer
	cnt = 0			# No. of lines left to print
	FirstTime = 1
	# HEADER is printed for each new file
	# DELIMITER before each context
	HEADER  = "\n>>>>>>>>(New file: %s)<<<<<<<<\n"
	DELIMITER = ">>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<"
    }

    /'$Pattern'/	{	# Pattern found!
	# If already printing a context, just initialize line
	# counter, effectively merging two contexts
	if ( cnt != 0 ) {
	    cnt = k+1
	} else {		# New context
	    if ( n > 0 ) {
		if ( LastName != FILENAME ) {
		    LastName = FILENAME
		    printf (HEADER, FILENAME)
		}
		else print DELIMITER

		# Print last lines from circular buffer before match
		for ( i = 0; i < n; i++ )
		    print B [(pos+i)%n]
	    }
	    # Print k lines (+ current line) after this match
	    cnt = k+1
	}
    }
    {				# Normal line processing
	if ( n > 0 ) {
	    # Store current line in circular buffer
	    B [pos] = $0
	    pos = (pos + 1) % n
	}
	# Lines left to print after a match?
	if ( cnt ) {
	    print
	    cnt--
	}
    }
' "$@"