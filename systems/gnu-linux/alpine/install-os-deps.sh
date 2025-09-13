#!/usr/bin/env sh

set -e

run_command_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        # Already root, run directly
        "$@"
    else
        # Not root, use sudo
        sudo "$@"
    fi
}

main() {
    printf "Installing OS-level dependencies for Alpine...\n"

    run_command_as_root apk update
    run_command_as_root apk upgrade
    run_command_as_root apk add --no-cache \
        bash \
        zsh \
        curl \
        git \
        build-base
}

main "$@"
