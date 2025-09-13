#!/usr/bin/env sh

set -e

run_command_as_root() {
    echo "Running command as root: $@"

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

    printf "Updating package lists...\n"
    run_command_as_root apk update

    printf "Upgrading packages...\n"
    run_command_as_root apk upgrade

    printf "Installing new packages...\n"
    run_command_as_root apk add --no-cache \
        bash \
        zsh \
        curl \
        git \
        build-base \
        zlib-dev \
        zlib \
        yaml \
        yaml-dev \
        bzip2-dev \
        xz-dev \
        libffi-dev \
        ncurses-dev \
        readline-dev \
        openssl-dev \
        sqlite-dev
}

main "$@"
