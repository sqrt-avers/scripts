#!/bin/bash

docker build -t server-part /parse-ubuntu-instance/by_docker/serv/Dockerfile
docker build -t dashboard-part /parse-ubuntu-instance/by_docker/dash/Dockerfile
docker run -d -p 27017:27017 --link parse-server --name mongo mongo:latest
docker run -d -p 1337:1337 --link mongo --name parse-server server-part
docker run -d -p 4040:4040 --link parse-server --name parse-dashboard dashboard-part
