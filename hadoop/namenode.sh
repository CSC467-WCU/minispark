#!/bin/bash

sudo rm -Rf /software/hadoop*
sudo rm -Rf /software/jdk*

sudo wget https://www.cs.wcupa.edu/lngo/data/hadoop-3.3.0.tar.gz
sudo tar xzf hadoop-3.3.0.tar.gz -C /software 

sudo wget https://www.cs.wcupa.edu/lngo/data/OpenJDK8U-jdk_x64_linux_hotspot_8u275b01.tar.gz
sudo tar xzf OpenJDK8U-jdk_x64_linux_hotspot_8u275b01.tar.gz -C /software

sudo cp -R /local/repository/hadoop /software/

export JAVA_HOME="/software/jdk8u275-b01/"
export HADOOP_HOME="/software/hadoop-3.3.0"
export HADOOP_CONF_DIR="/software/hadoop/config"
export YARN_CONF_DIR="/software/hadoop/config"
export HADOOP_DATA_DIR="/hadoop/hdfs/datanode"
export HADOOP_LOG_DIR="/hadoop/hadoop/log"
export HADOOP_TMP_DIR="/hadoop/hadoop/tmp"
export YARN_LOCAL_DIR="/hadoop/yarn/data"
export YARN_LOG_DIR="/hadoop/yarn/logs"

#NAMENODE=`hostname -f`
NAMENODE='192.168.1.1'

# core-site.xml
sudo sed -i 's:NAMENODE:'"$NAMENODE"':g' ${HADOOP_CONF_DIR}/core-site.xml
sudo sed -i 's:HADOOP_DATA_DIR:'"$HADOOP_DATA_DIR"':g' ${HADOOP_CONF_DIR}/core-site.xml
sudo sed -i 's:HADOOP_TMP_DIR:'"$HADOOP_TMP_DIR"':g' $HADOOP_CONF_DIR/core-site.xml

# hadoop-env.sh
sudo echo "" > $HADOOP_CONF_DIR/hadoop-env.sh
sudo echo "export HADOOP_LOG_DIR=$HADOOP_LOG_DIR" >> $HADOOP_CONF_DIR/hadoop-env.sh
sudo echo "export JAVA_HOME=/software/jdk8u275-b01/" >> $HADOOP_CONF_DIR/hadoop-env.sh


# hdfs-site.xml
sudo sed -i 's:HADOOP_DATA_DIR:'"$HADOOP_DATA_DIR"':g' ${HADOOP_CONF_DIR}/hdfs-site.xml

# mapred-site.xml
sudo sed -i 's:NAMENODE:'"$NAMENODE"':g' ${HADOOP_CONF_DIR}/mapred-site.xml
sudo sed -i 's:HADOOPHOME:'"$HADOOP_HOME"':g' ${HADOOP_CONF_DIR}/mapred-site.xml

# yarn-site.xml
sudo sed -i 's:NAMENODE:'"$NAMENODE"':g' ${HADOOP_CONF_DIR}/yarn-site.xml
sudo sed -i 's:YARN_LOCAL_DIR:'"$YARN_LOCAL_DIR"':g' ${HADOOP_CONF_DIR}/yarn-site.xml
sudo sed -i 's:YARN_LOG_DIR:'"$YARN_LOG_DIR"':g' ${HADOOP_CONF_DIR}/yarn-site.xml

#components
sudo echo $NAMENODE > ${HADOOP_CONF_DIR}/master
sudo touch ${HADOOP_CONF_DIR}/workers

time ${HADOOP_HOME}/bin/hdfs --config ${HADOOP_CONF_DIR} namenode -format -force
time ${HADOOP_HOME}/bin/hdfs --config ${HADOOP_CONF_DIR} --daemon start namenode
time ${HADOOP_HOME}/bin/yarn --config ${HADOOP_CONF_DIR} --daemon start resourcemanager
time ${HADOOP_HOME}/bin/mapred --daemon start historyserver

sudo mkdir /software/hadoop_done
