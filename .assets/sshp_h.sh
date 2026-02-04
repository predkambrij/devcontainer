#!/bin/bash

set -eEu -o pipefail
shopt -s inherit_errexit

dot_env=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/../.env
username=$(grep -oP "(?<=ARG_UNAME=).*" "$dot_env")
hostname=localhost
sshpass -p "$username" ssh -p 2022 -o StrictHostKeyChecking=accept-new "$username"@"$hostname" "$@"

