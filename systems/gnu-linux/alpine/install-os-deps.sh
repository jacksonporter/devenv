#!/usr/bin/env sh

set -e

main() {
    apk update
    apk upgrade -y
    apk add --no-cache \
        bash \
        zsh \
        curl \
        git
}

main $@
