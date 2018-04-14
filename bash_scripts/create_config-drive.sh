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
