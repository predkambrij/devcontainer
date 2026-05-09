#!/usr/bin/env bash
set -euo pipefail

source /build/conf.sh

for var_name in "${EXTRA_ENV_KEYS[@]}"; do
  grep -q "^${var_name}=" /etc/environment || echo "${var_name}=${!var_name-}" >> /etc/environment
done

# Set up user runtime directory
if [[ -n "${ARG_UID:-}" ]]; then
  mkdir -p "/run/user/${ARG_UID}"
  chmod 700 "/run/user/${ARG_UID}"
  chown "${ARG_UID}:${ARG_GID:-${ARG_UID}}" "/run/user/${ARG_UID}"
fi

# Ensure .codex dir exists with correct ownership
mkdir -p "/home/${ARG_UNAME:-user}/.codex"
chown "${ARG_UID}:${ARG_GID:-${ARG_UID}}" "/home/${ARG_UNAME:-user}/.codex"

exec "$@"
