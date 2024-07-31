#!/bin/bash

mosdns service install -d /etc/mosdns -c config.yaml
mosdns service start
