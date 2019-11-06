#!/bin/bash

file1="/home/ossec/Downloads/dnstwist-master/master.txt"
file2="/home/ossec/Downloads/dnstwist-master/outfile.txt"

if cmp -s "$file1" "$file2"; then
	printf 'The file "%s" is the same as "%s"\n' "$file1" "$file2"
else
	printf 'The file "%s" is different than "%s" and requires admin to inspect DNS-Stalkers records\n' "$file1" "$file2"

mail -s 'Domain Registry Alert' -t 'mattwilds.bigc@gmail.com' -a From:Admin\<mattwilds.bigc@gmail.com\> <<< ' 
This is an automated alert to let you know a possibly malicious was registered. Please log into the linux box and inspect /home/ossec/Downloads/dnstwist-master/outfile.txt.'


fi

