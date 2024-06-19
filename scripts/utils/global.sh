#!/usr/bin/env bash
#|-----+---------------------------------+-----#
#|-----|           Global Functions      |-----#
#|-----|          by DaniDeDos           |-----#
#|-----+---------------------------------+-----#

# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2162
# shellcheck disable=SC2163
# shellcheck disable=SC2181
# shellcheck disable=SC2086
# shellcheck disable=SC2317

set -e

scrDir="$(dirname "$(realpath "$0")")"
cloneDir="$(dirname "${scrDir}")"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
cacheDir="$HOME/.cache/compilation"
aurList=(yay paru)

# Verifica si un paquete específico está instalado.
pkg_installed() {
    local PkgIn=$1

    if pacman -Qi "${PkgIn}" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Verifica si un paquete específico está disponible para instalar.
pkg_available() {
    local PkgIn=$1

    if pacman -Si "${PkgIn}" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

grub_detect() {
    readarray -t dGPU < <(lspci -k | grep -E "(VGA|3D)" | awk -F ': ' '{print $NF}')
    if [ "${1}" == "--verbose" ]; then
        for indx in "${!dGPU[@]}"; do
            echo -e "\033[0;32m[gpu$indx]\033[0m detected // ${dGPU[indx]}"
        done
        return 0
    fi
    if [ "${1}" == "--drivers" ]; then
        while read -r -d ' ' nvcode; do
            awk -F '|' -v nvc="${nvcode}" 'substr(nvc,1,length($3)) == $3 {split(FILENAME,driver,"/"); print driver[length(driver)],"\nnvidia-utils"}' "${scrDir}"/.nvidia/nvidia*dkms
        done <<<"${dGPU[@]}"
        return 0
    fi
    if grep -iq nvidia <<<"${dGPU[@]}"; then
        return 0
    else
        return 1
    fi
}

chk_list() {
    vrType="$1"
    local inList=("${@:2}")
    for pkg in "${inList[@]}"; do
        if pkg_installed "${pkg}"; then
            printf -v "${vrType}" "%s" "${pkg}"
            export "${vrType}"
            return 0
        fi
    done
    return 1
}

aur_available() {
    local PkgIn=$1

    if ${aurhlpr} -Si "${PkgIn}" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

nvidia_detect() {
    readarray -t dGPU < <(lspci -k | grep -E "(VGA|3D)" | awk -F ': ' '{print $NF}')
    if [ "${1}" == "--verbose" ]; then
        for indx in "${!dGPU[@]}"; do
            echo -e "\033[0;32m[gpu$indx]\033[0m detected // ${dGPU[indx]}"
        done
        return 0
    fi
    if [ "${1}" == "--drivers" ]; then
        while read -r -d ' ' nvcode; do
            awk -F '|' -v nvc="${nvcode}" 'substr(nvc,1,length($3)) == $3 {split(FILENAME,driver,"/"); print driver[length(driver)],"\nnvidia-utils"}' "${scrDir}"/.nvidia/nvidia*dkms
        done <<<"${dGPU[@]}"
        return 0
    fi
    if grep -iq nvidia <<<"${dGPU[@]}"; then
        return 0
    else
        return 1
    fi
}

prompt_timer() {
    set +e
    unset promptIn
    local timsec=$1
    local msg=$2
    while [[ ${timsec} -ge 0 ]]; do
        echo -ne "\r :: ${msg} (${timsec}s) : "
        read -t 1 -n 1 promptIn
        [ $? -eq 0 ] && break
        ((timsec--))
    done
    export promptIn
    echo ""
    set -e
}

create_tempPath() {
    # Crea el directorio temporal si no existe
    mkdir -p $HOME/repos/temp
}
