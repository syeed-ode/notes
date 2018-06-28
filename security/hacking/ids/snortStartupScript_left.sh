#!/bin/sh
#
# cat snortStartupScript.sh | sed -e 's/^[ ][0-9][0-9]* //' | sed -e 's/[ ]*[0-9]*//'  > snortStartupScript_left.sh
#
# HOW TO USE #
# #
# Right after installation of Snort, run this script. #
# It will generate alerts in /var/log/snort/alert file similar#
# to the following: #
# #
# Note that Snort must be running at the time you run this #
# script. #
# #
# [**] [1:498:3] ATTACK RESPONSES id check returned root [**] #
# [Classification: Potentially Bad Traffic] [Priority: 2] #
# 08/31-15:56:48.188882 255.255.255.255 -> 192.168.1.111 #
# ICMP TTL:150 TOS:0x0 ID:0 IpLen:20 DgmLen:84 #
# Type:0 Code:0 ID:45596 Seq:1024 ECHO REPLY #
# #
# These alerts are displayed at the end of the script. #
###############################################################
#
clear
echo "###############################################################"
echo "# Script to test Snort Installation #"
echo "# Written By #"
echo "# #"
echo "# Rafeeq Rehman #"
echo "# rr@argusnetsec.com #"
echo "# Argus Network Security Services Inc. #"
echo "# http://www.argusnetsec.com #"
echo "###############################################################"
echo

Installing Snort 45
echo
echo "###############################################################"
echo "The script generates three alerts in file /var/log/snort/alert"
echo "Each alert should start with message like the following:"
echo
echo " \"ATTACK RESPONSES id check returned root\" "
echo "###############################################################"
echo
echo "Enter IP address of any other host on this network. If you"
echo "don't know any IP address, just hit Enter key. By default"
echo -n "broacast packets are used [255.255.255.255] : "

read ADDRESS

if [ -z $ADDRESS ]; then
	ADDRESS="255.255.255.255"
fi

echo
echo "Now generating alerts. If it takes more than 5 seconds, break"
echo "the script by pressing Ctrl-C. Probably you entered wrong IP"
echo "address. Run the script again and don't enter any IP address"

ping -i 0.3 -n -r -b $ADDRESS -p "7569643d3028726f6f74290a" -c3 2>/dev/null >/dev/null

if [ $? -ne 0 ]; then
	echo "Alerting generation failed."
	echo "Aborting ..."
	exit 1
else
	echo
	echo "Alert generation complete"
	echo
fi

sleep 2


echo
echo "################################################################"
echo "Last 18 lines of /var/log/snort/alert file will be displayed now"
echo "If snort is working properly, you will see recently generated"
echo "alerts with current time"
echo "################################################################"
echo
echo "Hit Enter key to continue ..."
read ENTER

if [ ! -f /var/log/snort/alert ]; then
	echo "The log file does not exist."
	echo "Aborting ..."
	exit 1
fi

tail -n18 /var/log/snort/alert

echo
echo "Done"
echo
