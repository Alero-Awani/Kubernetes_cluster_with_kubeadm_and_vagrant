#!/bin/bash

echo "[TASK 1] Join node to Kubernetes Cluster"
sudo su - 
apt install -qq -y sshpass
mkdir /
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster:/root/joincluster.sh /root/joincluster.sh 
bash /root/joincluster.sh 

# We have to do it this way because the token will always change 