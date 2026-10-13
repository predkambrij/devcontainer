declare -A ENV_VARS=(
    [DEVBOX_CONFIG]=devbox-base # devbox-ports or devbox-host
    [LIBGL_ALWAYS_INDIRECT]=1
    [QT_X11_NO_MITSHM]=1
    [NO_AT_BRIDGE]=1
)

EXTRA_ENV_KEYS=(
    EDITOR
    VISUAL
)

