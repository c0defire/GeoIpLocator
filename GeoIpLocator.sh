#!/bin/bash

# ----------------------- DESCRIPTIVE INFORMATION ---------------------------------
#
# This script analyses your auth.log for failed attempts that hackers try to log
# into your SSH Server. This script needs sudo to run for reading your log files.
#
# ----------------------- DESCRIPTIVE INFORMATION ---------------------------------
#
# -------------------------- DECLARED VARIABLES -----------------------------------
#
# Gets the IP's from your auth.log file, change log file as necessary, user info
USER=pi
LOG=/var/log/auth.log
IPS_OUTPUT=/home/$USER/GeoIpLocator/geoIP.txt
IPS_SORTED=/home/$USER/GeoIpLocator/sortedips.txt
IPS_COUNTRY=/home/$USER/GeoIpLocator/country.txt
IPS_INFO=/home/$USER/GeoIpLocator/IP_information.txt
#
# -------------------------- DECLARED VARIABLES -----------------------------------
#
#

#
# -------------------------------- FUNCTIONS --------------------------------------
#

# Function Banner - Alias art
function banner()
{

cat << "EOF"

 ██████╗ ███████╗ ██████╗ ██╗██████╗ ██╗      ██████╗  ██████╗ █████╗ ████████╗ ██████╗ ██████╗
██╔════╝ ██╔════╝██╔═══██╗██║██╔══██╗██║     ██╔═══██╗██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
██║  ███╗█████╗  ██║   ██║██║██████╔╝██║     ██║   ██║██║     ███████║   ██║   ██║   ██║██████╔╝
██║   ██║██╔══╝  ██║   ██║██║██╔═══╝ ██║     ██║   ██║██║     ██╔══██║   ██║   ██║   ██║██╔══██╗
╚██████╔╝███████╗╚██████╔╝██║██║     ███████╗╚██████╔╝╚██████╗██║  ██║   ██║   ╚██████╔╝██║  ██║
 ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝╚═╝     ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝

GeoIPLocator v1.0.0
Author: C0defire

EOF

}


# Function Main - Contains your main instructions
function main()
{

echo "Checking your $LOG files for failed attempts ..."
FAILED_ATTEMPTS=$(sudo cat /var/log/auth.log* | grep "Failed" | cat -n | awk '{ printf $1 "\n" }' | tail -1)
echo ""
echo "A total of $FAILED_ATTEMPTS failed attempts were found, sorting common IPs ..."
echo ""

sudo cat $LOG | grep "Failed" | grep "invalid user" | awk '{ printf $13 "\n" }' > $IPS_OUTPUT

# Organize IPs by most common
cat $IPS_OUTPUT | sort | uniq -c > $IPS_SORTED

# Look up their country
for IP in `cat $IPS_SORTED | awk '{print $2}'`
do
    echo "Checking GeoIP Location for $IP … "
    curl -s http://ipinfo.io/$IP >> $IPS_COUNTRY
done

# Save the $IPS_COUNTRY information in this file
cat $IPS_COUNTRY > $IPS_INFO

# Output to user
echo ""
echo "================ COUNTRY OUTPUT ======================="
echo ""
sed -e 's/}{//g' -e 's/,//g' -e 's/{//' -e 's/}//' -e 's/"//g' $IPS_COUNTRY
sed -e 's/}{//g' -e 's/,//g' -e 's/{//' -e 's/}//' -e 's/"//g' $IPS_COUNTRY > $IPS_INFO

# Cleaning files
/bin/rm -rf $IPS_COUNTRY
/bin/rm -rf $IPS_SORTED
/bin/rm -rf $IPS_OUTPUT

echo ""
echo "======================================================="

}

#
# -------------------------------- FUNCTIONS --------------------------------------
#

#
# ------------------------------ INSTRUCTIONS -------------------------------------
#

banner
main

#
# ------------------------------ INSTRUCTIONS -------------------------------------
#
