#!/bin/bash

set -o xtrace
set -o errexit
set -o pipefail

. "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/build_common.sh"

function prepareUser() {
    aptUpgrade
    apt-get install -y locales sudo
    locale-gen "en_US.UTF-8"

    # ubuntu 24.04 has ubuntu user with id 1000 and gid 1000
    sed -i '/^ubuntu:/d' /etc/passwd
    sed -i '/^ubuntu:/d' /etc/shadow
    rm -rf /home/ubuntu

    # prepare user
    mkdir -p /home/${ARG_UNAME}
    echo "${ARG_UNAME}:x:${ARG_UID}:${ARG_GID}:${ARG_UNAME},,,:/home/${ARG_UNAME}:/bin/bash" >> /etc/passwd
    echo "${ARG_UNAME}:x:${ARG_GID}:" >> /etc/group
    echo "${ARG_UNAME}:${ARG_UNAME}" | chpasswd
    pwconv

    cat <<'EOF' > /home/${ARG_UNAME}/.bash_login
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF

    cat <<'EOF' > /home/${ARG_UNAME}/.bashrc
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoreboth:erasedups
PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w $\[\033[00m\] '
alias ls='ls --color=auto'
export PATH=/home/${ARG_UNAME}/.mybins:${PATH}
EOF

    mkdir -p /home/${ARG_UNAME}/.ssh
    mkdir -p /home/${ARG_UNAME}/.mybins
    chown "${ARG_UID}:${ARG_GID}" -R /home/${ARG_UNAME}

    echo "${ARG_UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${ARG_UNAME}
    chmod 0440 /etc/sudoers.d/${ARG_UNAME}
}

function installSomeSw() {
    apt-get install -y unzip wget
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi

