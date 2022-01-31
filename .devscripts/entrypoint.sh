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
    echo "export LIBGL_ALWAYS_INDIRECT=$LIBGL_ALWAYS_INDIRECT" >> /tmp/envs.sh
    echo "export QT_X11_NO_MITSHM=$QT_X11_NO_MITSHM" >> /tmp/envs.sh
    echo "export NO_AT_BRIDGE=$NO_AT_BRIDGE" >> /tmp/envs.sh

    sleep infinity
else
    "$@"
fi

if [ "$SLEEP_INIT" == "true" ]; then
    echo "$(date) \$SLEEP_INIT enabled, waiting indefinetly..."
    sleep infinity
fi

