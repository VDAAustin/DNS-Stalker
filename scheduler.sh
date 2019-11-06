#!/bin/bash

#Task Scheduler for starting CronTab
printf "\n"
printf "\n"
echo "DNS-Stalker will execute hourly"
printf "\n"
echo "Input the URL you want to Stalk"
read URL
#echo "# m h dom mon dow user  command"
printf "\n"

#echo "52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )"
echo "Scheduling the following task in crontab: "
echo "39 *    * * *   root    (cd "/home/ossec/Downloads/dnstwist-master/" && './dnstwist.py --registered $URL')"
printf "\n"
echo "39 *    * * *   root    (cd "/home/ossec/Downloads/dnstwist-master/" && ./dnstwist.py --registered $URL > outfile.txt)" >> /etc/crontab

echo "45 *    * * *   root    (cd "/home/ossec/Downloads/dnstwist-master/" && ./comparer.sh)" 
echo "45 *    * * *   root    (cd "/home/ossec/Downloads/dnstwist-master/" && ./comparer.sh)" >> /etc/crontab
echo "dnstwist will be scheduled hourly on the 39 minute mark"
echo "comparer (file checker/emailer) will run on 45 minute mark"
 
