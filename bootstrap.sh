#!/usr/bin/env sh

main() {
    release_name=$(cat /etc/os-release | grep '^ID=' | sed 's/^ID=//g' | tr -d '"')

    echo "Detected OS: ${release_name}"
}

main $@
