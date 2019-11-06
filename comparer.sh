#!/bin/bash

EMAIL = "placeholder"
DOMAIN = "things"


file1="/opt/DNS-Stalker/master.txt"
file2="/opt/DNS-Stalker/outfile.txt"

if cmp -s "$file1" "$file2"; then
	printf 'The file "%s" is the same as "%s"\n' "$file1" "$file2"
else
	printf 'The file "%s" is different than "%s" and requires admin to inspect DNS-Stalkers records\n' "$file1" "$file2"

mail -s 'Domain Registry Alert' -t "$EMAIL" -a "From:Admin\<$DOMAIN\>" <<< ' 
This is an automated alert to let you know a possibly malicious was registered. 
The automated scan has encountered a new domain.
Please log into the linux box and inspect /opt/DNS-Stalker/outfile.txt.'

fi

