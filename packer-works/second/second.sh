#!/bin/bash

# Install other soft
rpm -ivh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
yum -y update
yum -y install wget net-tools nano curl sudo

# Add vagrant user to sudo
#usermod -aG wheel vagrant
echo 'vagrant ALL=NOPASSWD:ALL' >> /etc/sudoers

# Installing vagrant keys
mkdir /home/vagrant/.ssh
touch /home/vagrant/.ssh/authorized_keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJakNhS+97RIhEzO54XY7kU8MgulBtoMWUj2H91Ft4vqpnVVSjA7Fbn9T3WQD+gFzKrZWHVkLd8PwVVAz9q4+yFGc4RDhhFXjGv8+GAGQJHBnTCCXcgPocCfeuHFGbPazMbQq1wL3jGx2BZOxQCpTQEMMUmQrjlHpMaSNeZF7X2eqH/j8zwlk2wKR6teKDBlr+Y581r78avy9nJQ+BczWITgiVKsdo/eQeiwW8yYEglac6sAEDK2mVSan8mciCMf+eO930fg792okRAez2sFv5kjeULawS5Cf01bFJBe+V7rkmsALIeiMpbmDj+tIr4B00v3QIoM5OopGC0ZqvjZCh gorynov@chi-079214' >> /home/vagrant/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBO21gYShSoFFd4JRHiKtkEUOP2FXFBlAg6yim02qZGDFLcrhNWlA32PUaiCBQDlV1/PivK1UDBdhDh5WDmjAptYPByy+WXz3PvlwIqO6aqzi194LMMnbf0fUnqfitb7RPPJ0K/gGzgqGCVgeGvCYgJgWPM7uLBRyOf54nRnR24CerLneY0JVzA03n3TqblMkChFmvkid1eO4ky+6IQj/60qw84YIGocn9MkJ5HU6xMGk0FhIy5hPohfs1gn6O0xbzbQE4qX7VzzTfKzGYRvY/jBM7ehQo1YY+4PowWpr7Tb7EdZvWxxMNqbtqCPFpZc0sLD8KTydEIFzdqix9uiiJ root@chi-079214' >> /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
