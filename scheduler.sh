#!/bin/bash

#Task Scheduler for starting CronTab
printf "\n"
printf "\n"
echo "DNS-Stalker will execute hourly"
printf "\n"
echo "Input the URL you want to Stalk"
read URL

printf "\n"

echo "Scheduling the following task in crontab: "
echo "39 *    * * *   root    (cd "/home/ossec/Downloads/DNS-Stalker/" && './dnstwist.py --registered $URL')"
printf "\n"
echo "39 *    * * *   root    (cd "/home/ossec/Downloads/DNS-Stalker/" && ./dnstwist.py --registered $URL > outfile.txt)" >> /etc/crontab

echo "45 *    * * *   root    (cd "/home/ossec/Downloads/DNS-Stalker/" && ./comparer.sh)" 
echo "45 *    * * *   root    (cd "/home/ossec/Downloads/DNS-Stalker/" && ./comparer.sh)" >> /etc/crontab
echo "dnstwist will be scheduled hourly on the 39 minute mark"
echo "comparer (file checker/emailer) will run on 45 minute mark"
 
