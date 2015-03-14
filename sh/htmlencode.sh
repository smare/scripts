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
	-e 's/Ñ/\&auml;/g'						\
	-e 's/é/\&Auml;/g'						\
	-e 's/î/\&ouml;/g'						\
	-e 's/ô/\&Ouml;/g'						\
	-e 's/Å/\&uuml;/g'						\
	-e 's/ö/\&Uuml;/g'						\
	-e 's/·/\&szlig;/g'						\
	"$@"