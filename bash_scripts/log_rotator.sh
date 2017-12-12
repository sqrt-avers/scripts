#!/bin/bash
# Script to delete the log event indices of the elasticsearch

#This will delete the indices of the last 5 days
curator --config /etc/elasticsearch/curator.yml /etc/elasticsearch/curator_actions.yml
#This script needs to move into cron directory to perform this action daily (mv log_rotator.sh /etc/cron.daily/) 
