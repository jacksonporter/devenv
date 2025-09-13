#!/usr/bin/env sh

set -e

ROOT_LOCATION="$(dirname "$(readlink -f "$0")")/../"
WORKDIR_LOCATION="/workdir"
BOOTSTRAP_SCRIPT_LOCATION="${WORKDIR_LOCATION}/bootstrap.sh"

test_container() {
    image_platform=$1
    image_tag=$2

    full_command=$(cat <<EOT
podman \
    run \
        --platform "${image_platform}" \
        --rm \
        -it \
        --security-opt seccomp=unconfined \
        -v "${ROOT_LOCATION}:${WORKDIR_LOCATION}" \
        --workdir ${WORKDIR_LOCATION} \
        --entrypoint /bin/zsh \
        ${image_tag} \
        -c 'curl https://mise.run/zsh | sh && source ~/.zshrc && ${BOOTSTRAP_SCRIPT_LOCATION}'
EOT
)
    printf ">>> Running container with command:\n%s\n" "${full_command}"
    sh -c "${full_command}"
}

build_container() {
    image_platform=$1
    image_tag=$2

    full_command=$(cat <<EOT
podman \
    build \
        --platform "${image_platform}" \
        -t ${image_tag} \
        -f Containerfile.base .
EOT
)
    printf ">>> Building container with command:\n%s\n" "${full_command}"
    sh -c "${full_command}"
}

test_distro() {
    distro=$1
    printf ">>> Testing distro: %s\n" "${distro}"

    cd "${ROOT_LOCATION}/systems/gnu-linux/${distro}" || exit 1
    image_platform="linux/${linux_arch}"
    image_tag="devenv-test-${distro}-${linux_arch}"
    
    build_container "${image_platform}" "${image_tag}"
    test_container "${image_platform}" "${image_tag}"
    cd -

    printf ">>> Finished testing distro: %s\n" "${distro}"
}

main() {
    printf ">>> Starting tests for bootstrap in linux containers...\n"

    for distro in alpine; do
        test_distro "${distro}"
    done

    printf ">>> Finished testing bootstrap in linux containers!\n"
}

main $@
