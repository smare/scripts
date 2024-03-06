BEGIN { FS="\"" }
/<a / {
	count=1
    for (i=1; i<=NF; i++) {
        if ($i ~ /href=/) {
			if (count == 1) {
			#	printf "%s", "    \n"
			}
			# print $(i)"\""$(i+1)"\""$(i+2)"\""$(i+3)"\""$(i+4)
			count++	
        }
    }
}