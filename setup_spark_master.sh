
#!/bin/bash 
set -x

workers=$1
echo "Number of workers: ${workers}"

sudo apt-get update
sudo apt-get install -y nfs-kernel-server

sudo mkdir -p /opt/software
sudo chown nobody:nogroup /opt/software
sudo chmod -R a+rwx /opt/software

for (( i=2; i<=$workers; i++ ))
do
  echo "/opt/software 192.168.1.${i}(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
done

sudo systemctl restart nfs-kernel-server

wget --no-verbose https://ftp.wayne.edu/apache/spark/spark-3.0.3/spark-3.0.3-bin-hadoop3.2.tgz
tar xzf spark-3.0.3-bin-hadoop3.2.tgz
mv spark-3.0.3-bin-hadoop3.2 /opt/software/
rm spark-3.0.3-bin-hadoop3.2.tgz

wget --no-verbose https://www.cs.wcupa.edu/lngo/data2/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
tar xzf OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
mv jdk-11.0.12+7 /opt/software/
rm OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz

sudo touch /opt/software/DONE

sudo chown -R rammy: /opt/software/jdk-11.0.12+7
sudo chown -R rammy: /opt/software/spark-3.0.3-bin-hadoop3.2

echo 'export JAVA_HOME=/opt/software/jdk-11.0.12+7' >> /home/rammy/.bashrc
echo 'export SPARK_HOME="/opt/software/spark-3.0.3-bin-hadoop3.2/"' >> /home/rammy/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$SPARK_HOME/bin:$PATH' >> /home/rammy/.bashrc
chown rammy: /home/rammy/.bashrc

npPasswd=$(python3 -c "from notebook.auth import passwd; print(passwd('$2',algorithm='sha1'))")
echo $npPasswd

sudo -H -u rammy bash -i -c "jupyter notebook --port 8888 --no-browser --ip=0.0.0.0 --NotebookApp.token='' --NotebookApp.password=$npPasswd --NotebookApp.notebook_dir=/home/rammy/ &" &
sudo -H -u rammy bash -i -c 'spark-class org.apache.spark.deploy.master.Master --ip 192.168.1.1 --port 7077 --webui-port 8080 >> /opt/software/master.log &' &

#export JAVA_HOME=/opt/software/jdk-11.0.12+7
#lngo@head:/opt/software/jdk-11.0.12+7$ cd /opt/software/spark-3.0.3-bin-hadoop3.2/
#./bin/spark-class org.apache.spark.deploy.master.Master --ip 192.168.1.1 --port 7077 --webui-port 8080 >> /opt/software/log
