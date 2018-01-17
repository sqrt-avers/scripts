#!/bin/bash

# install docker and docker-compose
curl -sSL https://get.docker.com/ | sh
curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
usermod -aG docker $USER
# create docker network
docker network create -d bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1 dockernet
