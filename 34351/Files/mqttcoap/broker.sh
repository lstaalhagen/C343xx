#!/usr/bin/env bash

# Script to start or stop the Mosquitto MQTT Broker. (C) Copyright 2025, Lars Staalhagen

# Check for terminal
# [ "$TERM" = "xterm" ] && echo "Please execute script in a normal terminal" && exit

# Check if broker already running
ISRUNNING=N
if ( pgrep mosquitto > /dev/null ) ; then
  ISRUNNING=Y
fi

if [ $# -lt 1 ] ; then
  echo "Usage: sudo broker.sh start|stop|status"
  exit 1
fi

if [ "${1}" = "status" ] ; then
  if [ "${ISRUNNING}" = "Y" ] ; then
    echo "Mosquitto broker is running"
  else
    echo "Mosquitto broker is not running"
  fi
  exit 0
fi

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1

# Create a mosquitto directory in /var/run for PID
[ ! -d /var/run/mosquitto ] && mkdir -p /var/run/mosquitto &&  chown mosquitto: /var/run/mosquitto

# Create a new configuration file in /tmp
cat >/tmp/mosquitto.conf <<-EndOfConfig
	# DO NOT CHANGE THE NEXT BLOCK OF LINES
	pid_file /var/run/mosquitto/mosquitto.pid
	persistence true
	persistence_location /var/lib/mosquitto/
	log_dest file /var/log/mosquitto/mosquitto.log
	# ############################################

	# MAKE YOUR CHANGES BELOW THIS LINE
	listener 1883 0.0.0.0
	allow_anonymous true
EndOfConfig

if [ "${1}" = "start" ] ; then
  if [ "${ISRUNNING}" = "N" ] ; then
    NS=$(ip netns identify)
	if [ -z "${NS}" ] ; then
      echo "mosquitto -c /tmp/mosquitto.conf" | at now 1>/dev/null 2>&1
	else
	  echo "ip netns exec ${NS} mosquitto -c /tmp/mosquitto.conf" | at now 1>/dev/null 2>&1
	fi 
  else
    echo "Already running"
  fi
elif [ "${1}" = "stop" ] ; then
  if [ "${ISRUNNING}" = "Y" ] ; then
    pkill mosquitto
  else
    echo "Not running"
  fi
  [ -f /tmp/mosquitto.conf ] && rm -f /tmp/mosquitto.conf
else
  echo "Unknown command: ${1}"
fi
