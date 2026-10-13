#!/bin/bash -eEu
set -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/conf.sh"

function genEnvExtra() {
    local dot_env_extra="${SCRIPT_DIR}/.env.extra"
    : > "$dot_env_extra"
    for var_name in "${EXTRA_ENV_KEYS[@]}"; do
        printf '%s=${%s:-}\n' "$var_name" "$var_name" >> "$dot_env_extra"
    done
}

function setSshVars() {
    SSH_USERNAME=$(grep -oP "(?<=ARG_UNAME=).*" "${SCRIPT_DIR}/.env")
    SSH_HOSTNAME="${1:-}"
    if [[ -z "$SSH_HOSTNAME" ]]; then
        local container_id=$(docker compose ps -q)
        SSH_HOSTNAME=$(docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$container_id")
    fi
}

function ssh() {
    setSshVars
    command ssh -o StrictHostKeyChecking=accept-new "$SSH_USERNAME@$SSH_HOSTNAME" "$@"
}

function sshp() {
    setSshVars
    command sshpass -p "$SSH_USERNAME" ssh -o StrictHostKeyChecking=accept-new "$SSH_USERNAME@$SSH_HOSTNAME" "$@"
}

function sshp_h() {
    setSshVars localhost
    command sshpass -p "$SSH_USERNAME" ssh -p 2022 -o StrictHostKeyChecking=accept-new "$SSH_USERNAME@$SSH_HOSTNAME" "$@"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi
