#!/bin/bash

apt-get update && apt get upgrade
mkdir /home/user/solo
cd /home/gorynov/solo
# Install RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
# Install Ruby 2.3.4
rvm requirements
rvm install 2.3.4
rvm use 2.3.4 --default
# Install chef-solo
gem install chef
# Install librarian-chef for automatic dependency gathering
gem install librarian-chef
# Install knife-solo
gem install knife-solo
# configure knife
knife configure -r . --defaults
knife solo init .
# Install berkshelf
gem install berkshelf
berks init .
