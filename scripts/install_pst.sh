#!/usr/bin/env bash
#|---/ /+--------------------------------------+---/ /|#
#|--/ /-| Script to apply post install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                      |-/ /--|#
#|/ /---+--------------------------------------+/ /---|#

# shellcheck disable=SC1091
# shellcheck disable=SC2162
# shellcheck disable=SC2154
# shellcheck disable=SC2086
# shellcheck disable=SC2181

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/utils/global.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global.sh..."
    exit 1
fi

# sddm
if pkg_installed sddm; then

    echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m detected // sddm"
    if [ ! -d /etc/sddm.conf.d ]; then
        sudo mkdir -p /etc/sddm.conf.d
    fi

    if [ ! -f /etc/sddm.conf.d/kde_settings.t2.bkp ]; then
        echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m configuring sddm..."
        echo -e "Select sddm theme:\n[1] Candy\n[2] Corners"
        read -p " :: Enter option number : " sddmopt

        case $sddmopt in
        1) sddmtheme="Candy" ;;
        *) sddmtheme="Corners" ;;
        esac

        sudo tar -xzf ${cloneDir}/Source/arcs/Sddm_${sddmtheme}.tar.gz -C /usr/share/sddm/themes/
        sudo touch /etc/sddm.conf.d/kde_settings.conf
        sudo cp /etc/sddm.conf.d/kde_settings.conf /etc/sddm.conf.d/kde_settings.t2.bkp
        sudo cp /usr/share/sddm/themes/${sddmtheme}/kde_settings.conf /etc/sddm.conf.d/
    else
        echo -e "\033[0;33m[SKIP]\033[0m sddm is already configured..."
    fi

    if [ ! -f /usr/share/sddm/faces/${USER}.face.icon ] && [ -f ${cloneDir}/Source/misc/${USER}.face.icon ]; then
        sudo cp ${cloneDir}/Source/misc/${USER}.face.icon /usr/share/sddm/faces/
        echo -e "\033[0;32m[DISPLAYMANAGER]\033[0m avatar set for ${USER}..."
    fi

else
    echo -e "\033[0;33m[WARNING]\033[0m sddm is not installed..."
fi

# shell ######################################################
"${scrDir}/restore_shl.sh"

# flatpak
if ! pkg_installed flatpak; then

    echo -e "\033[0;32m[FLATPAK]\033[0m flatpak application list..."
    awk -F '#' '$1 != "" {print "["++count"]", $1}' "${scrDir}/.extra/custom_flat.lst"
    prompt_timer 60 "Install these flatpaks? [Y/n]"
    fpkopt=${promptIn,,}

    if [ "${fpkopt}" = "y" ]; then
        echo -e "\033[0;32m[FLATPAK]\033[0m intalling flatpaks..."
        "${scrDir}/.extra/install_fpk.sh"
    else
        echo -e "\033[0;33m[SKIP]\033[0m intalling flatpaks..."
    fi

else
    echo -e "\033[0;33m[SKIP]\033[0m flatpak is already installed..."
fi
