#!/usr/bin/env bash

# shellcheck disable=SC1091
# shellcheck disable=SC2181
# shellcheck disable=SC2154
# shellcheck disable=SC2086
# shellcheck disable=SC2162
# shellcheck disable=SC2046
# shellcheck disable=SC2012
# shellcheck disable=SC2320

# Determinación del Directorio del Script:
scrDir=$(dirname "$(realpath "$0")")

# Carga de Funciones Globales:
source "${scrDir}/utils/global.sh"
echo "global.sh directory: $scrDir"

# Verificación de Éxito:
if [ $? -ne 0 ]; then
    echo "Error: incapaz de cargar global_fn.sh..."
    exit 1
fi

# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]; then
    echo -e "\033[0;32m[PACMAN]\033[0m adding extra spice to pacman..."

    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    sudo pacman -Syyu
    sudo pacman -Fy

else
    echo -e "\033[0;33m[SKIP]\033[0m pacman is already configured..."
fi
