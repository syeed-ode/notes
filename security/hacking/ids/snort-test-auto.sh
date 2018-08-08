 #!/bin/sh
 #
 ###############################################################
 # You are free to copy and distribute this script under #
 # GNU Public License until this part is not removed #
 # from the script. #
 ###############################################################
 # HOW TO USE #
 # #
 # Right after installation of Snort, run this script. #
 # It is assumed that snort executable is present in the #
 # /opt/argus/bin directory and all rules and configuration #
 # files are present under /opt/argus/etc/snort directory. #
 # If files are in other locations, edit the following location#
 # of variables. If you used the installation script provided #
 # along with this script, the files will be automatically #
 # located in appropriate directories. #
 # #
 # Note that the script starts and stops Snort by itself and #
 # you should make sure that Snort is not running at the time #
 # you run this script. #
 # #
 # It will generate alerts in /tmp/alert file similar #
 # to the following: #
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

 PREFIX=/usr/local/Cellar/snort/2.9.11
 SNORT=$PREFIX/bin/snort
 SNORT_CONFIG=$PREFIX/etc/snort.conf
 LOG_DIR=/var/log/snort
 ALERT_FILE=$LOG_DIR/alert
 ALERT_FILE_OLD=$LOG_DIR/alert.old
 ADDRESS="255.255.255.255"

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

 echo
 echo "###############################################################"
 echo "The script generates three alerts in file /tmp/alert"
 echo "Each alert should start with message like the following:"
 echo
 echo " \"ATTACK RESPONSES id check returned root\" "
 echo "###############################################################"
 echo

 if [ ! -d $LOG_DIR ]
 then
 echo "Creating log directory ..."
 mkdir $LOG_DIR

 if [ $? -ne 0 ]
 then
 echo "Directory $LOGDIR creation failed"
 echo "Aborting ..."
 exit 1
 fi
 fi

 if [ -f $ALERT_FILE ]
 then
 mv -f $ALERT_FILE $ALERT_FILE_OLD

 if [ $? -ne 0 ]
 then
 echo "Can't rename old alerts file."
 echo "Aborting ..."
 exit 1
 fi
 fi

 if [ ! -f $SNORT ]
 then
  echo "Snort executable file $SNORT does not exist."
 echo "Aborting ..."
 exit 1
 fi

 if [ ! -f $SNORT_CONFIG ]
 then
 echo "Snort configuration file $SNORT_CONFIG does not exist."
 echo "Aborting ..."
 exit 1
 fi

 if [ ! -x $SNORT ]
 then
 echo "Snort file $SNORT is not executable."
 echo "Aborting ..."
 exit 1
 fi

 echo "Starting Snort ..."
 $SNORT -c $SNORT_CONFIG -D -l /tmp 2>/dev/null

 if [ $? -ne 0 ]
 then
 echo "Snort startup failed."
 echo "Aborting ..."
 exit 1
 fi

 echo
 echo "Now generating alerts."

 ping -i 0.3 -n -r -b $ADDRESS -p "7569643d3028726f6f74290a" -c3 2>/dev/null>/dev/null

 if [ $? -ne 0 ]
 then
 echo "Alerting generation failed."
 echo "Aborting ..."
 exit 1
 else
 echo
 echo "Alert generation complete"
 echo
 echo
 fi

 sleep 2

 tail -n18 $ALERT_FILE 2>/dev/null | grep "ATTACK RESPONSES id check" >/dev/null

 if [ $? -ne 0 ]
 then
 echo "Snort test failed."
 echo "Aborting ..."
 exit 1
 fi

 echo "Stopping Snort ..."
 pkill snort >/dev/null 2>&1

 if [ $? -ne 0 ]
 then
 echo "Snort stopping failed."
 echo "Aborting ..."
 exit 1
 fi

 echo
 echo "Done. Snort installation is working properly"
 echo


