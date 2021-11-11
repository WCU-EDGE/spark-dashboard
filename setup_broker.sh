set -x
sudo apt-get update

sudo mkdir -p /opt/software
# sudo apt-get install -y nfs-kernel-server
# #WIP - set JAVA_HOME and ensure every user who ssh's in knows where it is
# while IFS= read -r line; do
#   echo 'export JAVA_HOME=users/$line/jdk-11.0.12+7' >> /users/$line/.bashrc
#   chown $line: /users/$line/.bashrc
# done < <( ls -l /users | grep 4096 | cut -d' ' -f3 )


wget --no-verbose https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
tar -xzf OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
mv jdk-11.0.12+7 /opt/software/
rm OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz

wget --no-verbose https://dlcdn.apache.org/kafka/3.0.0/kafka_2.13-3.0.0.tgz
tar -xzf kafka_2.13-3.0.0.tgz
mv kafka_2.13-3.0.0 /opt/software/
rm kafka_2.13-3.0.0.tgz

echo 'export JAVA_HOME=/opt/software/jdk-11.0.12+7'
# echo 'export PATH=$JAVA_HOME/bin:$SPARK_HOME/bin:$PATH' >> /home/rammy/.bashrc
# chown rammy: /home/rammy/.bashrc

cd /opt/software/kafka_2.13-3.0.0
bin/zookeeper-server-start.sh config/zookeeper.properties
bg
bin/kafka-server-start.sh config/server.properties
