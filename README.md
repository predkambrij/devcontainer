# Description
This repository contains scripts that makes it easy to start working on random projects without installing a bunch of dependencies on the host computer.

## generate .env

    .assets/gen_env.sh

## build

    docker compose build


## create network if it doesn't exist yet

    bash -c '. .env; docker network ls --format "{{.Name}}" | grep -Fxq "${NETWORK_NAME}" || docker network create "${NETWORK_NAME}"'

## start the container

    docker compose up -d

# SSH

By default password is equal to username. You can change it, or remove it and use ssh key.

## ssh to the container

    .assets/ssh.sh

## other ways to ssh

### using hoster
[dvddarias/docker-hoster](https://github.com/dvddarias/docker-hoster) will insert container name in `/etc/hosts` so you can `ssh $USER@<containername>` which is handy because you can ssh from any directory (just run `docker ps -a` first to get container name)

### using dnsdock with dnsmasq
[aacebedo/dnsdock](https://github.com/aacebedo/dnsdock) provides DNS resolution.

Start the following

    docker run --restart=unless-stopped -d -v /var/run/docker.sock:/var/run/docker.sock --name dnsdock -p 127.0.1.53:53:53/udp aacebedo/dnsdock:v1.17.0-amd64 -v --domain=docker

Add the following to `/etc/dnsmasq.conf`

    server=/docker/127.0.1.53

Then you can add to ssh config (example):

    Host devbox_test-devbox-1
        Hostname devbox_devbox_test.docker

Then ssh:

    ssh devbox_test-devbox-1

## ssh to devcontainer on another machine
You can uncomment ports section and `~/.Xauthority` section in docker-compose.yml and do the following

    ssh -Y -p 2022 $USER@<hostmachine>

