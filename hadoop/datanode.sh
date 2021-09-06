#!/bin/bash

while [ ! -d /software/hadoop_done ]
do
  sleep 10
done

export JAVA_HOME="/software/jdk8u275-b01/"
export HADOOP_HOME="/software/hadoop-3.3.0"
export HADOOP_CONF_DIR="/software/hadoop/config"

DATANODE=`hostname --all-ip-addresses | awk '{print $2}'`

echo $DATANODE >> ${HADOOP_CONF_DIR}/workers

$HADOOP_HOME/bin/hdfs --config ${HADOOP_CONF_DIR} --daemon start datanode
$HADOOP_HOME/bin/yarn --config ${HADOOP_CONF_DIR} --daemon start nodemanager

