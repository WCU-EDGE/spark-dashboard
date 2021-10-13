set -x
sudo apt-get update
#WIP - set JAVA_HOME and ensure every user who ssh's in knows where it is
while IFS= read -r line; do
  echo 'export JAVA_HOME=users/$line/jdk-11.0.12+7' >> /users/$line/.bashrc
  chown $line: /users/$line/.bashrc
done < <( ls -l /users | grep 4096 | cut -d' ' -f3 )

#download and install java
wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
tar xzf OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz

#download and install kafka
wget https://dlcdn.apache.org/kafka/3.0.0/kafka_2.13-3.0.0.tgz
### add verification of downloaded file? -https://www.apache.org/dyn/closer.cgi?path=/kafka/3.0.0/kafka_2.13-3.0.0.tgz ###
tar -xzf kafka_2.13-3.0.0.tgz

# cd kafka_2.13-3.0.0
# bin/zookeeper-server-start.sh config/zookeeper.properties
# bin/kafka-server-start.sh config/server.properties
