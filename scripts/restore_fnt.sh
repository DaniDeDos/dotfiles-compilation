#!/usr/bin/env bash
#|---/ /+------------------------------------+---/ /|#
#|--/ /-| Script to extract fonts and themes |--/ /-|#
#|-/ /--| Prasanth Rangan                    |-/ /--|#
#|/ /---+------------------------------------+/ /---|#

# shellcheck disable=SC1091
# shellcheck disable=SC2002
# shellcheck disable=SC2162
# shellcheck disable=SC2154
# shellcheck disable=SC2181

scrDir=$(dirname "$(realpath "$0")")

echo "scrDir ruta: $scrDir"

source "${scrDir}/utils/global.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global.sh..."
    exit 1
fi

cat "${cloneDir}/data/restore/restore_fnt.lst" | while read lst; do

    fnt=$(echo "$lst" | awk -F '|' '{print $1}')
    tgt=$(echo "$lst" | awk -F '|' '{print $2}')
    tgt=$(eval "echo $tgt")

    if [[ "${tgt}" =~ /usr/share/ && -d /run/current-system/sw/share/ ]]; then
        echo -e "\e[38;5;4m[skipping]\e[0m ${tgt} on NixOS"
        continue
    fi

    if [ ! -d "${tgt}" ]; then
        mkdir -p "${tgt}" || echo "creating the directory as root instead..." && sudo mkdir -p "${tgt}"
        echo -e "\033[0;32m[extract]\033[0m ${tgt} directory created..."
    fi

    sudo tar -xzf "${cloneDir}/data/fonts/${fnt}.tar.gz" -C "${tgt}/"
    echo -e "\033[0;32m[extract]\033[0m ${fnt}.tar.gz --> ${tgt}..."

done

echo -e "\033[0;32m[fonts]\033[0m rebuilding font cache..."
fc-cache -f
