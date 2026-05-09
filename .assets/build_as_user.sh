#!/bin/bash -eEux
set -o pipefail
shopt -s inherit_errexit

function aptUpdate() {
    sudo apt-get update
}
function installSomeSw() {
    sudo apt-get install -y unzip wget speech-dispatcher git zip
}
function installMoreSw() {
    sudo apt-get install -y openssh-server ca-certificates
    sudo mkdir -p /var/run/sshd

    sudo ssh-keygen -y -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    # auxiliary tools
    sudo apt-get install -y tmux vim less curl iputils-ping net-tools iproute2
    sudo apt-get install -y libgtk-3-0t64 x11-apps

    sudo apt-get install -y supervisor

    # for codex
    sudo apt-get install -y bubblewrap ripgrep
}

function installDockerClient() {
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    local CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list

    sudo apt-get update
    sudo apt-get install -y docker-ce-cli

    sudo groupadd -g ${ARG_DOCKER_GID} docker
    sudo usermod -a -G docker $ARG_UNAME
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi

