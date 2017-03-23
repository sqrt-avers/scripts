#!/bin/bash

#SSH

scp user@ip:/usr/root/.ssh/key.pub /home/user/.ssh/
echo /home/user/.ssh/key.pub >> /home/user/.ssh/authorized_keys

sed -i -r 's/^#?(PermitRootLogin|PermitEmptyPasswords|PasswordAuthentication|X11Forwarding) yes/\1 no/' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 5522/g' /etc/ssh/sshd_config

#Check version
gcc --version > /home/user/test_verv.txt

if grep "Red Hat" /home/user/test_vers.txt
then
sh /home/user/centos.sh
else
sh /home/user/ubuntu.sh
fi


