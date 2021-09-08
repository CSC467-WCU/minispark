#!/bin/bash

# the username needs to be changed
while IFS= read -r line; do
  echo 'export JAVA_HOME=/opt/jdk-11.0.12+7/' >> /users/$line/.bashrc
  echo 'export SPARK_HOME="/opt/spark-3.0.1-bin-hadoop3.2"' >> /users/$line/.bashrc
  echo 'export PATH=$JAVA_HOME/bin:$SPARK_HOME/bin:$ANACONDA_HOME/bin:$PATH' >> /users/$line/.bashrc
  chown $line: /users/$line/.bashrc
done < <( ls -l /users | grep 4096 | cut -d' ' -f3 )

set -x

apt-get update && apt-get install -qqq -y curl vim wget software-properties-common ssh net-tools ca-certificates jq
apt-get install -qqq -y python3 python3-pip python3-numpy python3-matplotlib python3-scipy python3-pandas python3-simpy ipython3
pip3 install ipykernel jupyter findspark
pip3 install --upgrade Pygments

cd /opt
wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
tar xzf OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz
tar xzf spark-3.0.1-bin-hadoop3.2.tgz

echo "DONE SETTING UP"



