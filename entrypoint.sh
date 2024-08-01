#!/bin/bash
set -m
FILE="/mosdns/start.sh"

if [ -f "$FILE" ]; then
  cp "$FILE" /usr/bin/start
  chmod +x /usr/bin/start && /usr/bin/start
fi

/usr/local/bin/mosdns start --as-service -d /etc/mosdns -c config.yaml &

crond -f
fg %1
