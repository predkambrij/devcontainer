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
    runcmd apt-get install -y locales sudo
    runcmd locale-gen "en_US.UTF-8"

    # ubuntu 24.04 has ubuntu user with id 1000 and gid 1000
    runcmd sed -i '/^ubuntu:/d' /etc/passwd
    runcmd sed -i '/^ubuntu:/d' /etc/shadow

    runcmd mkdir -p /home/user
    runcmd bash -c "echo \"user:x:${ARG_UID}:${ARG_GID}:User,,,:/home/user:/bin/bash\" >> /etc/passwd"
    runcmd bash -c "echo \"user:x:${ARG_GID}:\" >> /etc/group"
    runcmd /bin/bash -c "echo 'user:user' | chpasswd"
    runcmd pwconv

    runcmd bash -c "echo \"if [ -f ~/.bashrc ]; then\" >> /home/user/.bash_login"
    runcmd bash -c "echo \"    . ~/.bashrc\" >> /home/user/.bash_login"
    runcmd bash -c "echo \"fi\" >> /home/user/.bash_login"
    runcmd bash -c "echo \". /tmp/envs.sh\" >> /home/user/.bash_login"

    runcmd bash -c "echo \"export HISTFILESIZE=\" >> /home/user/.bashrc"
    runcmd bash -c "echo \"export HISTSIZE=\" >> /home/user/.bashrc"
    runcmd bash -c "echo \"export HISTCONTROL=ignoreboth:erasedups\" >> /home/user/.bashrc"
    runcmd bash -c 'echo "PS1='\''${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '\''" >> /home/user/.bashrc'
    runcmd bash -c 'echo "alias ls='\''ls --color=auto'\''" >> /home/user/.bashrc'
    runcmd bash -c 'echo "export PATH=/home/user/.mybins:\${PATH}" >> /home/user/.bashrc'

    runcmd mkdir -p /home/user/.ssh
    runcmd mkdir -p /home/user/.mybins
    runcmd chown "${ARG_UID}:${ARG_GID}" -R /home/user

    runcmd bash -c "echo \"user ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/user"
    runcmd chmod 0440 /etc/sudoers.d/user
}

function installSomeSw() {
    runcmd apt-get install -y unzip wget
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi

