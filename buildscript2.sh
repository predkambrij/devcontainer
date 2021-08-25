#!/usr/bin/env bash

. "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/buildscript1.sh"

function installMoreSw() {
    runcmd apt-get install -y sudo openssh-server ca-certificates
    runcmd bash -c "echo \"user ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/user"
    runcmd chmod 0440 /etc/sudoers.d/user
    runcmd mkdir /var/run/sshd
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

    runcmd apt-get install -y sudo openssh-server ca-certificates libgtk-3-0 x11-apps
    runcmd mkdir -p /home/user/.mybins

    runcmd ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key

    runcmd chown "${ARG_UID}:${ARG_GID}" /home/user
    runcmd /bin/bash -c "echo 'user:user' | chpasswd"

    # auxiliary tools
    runcmd apt-get install -y tmux vim less curl iputils-ping net-tools iproute2
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi

