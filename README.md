# Description
This repository contains scripts that make it easy to start working on random projects, without contaminating host computer.

    ./ctrl.sh -h # Run this to see all available commands

# Examples

## Build Docker image that'll be used for Docker containers
- ./ctrl.sh build
  - note that it's not necessary to run this first, because it's implied with ./ctrl.sh start

## Build and run container
- ./ctrl.sh start # start container(s)
- ./ctrl.sh logs # follow logs (stdout in docker containers). Press Ctrl+C to exit.
- ./ctrl.sh kill # to stop and delete running containers.

## Connect to the container
- ./ctrl.sh printForHosts # print entry, that can be added to /etc/hosts (eg. 172.27.0.2 devbox)
- ssh user@devbox # password is user
  - now you can run commands inside the container eg. xeyes

## Run some command in container (initiated from host machine)
- ./ctrl.sh runCommand # see ctrl.sh source to use it for something repeatable

## Other info
- you can override some settings or make like specified options are enabled by default
- cp settingsOverride.sample.sh settingsOverride.sh

