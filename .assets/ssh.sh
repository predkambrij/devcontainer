#!/bin/bash

set -eEux -o pipefail
shopt -s inherit_errexit

dot_env=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/../.env
ssh $(grep -oP "(?<=ARG_UNAME=).*" "$dot_env")@$(docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $(docker compose ps -q)) "$@"

