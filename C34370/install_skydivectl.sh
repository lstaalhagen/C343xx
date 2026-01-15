#!/usr/bin/env bash

[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1

PROGRAM=skydivectl
rm -f ${PROGRAM}
cat <<-"EOF" > ${PROGRAM}
#!/bin/bash

# Modified version by Rudolf A. Fortes :-)

CMD="/usr/local/bin/skydive allinone"
SKYDIVE_ETCD_DATA_DIR="/tmp"
SKYDIVE_ANALYZER_LISTEN="0.0.0.0:8082"

check_skydive_status() {
  # This does not work with spaces
  # if ps ax | grep -q "${CMD}" && ! ps ax | grep -q "grep ${CMD}"; then 
  if pgrep -f "${CMD}" > /dev/null && ! pgrep -f "grep ${CMD}" > /dev/null; then
    ISRUNNING="Y"
  else
    ISRUNNING="N"
  fi
}

start_skydive() {
  echo "Skydive is starting. Open http://localhost:8082 in the browser."
  # SKYDIVE_ETCD_DATA_DIR=/tmp SKYDIVE_ANALYZER_LISTEN=0.0.0.0:8082 sudo -E ${CMD} 1>/dev/null 2>&1 | at -M now 1>/dev/null 2>&1
  echo "SKYDIVE_ETCD_DATA_DIR=/tmp SKYDIVE_ANALYZER_LISTEN=0.0.0.0:8082 ${CMD} &>/dev/null" | sudo at now &>/dev/null
}

stop_skydive() {
  sudo -E pkill skydive
}

check_skydive_status

if [ "${ISRUNNING}" = "Y" ]; then
  echo -n "Stop Skydive? (Y/N): "
  read -r ANSWER
  if [ "${ANSWER}" = "Y" ] || [ "${ANSWER}" = "y" ]; then
    stop_skydive
  fi
else
  echo -n "Start Skydive? (Y/N): "
  read -r ANSWER
  if [ "${ANSWER}" = "Y" ] || [ "${ANSWER}" = "y" ]; then
    start_skydive
  fi
fi
EOF

# Install the program
install -m 0755 ${PROGRAM} /usr/local/bin
