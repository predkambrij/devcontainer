#!/usr/bin/env bash

function runcmd() {
    echo "$@"
    "$@"
    if [ $((exitstatus=$?)) -ne 0 ]; then
        echo "Command '$@' failed! Exit status $exitstatus"
        exit $exitstatus
    fi
}

function prepareUser() {
    runcmd apt-get update
    runcmd apt-get upgrade -y
    runcmd apt-get install -y locales
    runcmd locale-gen "en_US.UTF-8"
    runcmd mkdir -p /home/user
    runcmd bash -c "echo \"user:x:${ARG_UID}:${ARG_GID}:User,,,:/home/user:/bin/bash\" >> /etc/passwd"
    runcmd bash -c "echo \"user:x:${ARG_GID}:\" >> /etc/group"
    runcmd chown "${ARG_UID}:${ARG_GID}" -R /home/user
}

function installSomeSw() {
    runcmd apt-get install -y unzip wget
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi

