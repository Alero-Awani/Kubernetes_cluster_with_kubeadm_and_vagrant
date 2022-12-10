#!/bin/bash

## !IMPORTANT ##
#
## This script is tested only in the generic/ubuntu2004 Vagrant box
## If you use a different version of Ubuntu or a different Ubuntu Vagrant box test this again
#
echo "[TASK 1] login as root user and disable firewall"
sudo su -
ufw disable

# echo "[TASK 1.5] Get the bridge ip"
# IPADDRESS = $(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | cut -d ' ' -f 1)
# echo $IPADDRESS

echo "[TASK 1.5] Disable swap"
swapoff -a; sed -i '/swap/d' /etc/fstab


echo "[TASK 2] enable sysctl settings for kubernete Networking"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo "[TASK 3] Install the docker engine"

echo "updating the ubuntu packages"
apt update -o Acquire::CompressionTypes::Order::=gz

echo "installing certificates"
apt update -o Acquire::CompressionTypes::Order::=gz
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "Adding the docker repository"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update -o Acquire::CompressionTypes::Order::=gz

echo "Intalling docker"
# echo -e "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list;apt-get update
# apt-get install -y docker-ce
# apt install --force-yes -y containerd.io
apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io


echo "[TASK 4] Add apt repo for kubernetes" 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

echo "[TASK 5] Install Kubernetes components (kubeadm, kubelet and kubectl)"
apt update && apt install -y kubeadm=1.18.5-00 kubelet=1.18.5-00 kubectl=1.18.5-00

echo "[TASK 6] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 7] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root 
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "[TASK 8] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.20.10.15   kmaster
172.20.10.16   kworker1
EOF

# echo "[TASK 9] To run kubectl as non root user"
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config






# echo "[TASK 1] Disable and turn off SWAP"
# sed -i '/swap/d' /etc/fstab
# swapoff -a

# echo "[TASK 2] Stop and Disable firewall"
# systemctl disable --now ufw >/dev/null 2>&1

# echo "[TASK 3] Enable and Load Kernel modules"
# cat >>/etc/modules-load.d/containerd.conf<<EOF
# overlay
# br_netfilter
# EOF
# modprobe overlay
# modprobe br_netfilter

# echo "[TASK 4] Add Kernel settings"
# cat >>/etc/sysctl.d/kubernetes.conf<<EOF
# net.bridge.bridge-nf-call-ip6tables = 1
# net.bridge.bridge-nf-call-iptables  = 1
# net.ipv4.ip_forward                 = 1
# EOF
# sysctl --system >/dev/null 2>&1

# echo "[TASK 5] Install containerd runtime"
# apt update -qq >/dev/null 2>&1
# apt install -qq -y containerd apt-transport-https >/dev/null 2>&1
# mkdir /etc/containerd
# containerd config default > /etc/containerd/config.toml
# sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
# systemctl restart containerd
# systemctl enable containerd >/dev/null 2>&1

# echo "[TASK 6] Add apt repo for kubernetes"
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - >/dev/null 2>&1
# apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/dev/null 2>&1

# echo "[TASK 7] Install Kubernetes components (kubeadm, kubelet and kubectl)"
# apt install -qq -y kubeadm=1.24.0-00 kubelet=1.24.0-00 kubectl=1.24.0-00 >/dev/null 2>&1

# echo "[TASK 8] Enable ssh password authentication"
# sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
# echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
# systemctl reload sshd

# echo "[TASK 9] Set root password"
# echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
# echo "export TERM=xterm" >> /etc/bash.bashrc

# echo "[TASK 10] Update /etc/hosts file"
# cat >>/etc/hosts<<EOF
# 172.16.16.100   kmaster.example.com     kmaster
# 172.16.16.101   kworker1.example.com    kworker1
# 172.16.16.102   kworker2.example.com    kworker2