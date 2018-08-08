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
 11 # It is assumed that snort executable is present in the #
 12 # /opt/argus/bin directory and all rules and configuration #
 13 # files are present under /opt/argus/etc/snort directory. #
 14 # If files are in other locations, edit the following location#
 15 # of variables. If you used the installation script provided #
 16 # along with this script, the files will be automatically #
 17 # located in appropriate directories. #
 18 # #
 19 # Note that the script starts and stops Snort by itself and #
 20 # you should make sure that Snort is not running at the time #
 21 # you run this script. #
 22 # #
 23 # It will generate alerts in /tmp/alert file similar #
 24 # to the following: #
 25 # #
 26 # [**] [1:498:3] ATTACK RESPONSES id check returned root [**] #
 27 # [Classification: Potentially Bad Traffic] [Priority: 2] #
 28 # 08/31-15:56:48.188882 255.255.255.255 -> 192.168.1.111 #
 29 # ICMP TTL:150 TOS:0x0 ID:0 IpLen:20 DgmLen:84 #
 30 # Type:0 Code:0 ID:45596 Seq:1024 ECHO REPLY #
 31 # #
 32 # These alerts are displayed at the end of the script. #
 33 ###############################################################
 34 #
 35
 36 PREFIX=/opt/snort
 37 SNORT=$PREFIX/bin/snort
 38 SNORT_CONFIG=$PREFIX/etc/snort.conf
 39 LOG_DIR=/tmp
 40 ALERT_FILE=$LOG_DIR/alert
 41 ALERT_FILE_OLD=$LOG_DIR/alert.old
 42 ADDRESS="255.255.255.255"
 43
 44 clear
 45
 46 echo "###############################################################"
 47 echo "# Script to test Snort Installation #"
 48 echo "# Written By #"
 49 echo "# #"
 50 echo "# Rafeeq Rehman #"
 51 echo "# rr@argusnetsec.com #"
 52 echo "# Argus Network Security Services Inc. #"
 53 echo "# http://www.argusnetsec.com #"
 54 echo "###############################################################"
 55 echo
 56
 57 echo
 58 echo "###############################################################"
 59 echo "The script generates three alerts in file /tmp/alert"
 60 echo "Each alert should start with message like the following:"
 61 echo
 62 echo " \"ATTACK RESPONSES id check returned root\" "
 63 echo "###############################################################"
 64 echo
 65
 66 if [ ! -d $LOG_DIR ]
 67 then
 68 echo "Creating log directory ..."
 69 mkdir $LOG_DIR
 70
 71 if [ $? -ne 0 ]
 72 then
 73 echo "Directory $LOGDIR creation failed"
 74 echo "Aborting ..."
 75 exit 1
 76 fi
 77 fi
 78
 79 if [ -f $ALERT_FILE ]
 80 then
 81 mv -f $ALERT_FILE $ALERT_FILE_OLD
 82
 83 if [ $? -ne 0 ]
 84 then
 85 echo "Can't rename old alerts file."
 86 echo "Aborting ..."
 87 exit 1
 88 fi
 89 fi
 90
 91 if [ ! -f $SNORT ]
 92 then
 93 echo "Snort executable file $SNORT does not exist."
 94 echo "Aborting ..."
 95 exit 1
 96 fi
 97
 98 if [ ! -f $SNORT_CONFIG ]
 99 then
 100 echo "Snort configuration file $SNORT_CONFIG does not exist."
 101 echo "Aborting ..."
 102 exit 1
 103 fi
 104
 105 if [ ! -x $SNORT ]
 106 then
 107 echo "Snort file $SNORT is not executable."
 108 echo "Aborting ..."
 109 exit 1
 110 fi
 111
 112 echo "Starting Snort ..."
 113 $SNORT -c $SNORT_CONFIG -D -l /tmp 2>/dev/null
 114
 115 if [ $? -ne 0 ]
 116 then
 117 echo "Snort startup failed."
 118 echo "Aborting ..."
 119 exit 1
 120 fi
 121
 122 echo
 123 echo "Now generating alerts."
 124
 125 ping -i 0.3 -n -r -b $ADDRESS -p "7569643d3028726f6f74290a" -c3 2>/dev/null>/dev/null
 126
 127 if [ $? -ne 0 ]
 128 then
 129 echo "Alerting generation failed."
 130 echo "Aborting ..."
 131 exit 1
 132 else
 133 echo
 134 echo "Alert generation complete"
 135 echo
 136 fi
 137
 138 sleep 2
 139
 140 tail -n18 $ALERT_FILE 2>/dev/null | grep "ATTACK RESPONSES id check" >/dev/null
 141
 142 if [ $? -ne 0 ]
 143 then
 144 echo "Snort test failed."
 145 echo "Aborting ..."
 146 exit 1
 147 fi
 148
 149 echo "Stopping Snort ..."
 150 pkill snort >/dev/null 2>&1
 151
 152 if [ $? -ne 0 ]
 153 then
 154 echo "Snort stopping failed."
 155 echo "Aborting ..."
 156 exit 1
 157 fi
 158
 159 echo
 160 echo "Done. Snort installation is working properly"
 161 echo


