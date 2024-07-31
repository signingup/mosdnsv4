#!/bin/bash

crond -f
/usr/local/bin/mosdns start --as-service -d /etc/mosdns -c config.yaml
