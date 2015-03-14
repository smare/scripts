#!/bin/ksh

who |
    awk '
	{ User [$1]++; }
	END { for (i in User) printf "%-9s	%s\n", i, User [i] }
    '