#!/usr/bin/env bash

source /etc/iperfclientserver.conf

# Wait 25 seconds to ensure wlan0 interface is active
sleep 25

# Start iperf server
iperf -u -s -B ${SERVERIP}

