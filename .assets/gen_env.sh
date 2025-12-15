#!/bin/bash

set -o errexit
set -o pipefail

COMPOSE_PROJECT_NAME=$(basename $(realpath $(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/../) | tr '[:upper:]' '[:lower:]' | tr -d '.')
dot_env=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/../.env

cat <<EOF > "$dot_env"
ARG_UID=$(id -u)
ARG_GID=$(id -g)
ARG_UNAME=$(id -un)
ARG_GNAME=$(id -gn)
COMPOSE_PROJECT_NAME=$COMPOSE_PROJECT_NAME
DEVBOX_HOSTNAME=$COMPOSE_PROJECT_NAME
NETWORK_NAME=${COMPOSE_PROJECT_NAME}_devbox
DEVBOX_ROOT=$(realpath $(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/../)/
EOF
