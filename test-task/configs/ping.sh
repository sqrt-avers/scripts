#!/bin/bash

ping 192.168.156.101 -c 4 > /var/lib/jenkins/hello.txt
if grep -q Host /var/lib/jenkins/hello.txt
then
exit 1
fi
