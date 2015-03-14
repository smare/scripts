#!/bin/sh

PN=`basename "$0"`			# Program name
VER=`echo '$Revision: 1.1 $' | cut -d' ' -f2`

Usage () {
    echo >&2 "$PN - encode HTML unsave characters, $VER
usage: $PN [file ...]"
    exit 1
}

set -- `getopt h "$@"`
while [ $# -gt 0 ]
do
    case "$1" in
	--)	shift; break;;
	-h)	Usage;;
	-*)	Usage;;
	*)	break;;			# First file name
    esac
    shift
done

sed 									\
	-e 's/&/\&amp;/g'						\
	-e 's/"/\&quot;/g'						\
	-e 's/</\&lt;/g'						\
	-e 's/>/\&gt;/g'						\
	-e 's/�/\&auml;/g'						\
	-e 's/�/\&Auml;/g'						\
	-e 's/�/\&ouml;/g'						\
	-e 's/�/\&Ouml;/g'						\
	-e 's/�/\&uuml;/g'						\
	-e 's/�/\&Uuml;/g'						\
	-e 's/�/\&szlig;/g'						\
	"$@"