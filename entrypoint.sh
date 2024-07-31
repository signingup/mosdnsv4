#!/bin/bash
set -m

/usr/local/bin/mosdns start --as-service -d /etc/mosdns -c config.yaml &

crond -f
fg %1
