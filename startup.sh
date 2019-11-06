#!/bin/bash

printf "Have to install a few things \n"
apt install -y mailutils

#Task Scheduler for starting CronTab
printf "\n"
printf "\n"
printf "DNS-Stalker will execute hourly \n"
printf "\n"
printf "Input the URL you want to Stalk \n"
read URL

printf "\n"

printf "Scheduling the following task in crontab: \n"
echo "39 *    * * *   root    (cd "/opt/DNS-Stalker/" && './dnstwist.py --registered $URL')"
printf "\n"
echo "39 *    * * *   root    (cd "/opt/DNS-Stalker/" && ./dnstwist.py --registered $URL > outfile.txt)" >> /etc/crontab

echo "49 *    * * *   root    (cd "/opt/DNS-Stalker/" && ./comparer.sh)" 
echo "49 *    * * *   root    (cd "/opt/DNS-Stalker/" && ./comparer.sh)" >> /etc/crontab
printf "dnstwist will be scheduled hourly on the 39 minute mark \n"
printf "comparer (file checker/emailer) will run on 49 minute mark \n"

printf "Please enter the email you want to send to: \n"
read EMAIL

printf "sending your email to comparer.sh \n"
sed -i "s/placeholder/$EMAIL/g" /opt/DNS-Stalker/comparer.sh

sleep 1
printf "Please enter the account and domain to send from: \n" 
printf "Example, admin@gmail.com \n"
read DOMAIN

printf "Sending your input to comparer.sh \n"
sed -i "s~things~$DOMAIN~g" /opt/DNS-Stalker/comparer.sh

printf "Time to create the master file for comparison \n"
printf "Please wait, this may take a few minutes \n"
python dnstwist.py --registered $URL > /opt/DNS-Stalker/master.txt

printf "All Done! Thanks, Support VDA Labs! https://vdalabs.com \n"

