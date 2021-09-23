
#!/bin/bash 
set -x

workers=$1
echo "Number of workers: ${workers}"

sudo apt-get install -y nfs-kernel-server
sudo mkdir -p /opt/keys/flagdir
sudo chown nobody:nogroup /opt/keys
sudo chmod -R a+rwx /opt/keys

for i in 2..${workerS}
do
  echo "/opt/keys 192.168.1.${i}(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
done

sudo systemctl restart nfs-kernel-server

wget --no-verbose https://ftp.wayne.edu/apache/spark/spark-3.0.3/spark-3.0.3-bin-hadoop3.2.tgz
tar xzf spark-3.0.3-bin-hadoop3.2.tgz
mv spark-3.0.3-bin-hadoop3.2 /opt/
rm spark-3.0.3-bin-hadoop3.2.tgz

sudo touch /opt/spark_master_done
