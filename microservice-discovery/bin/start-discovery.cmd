@echo off
set localdir=%~dp0

start cmd /k java -jar ..\target\microservice-discovery-1.0.jar --spring.profiles.active=peer1

start cmd /k java -jar ..\target\microservice-discovery-1.0.jar --spring.profiles.active=peer2