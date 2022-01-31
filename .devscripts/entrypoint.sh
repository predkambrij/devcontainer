#!/usr/bin/env bash

. "/build/.devscripts/funcs.sh"

if [ -f "/build/.devscripts/override/sshd_config" ]; then
    runcmd sudo cp /build/.devscripts/override/sshd_config /etc/ssh/sshd_config
fi

if [ -z "$@" ]; then
    sudo /usr/sbin/service rsyslog start
    sudo /usr/sbin/service ssh start

    if [[ "$SKIP_ECHO" != "true" ]]; then
        do_echo $ECHO_VALUE
    fi

    echo -n > /tmp/envs.sh
    echo "export DISPLAY=$DISPLAY" >> /tmp/envs.sh

    sleep infinity
else
    "$@"
fi

if [ "$SLEEP_INIT" == "true" ]; then
    echo "$(date) \$SLEEP_INIT enabled, waiting indefinetly..."
    sleep infinity
fi

