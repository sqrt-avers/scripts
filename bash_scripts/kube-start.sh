#!/bin/bash
ssh-keygen -t rsa -C "$(whoami)@$(hostname)-$(date -I)" -f "/root/.ssh/id_rsa" -N ""
ssh-copy-id -i /root/.ssh/id_rsa.pub vagrant@192.168.x.x
ssh-copy-id -i /root/.ssh/id_rsa.pub vagrant@192.168.x.x
ssh-copy-id -i /root/.ssh/id_rsa.pub vagrant@192.168.x.x
wget https://github.com/GoogleCloudPlatform/kubernetes/releases/download/v0.17.0/kubernetes.tar.gz
tar xzf ./kubernetes.tar.gz
rm kubernetes.tar.gz
sed -i 's/FLANNEL_VERSION="0.4.0"/FLANNEL_VERSION="0.7.1"/g' /home/vagrant/kubernetes/cluster/ubuntu/build.sh
sed -i 's/ETCD_VERSION="v2.0.0"/ETCD_VERSION="v3.2.0"/g' /home/vagrant/kubernetes/cluster/ubuntu/build.sh
sed -i 's/K8S_VERSION="v0.15.0"/K8S_VERSION="v0.17.0"/g' /home/vagrant/kubernetes/cluster/ubuntu/build.sh
cd /home/vagrant/kubernetes/cluster/ubuntu | ./build.sh
sed -i 's/export nodes="vcap@10.10.103.250 vcap@10.10.103.162 vcap@10.10.103.223"/export nodes="vagrant@192.168.x.x vagrant@192.168.x.x vagrant@192.168.x.x"/g' /home/vagrant/kubernetes/cluster/ubuntu/confi$
sed -i 's/export PORTAL_NET=192.168.3.0\/24/export PORTAL_NET=10.10.10.0\/24/g' /home/vagrant/kubernetes/cluster/ubuntu/config-default.sh
sed -i 's/DNS_SERVER_IP="192.168.3.10"/DNS_SERVER_IP="10.10.10.101"/g' /home/vagrant/kubernetes/cluster/ubuntu/config-default.sh
eval `ssh-agent -s`
ssh-add /root/.ssh/id_rsa
cd /home/vagrant/kubernetes/cluster | KUBERNETES_PROVIDER=ubuntu ./kube-up.sh
