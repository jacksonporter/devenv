#!/usr/bin/env sh

set -e

install_bootstrap_core() {
    cd "$(dirname "$(readlink -f "$0")")/bootstrap/core"
    mise trust .
    mise install
}

linux() {
    release_name=$(cat /etc/os-release | grep '^ID=' | sed 's/^ID=//g' | tr -d '"')
    

    case "${release_name}" in
        alpine)
            system_directory="$(dirname "$(readlink -f "$0")")/systems/gnu-linux/alpine/"
            ;;
        *)
            echo "Unsupported distribution: ${release_name}"
            exit 1
            ;;
    esac

    cd "${system_directory}"
    ./install-os-deps.sh
    cd -
}

main() {
    case $(uname -s) in
        Linux)
            linux "$@"
            ;;
        *)
            echo "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}

main "$@"
