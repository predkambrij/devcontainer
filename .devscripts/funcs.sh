function runcmd() {
    echo "$@"
    "$@"
    if [ $((exitstatus=$?)) -ne 0 ]; then
        echo "Command '$@' failed! Exit status $exitstatus"
        exit $exitstatus
    fi
}

function _initialEcho() {
    echo "initial echo"
}

function do_echo() {
    if [[ "$SKIP_ECHO_PREFIX" != "true" ]]; then
        echo -n "prefix: "
    fi

    echo "hello world $1"
}

