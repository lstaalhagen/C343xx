#!/usr/bin/env bash

source /etc/iperfclientserver.conf

# Wait 15 seconds to ensure wlan0 interface is active
sleep 30

iperf -u -c ${SERVERIP} -b ${BANDWIDTH} -i ${INTERVAL} -t ${TIME}
