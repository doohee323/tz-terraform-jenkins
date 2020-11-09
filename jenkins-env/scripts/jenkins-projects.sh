#!/bin/bash

PROJECT_NAME=$1

mkdir -p /var/lib/jenkins/jobs/${PROJECT_NAME}
mv /home/ubuntu/config.xml /var/lib/jenkins/jobs/${PROJECT_NAME}/config.xml
chown -Rf jenkins:jenkins /var/lib/jenkins/jobs

mkdir -p /var/lib/jenkins/workspace/${PROJECT_NAME}
chown -Rf jenkins:jenkins /var/lib/jenkins/workspace




