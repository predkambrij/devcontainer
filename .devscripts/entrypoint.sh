#!/usr/bin/env bash

. "/build/funcs.sh"

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

