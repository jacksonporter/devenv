#!/usr/bin/env sh

set -e

ROOT_LOCATION="$(dirname "$(readlink -f "$0")")/../"
WORKDIR_LOCATION="/workdir"
BOOTSTRAP_SCRIPT_LOCATION="${WORKDIR_LOCATION}/bootstrap.sh"

run_container() {
    image=$1
    shift
    precommands=$@

    full_command=$(cat <<EOT
podman \
    run \
        -it \
        -v "${ROOT_LOCATION}:${WORKDIR_LOCATION}" \
        --workdir ${WORKDIR_LOCATION} \
        --entrypoint /bin/sh \
        ${image} \
        -c "${precommands} && zsh -c 'source /root/.zshrc && ${BOOTSTRAP_SCRIPT_LOCATION}'"
EOT
)
    printf ">>> Running container with command:\n%s\n" "${full_command}"
    sh -c "${full_command}"
}

alpine() {
    printf ">>> Running bootstrap in alpine container...\n"
    run_container "alpine:latest" "apk add curl bash zsh && zsh -c 'curl https://mise.run/zsh | sh'"
}

ubuntu() {
    printf ">>> Running bootstrap in ubuntu container...\n"
    run_container "ubuntu:latest" "apt-get update && apt-get install -y curl zsh && zsh -c 'curl https://mise.run/zsh | sh'"
}

debian() {
    printf ">>> Running bootstrap in debian container...\n"
    run_container "debian:latest" "apt-get update && apt-get install -y curl zsh && zsh -c 'curl https://mise.run/zsh | sh'"
}

fedora() {
    printf ">>> Running bootstrap in fedora container...\n"
    run_container "fedora:latest" "dnf install -y curl zsh && zsh -c 'curl https://mise.run/zsh | sh'"
}

amazonlinux() {
    printf ">>> Running bootstrap in amazonlinux container...\n"
    run_container "amazonlinux:latest" "yum install -y curl zsh && zsh -c 'curl https://mise.run/zsh | sh'"
}

rhel() {
    printf ">>> Running bootstrap in rhel container...\n"
    run_container "registry.access.redhat.com/ubi8/ubi:latest" "yum install -y curl zsh && zsh -c 'curl https://mise.run/zsh | sh'"
}

main() {
    printf ">>> Starting tests for bootstrap in linux containers...\n"

    alpine
    ubuntu
    debian
    fedora
    amazonlinux
    rhel

    printf ">>> Finished testing bootstrap in linux containers!\n"
}

main $@
