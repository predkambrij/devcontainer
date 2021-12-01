function _initialEcho() {
    echo "initial echo"
}

function do_echo() {
    if [[ "$SKIP_ECHO_PREFIX" != "true" ]]; then
        echo -n "prefix: "
    fi

    echo "hello world $1"
}

