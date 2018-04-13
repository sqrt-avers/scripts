#!/bin/bash
curl -sSL https://get.docker.com/ | sh
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
kubeadm init --apiserver-advertise-address=10.0.0.4 --pod-network-cidr=192.168.0.0/16
#next needt to join on slave nodes
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml
echo "$(kubectl get nodes)"
echo "$(kubectl get pods --all-namespaces)"
