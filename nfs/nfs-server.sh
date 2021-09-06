#!/bin/bash

sudo yum install -y nfs-utils

for dir in scratch software; do
  mkdir -p /$dir/flag
  chown nobody:nobody /$dir
  sudo chmod 755 /$dir
done

sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl enable nfs-lock
sudo systemctl enable nfs-idmap
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl start nfs-lock
sudo systemctl start nfs-idmap

for dir in scratch software; do
  for (( i=2; i<=$1; i++ ))
  do
    echo "$dir 192.168.1.$i(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
  done
done

sudo systemctl restart nfs-server
