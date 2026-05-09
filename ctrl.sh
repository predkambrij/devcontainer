#!/bin/bash -eEux
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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # script is not sourced
    "$@"
fi
