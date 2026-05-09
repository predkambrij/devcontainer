#!/bin/bash -eEux
set -o pipefail
shopt -s inherit_errexit

function prepareUser() {
    apt-get update
    apt-get upgrade -y
    apt-get install -y locales sudo
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" >> /etc/environment
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment
    echo "LANGUAGE=en_US:en" >> /etc/environment

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
    chown "${ARG_UID}:${ARG_GID}" -R /home/${ARG_UNAME}

    echo "${ARG_UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${ARG_UNAME}
    chmod 0440 /etc/sudoers.d/${ARG_UNAME}

    # clean up the apt cache
    rm -rf /var/lib/apt/lists/*
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi

