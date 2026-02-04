#!/bin/bash

set -eEu -o pipefail
shopt -s inherit_errexit

dot_env=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/../.env
username=$(grep -oP "(?<=ARG_UNAME=).*" "$dot_env")
hostname=$(docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $(docker compose ps -q))
ssh -o StrictHostKeyChecking=accept-new "$username"@"$hostname" "$@"

