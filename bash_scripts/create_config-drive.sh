#!/bin/bash
mkdir -p config-drive
cat > config-drive/user-data <<EOF
#cloud-config
password: password
chpasswd: { expire: False }
ssh_pwauth: True

bootcmd:
 - [ sh, -c, echo "=========bootcmd=========" ]

runcmd:
 - [ sh, -c, echo "=========runcmd=========" ]

# add ssh public keys
ssh_authorized_keys:
  - $(cat ~/.ssh/id_rsa.pub)

# This is for pexpect so that it knows when to log in and begin tests
final_message: "SYSTEM READY TO LOG IN"

cat > config-drive/meta-data <<EOF
local-hostname: kube0
EOF

genisoimage -output config-drive.iso -volid cidata -joliet -rock config-drive/user-data config-drive/meta-data

# laung an instance
virt-install --import --name kub2 --ram 2048 --vcpus 1 --disk xenial-server-cloudimg-amd64-disk2.img,format=qcow2,bus=virtio --disk config-drive.iso,device=cdrom --network default --os-type=linux --os-variant=ubuntu16.04 --noautoconsole
