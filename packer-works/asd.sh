#!/bin/bash

# Add vagrant user to sudo
usermod -a -G sudo vagrant
echo 'vagrant ALL=NOPASSWD:ALL' >> /etc/sudoers

# Installing vagrant keys
mkdir /home/vagrant/.ssh
touch /home/vagrant/.ssh/authorized_keys
echo 'your_ssh_pub_key' > /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Install other soft
apt-get -y update
apt-get -y install apache2
