#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/buildscript1.sh"

function installMoreSw() {
    runcmd apt-get install -y openssh-server ca-certificates
    runcmd mkdir /var/run/sshd

    runcmd ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key

    # auxiliary tools
    runcmd apt-get install -y tmux vim less curl iputils-ping net-tools iproute2
    runcmd apt-get install -y libgtk-3-0 x11-apps
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi

