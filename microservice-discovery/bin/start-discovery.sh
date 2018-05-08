#! /bin/bash

nohup java -jar microservice-discovery-1.0.jar --spring.profiles.active=peer1 > /opt/logs/service-discovery.log 2>&1 &