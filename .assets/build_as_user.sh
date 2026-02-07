#!/bin/bash -eEux
set -o pipefail
shopt -s inherit_errexit

function aptUpdate() {
    sudo apt-get update
}
function installSomeSw() {
    sudo apt-get install -y unzip wget speech-dispatcher
}
function installMoreSw() {
    sudo apt-get install -y openssh-server ca-certificates
    sudo mkdir -p /var/run/sshd

    sudo ssh-keygen -y -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    # auxiliary tools
    sudo apt-get install -y tmux vim less curl iputils-ping net-tools iproute2
    sudo apt-get install -y libgtk-3-0 x11-apps

    sudo apt-get install -y supervisor
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi

