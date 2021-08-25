#!/usr/bin/env bash

function usage() {
    echo "\
Manages building and running Docker containers for general development.

COMMANDS
./ctrl.sh build
    Generate .env and build Docker image. It is not necessary
    to run this command first, because it's implied with ./ctrl.sh start.

./ctrl.sh start [OPTIONS]
Starts the container(s).

Options:
-E, --skipEchoPrefix  Test option.
-e, --echoValue=value Test option with value.
-h, --help           Print this help

./ctrl.sh kill
    Stop and delete running containers (started with ./ctrl.sh start). It won't delete Docker image, volumes or any mounted data.

./ctrl.sh logs
    Show and follow logs of the running containers. Press Ctrl+C to exit.

./ctrl.sh runCommand [OPTIONS]
    Run command.

Options:
-E, --skipEchoPrefix  Test option.
-e, --echoValue=value Test option with value.
-h, --help            Print this help
"
}

function build() {
    # load settings
    . "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/settings.sh"

    _genDotEnv

    echo -e "\nBuilding Docker image..."
    docker-compose build
}

function start() {
    # load settings
    . "$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/settings.sh"

    # parse options (may override settings)
    while :; do
        case $1 in
            -E|--skipEchoPrefix)
                skipEchoPrefix=true
                ;;
            -e=?*|--echoValue=?*)
                echoValue=${1#*=} # Delete everything up to "=" and assign the remainder.
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            ?*)
                printf 'WARN: Unknown option (ignored): %s\n' "$1"
                ;;
            *) # Default case: No more options, so break out of the loop.
                break
        esac
        shift
    done

    _genDotEnv
    _createDockerNetworkIfNotExists ${COMPOSE_PROJECT_NAME}_${NETWORK_NAME}

    time docker-compose up --force-recreate --build -d
}

function kill() {
    docker-compose down -t 0
}

function logs() {
    docker-compose logs --tail=50 -f
}

function runCommand() {
    # parse options (overrides settings)
    while :; do
        case $1 in
            -E|--skipEchoPrefix)
                skipEchoPrefix=true
                ;;
            -e=?*|--echoValue=?*)
                echoValue=${1#*=} # Delete everything up to "=" and assign the remainder.
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            ?*)
                printf 'WARN: Unknown option (ignored): %s\n' "$1"
                ;;
            *) # Default case: No more options, so break out of the loop.
                break
        esac
        shift
    done

    envs="export SKIP_ECHO_PREFIX=${skipEchoPrefix:-false};"
    docker-compose exec devbox bash -c "$envs . /build/funcs.sh; do_echo ${echoValue:-foo}"
}

function _createDockerNetworkIfNotExists() {
    echo $1
    if [ 1 -eq $(docker network ls -f name=$1 | wc -l) ]; then # lists title only
        docker network create "$1"
    fi
}

function _genDotEnv() {
    dot_env=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/.env
    echo -n "" > "${dot_env}"
    # build on the fly
    echo "ARG_UID=$(id -u)" >> "${dot_env}"
    echo "ARG_GID=$(id -g)" >> "${dot_env}"
    echo "COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME:-devbox}" >> "${dot_env}"
    echo "DEVBOX_HOSTNAME=${DEVBOX_HOSTNAME:-devbox}" >> "${dot_env}"
    echo "NETWORK_NAME=$NETWORK_NAME" >> "${dot_env}"
    echo "DEVBOX_ROOT=$(realpath ./)/" >> "${dot_env}"
    echo "SKIP_ECHO_PREFIX=${skipEchoPrefix:-false}" >> "${dot_env}"
    echo "ECHO_VALUE=${echoValue:-foo}" >> "${dot_env}"

    echo "Generated .env:"
    cat "${dot_env}"
}

if ! [[ -z "$@" ]]; then
    if [[ "$1" == "build" ]] || [[ "$1" == "start" ]] || [[ "$1" == "logs" ]] || [[ "$1" == "kill" ]] || [[ "$1" == "runCommand" ]]; then
        "$@"
    else
        usage
        exit 0
    fi
else
    usage
fi

