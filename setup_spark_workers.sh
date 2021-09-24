#!/bin/bash

set -x

sudo apt-get update
sudo apt-get install -y nfs-common

while [ ! -d /opt/flagdir ]; do
  sudo mount 192.168.1.1:/opt /opt
  sleep 10
done
