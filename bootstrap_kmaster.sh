echo "[TASK 1] Pull required containers"
kubeadm config images pull 

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.20.10.15 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log

echo "[TASK 3] Deploy Flannel network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command >> /root/joincluster.sh 