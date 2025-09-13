#!/usr/bin/env sh

command_check() {
    if ! command -v $1 > /dev/null 2>&1; then
        printf "false"
        return 
    fi

    printf "true"
}   

mise_check() {
    command_check "mise"
}

mise_install() {
    command_check "mise"

    if [ "$(mise_check)" = "false" ]; then
        printf "!!! ERROR: mise-en-place is not installed.\n"
        exit 1
    fi

    mise trust .
    mise install
}

execute_shared_bootstrap_script() {
    exec mise exec -- deno "$(dirname "$(readlink -f "$0")")/bootstrap.mjs"
}

main() {
    printf "Hello beautiful, you're starting the bootstrap script for devenv using sh!\n"

    printf "\t>>> Tasks:\n"
    printf "\t\t- Check for mise-en-place...\n"
    printf "\t\t- Install bootstrap tools with mise-en-place...\n"
    printf "\t\t- Execute node bootstrap script...\n"

    case $(mise_check) in
        "true")
            printf "mise-en-place is installed.\n"
            ;;
        "false")
            printf "\t!!! ERROR: mise-en-place is not installed, please install it and try again => https://mise.jdx.dev\n"
            ;;
        *)
            printf "\t!!! Unknown error, please check the logs!\n"
            exit 1
            ;;
    esac

    # Make sure we are at the root of the project
    cd "$(dirname "$(readlink -f "$0")")/"
    mise_install
    execute_shared_bootstrap_script
    cd -
}

main
