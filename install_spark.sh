#!/bin/bash


apt-get update && apt-get install -qqq -y curl vim wget software-properties-common ssh net-tools ca-certificates jq
apt-get install -qqq -y python3 python3-pip python3-numpy python3-matplotlib python3-scipy python3-pandas python3-simpy ipython3

wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz
tar xzf OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz -C /opt/


export PATH=$PWD/jdk-11.0.12+7/bin:$PATH
