COMPOSE_PROJECT_NAME=$(basename $(realpath $(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/) | tr '[:upper:]' '[:lower:]')
NETWORK_NAME=devbox

overrideScript=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/settingsOverride.sh
if [ -f "$overrideScript" ]; then
    echo "Loading $overrideScript"
    . "$overrideScript"
fi

