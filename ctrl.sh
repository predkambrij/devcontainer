#!/bin/bash -eEu
set -o pipefail
shopt -s inherit_errexit

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function genEnv() {
    source "${SCRIPT_DIR}/conf.sh"
    local dot_env="${SCRIPT_DIR}/.env"
    local project_name=$(basename "$SCRIPT_DIR" | tr '[:upper:]' '[:lower:]' | tr -d '.')
    local docker_gid=$(getent group docker | cut -d: -f3)

    cat <<-EOF > "$dot_env"
		ARG_UID=$(id -u)
		ARG_GID=$(id -g)
		ARG_UNAME=$(id -un)
		ARG_GNAME=$(id -gn)
		ARG_DOCKER_GID=$docker_gid
		COMPOSE_PROJECT_NAME=$project_name
		DEVBOX_HOSTNAME=$project_name
		NETWORK_NAME=${project_name}_devbox
		DEVBOX_ROOT=$(realpath "$SCRIPT_DIR")/
		EOF
    for var_name in "${!ENV_VARS[@]}"; do
        printf '%s=%s\n' "$var_name" "${ENV_VARS[$var_name]}" >> "$dot_env"
    done
}

function genEnvExtra() {
    source "${SCRIPT_DIR}/conf.sh"
    local dot_env_extra="${SCRIPT_DIR}/.env.extra"
    : > "$dot_env_extra"
    for var_name in "${EXTRA_ENV_KEYS[@]}"; do
        printf '%s=${%s:-}\n' "$var_name" "$var_name" >> "$dot_env_extra"
    done
}

# ssh
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
