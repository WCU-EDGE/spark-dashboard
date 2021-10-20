#!/bin/bash

set -x

sudo apt-get update
sudo apt-get install -y nfs-common

sudo mkdir -p /opt/software

while [ ! -f /opt/software/DONE ]; do
  sudo mount 192.168.1.1:/opt/software /opt/software
  sleep 10
done


#export JAVA_HOME=/opt/software/jdk-11.0.12+7
#lngo@head:/opt/software/jdk-11.0.12+7$ cd /opt/software/spark-3.0.3-bin-hadoop3.2/
#./bin/spark-class org.apache.spark.deploy.worker.Worker --webui-port 8080 spark://192.168.1.1:7077 >> /opt/software/spark-worker.out
