#!/bin/sh
# Recursive grep
find $1 -type f -print | xargs grep -n "$2"