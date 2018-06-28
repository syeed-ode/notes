 1 #!/bin/sh
 2 #
 3 ###############################################################
 4 # You are free to copy and distribute this script under #
 5 # GNU Public License until this part is not removed #
 6 # from the script. #
 7 ###############################################################
 8 # HOW TO USE #
 9 # #
 10 # Right after installation of Snort, run this script. #
 11 # It will generate alerts in /var/log/snort/alert file similar#
 12 # to the following: #
 13 # #
 14 # Note that Snort must be running at the time you run this #
 15 # script. #
 16 # #
 17 # [**] [1:498:3] ATTACK RESPONSES id check returned root [**] #
 18 # [Classification: Potentially Bad Traffic] [Priority: 2] #
 19 # 08/31-15:56:48.188882 255.255.255.255 -> 192.168.1.111 #
 20 # ICMP TTL:150 TOS:0x0 ID:0 IpLen:20 DgmLen:84 #
 21 # Type:0 Code:0 ID:45596 Seq:1024 ECHO REPLY #
 22 # #
 23 # These alerts are displayed at the end of the script. #
 24 ###############################################################
 25 #
 26 clear
 27 echo "###############################################################"
 28 echo "# Script to test Snort Installation #"
 29 echo "# Written By #"
 30 echo "# #"
 31 echo "# Rafeeq Rehman #"
 32 echo "# rr@argusnetsec.com #"
 33 echo "# Argus Network Security Services Inc. #"
 34 echo "# http://www.argusnetsec.com #"
 35 echo "###############################################################"
 36 echo
 37
Installing Snort 45
 38 echo
 39 echo "###############################################################"
 40 echo "The script generates three alerts in file /var/log/snort/alert
  41 echo "Each alert should start with message like the following:"
 42 echo
 43 echo " \"ATTACK RESPONSES id check returned root\" "
 44 echo "###############################################################"
 45 echo
 46 echo "Enter IP address of any other host on this network. If you"
 47 echo "don't know any IP address, just hit Enter key. By default"
 48 echo -n "broacast packets are used [255.255.255.255] : "
 49
 50 read ADDRESS
 51
 52 if [ -z $ADDRESS ]
 53 then
 54 ADDRESS="255.255.255.255"
 55 fi
 56
 57 echo
 58 echo "Now generating alerts. If it takes more than 5 seconds, break"
 59 echo "the script by pressing Ctrl-C. Probably you entered wrong IP"
 60 echo "address. Run the script again and don't enter any IP address"
 61
 62 ping -i 0.3 -n -r -b $ADDRESS -p "7569643d3028726f6f74290a" -c3 2>/dev/null >/dev/null
 63
 64 if [ $? -ne 0 ]
 65 then
 66 echo "Alerting generation failed."
 67 echo "Aborting ..."
 68 exit 1
 69 else
 70 echo
 71 echo "Alert generation complete"
 72 echo
 73 fi
 74
 75 sleep 2
 76
 77
 78 echo
 79 echo "################################################################"
 80 echo "Last 18 lines of /var/log/snort/alert file will be displayed now"
 81 echo "If snort is working properly, you will see recently generated"
 82 echo "alerts with current time"
 83 echo "################################################################"
 84 echo
 85 echo "Hit Enter key to continue ..."
 86 read ENTER
 87
 88 if [ ! -f /var/log/snort/alert ]
  89 then
 90 echo "The log file does not exist."
 91 echo "Aborting ..."
 92 exit 1
 93 fi
 94
 95 tail -n18 /var/log/snort/alert
 96
 97 echo
 98 echo "Done"
 99 echo