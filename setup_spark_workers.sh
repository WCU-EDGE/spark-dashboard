#!/bin/bash

set -x

sudo apt-get update
sudo apt-get install -y nfs-common

sudo mkdir -p /opt/software

while [ ! -f /opt/software/DONE ]; do
  sudo mount 192.168.1.1:/opt/software /opt/software
  sleep 10
done
