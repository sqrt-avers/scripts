#!/bin/bash
mkdir -p config-drive
cat > config-drive/user-data <<EOF
#cloud-config
ssh_authorized_keys:
 - $(cat ~/.ssh/id_rsa.pub)
chpasswd: { expire: False }
password: pass
ssh_pwauth: True
EOF
cat > config-drive/meta-data <<EOF
local-hostname: kube0
EOF

# Need libguestfs-tools pkg to be installed
cd config-drive; LIBGUESTFS_BACKEND=direct virt-make-fs \
  --type=msdos --label=cidata . ../config-drive.img
# laung an instance
virt-install --import --name kub2 --ram 2048 --vcpus 1 --disk xenial-server-cloudimg-amd64-disk2.img,format=qcow2,bus=virtio --disk config-drive.img,device=cdrom --network default --os-type=linux --os-variant=ubuntu16.04 --noautoconsole
