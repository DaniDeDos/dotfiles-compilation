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
source "${scrDir}/global.sh"
echo "install_pre directory: $scrDir"

# Verificación de Éxito:
if [ $? -ne 0 ]; then
    echo "Error: incapaz de cargar global_fn.sh..."
    exit 1
fi

# grub
# Verificación de GRUB Instalado y Configuración Existente
# fucion pkg_installed en global_fn, Verifica si el paquete grub está instalado en el sistema
# [ -f /boot/grub/grub.cfg ]: Comprueba si existe un archivo de configuración de GRUB válido en /boot/grub/grub.cfg.
# Si ambas condiciones son verdaderas, el script procede a configurar GRUB. De lo contrario, 
# simplemente avisa que GRUB ya está configurado y omite el resto del bloque de código.
if pkg_installed grub && [ -f /boot/grub/grub.cfg ]; then
    echo -e "\033[0;32m[BOOTLOADER]\033[0m detected // grub"

    # Antes de modificar la configuración de GRUB, el script crea copias de seguridad de los archivos relevantes:
    if [ ! -f /etc/default/grub.t2.bkp ] && [ ! -f /boot/grub/grub.t2.bkp ]; then
        echo -e "\033[0;32m[BOOTLOADER]\033[0m configuring grub..."
        sudo cp /etc/default/grub /etc/default/grub.t2.bkp
        sudo cp /boot/grub/grub.cfg /boot/grub/grub.t2.bkp

        # Deteción de NVIDIA y Modificación de la Configuración
        # fucion pkg_installed en global_fn,  verifica si el sistema tiene una tarjeta gráfica NVIDIA. Si es así, el script añade nvidia_drm.modeset=1 a las opciones de arranque de GRUB para mejorar el soporte de la GPU.
        if nvidia_detect; then
            echo -e "\033[0;32m[BOOTLOADER]\033[0m nvidia detected, adding nvidia_drm.modeset=1 to boot option..."
            gcld=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" | cut -d'"' -f2 | sed 's/\b nvidia_drm.modeset=.\b//g')
            sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"${gcld} nvidia_drm.modeset=1\"" /etc/default/grub
        fi

        # El script ofrece al usuario elegir un tema para GRUB:
        echo -e "Select grub theme:\n[1] Ghibli (dark)\n[2] Pochita (light)"
        read -p " :: Press enter to skip grub theme <or> Enter option number : " grubopt
        case ${grubopt} in
        1) grubtheme="Retroboot" ;;
        2) grubtheme="Pochita" ;;
        *) grubtheme="None" ;;
        esac

        if [ "${grubtheme}" == "None" ]; then
            echo -e "\033[0;32m[BOOTLOADER]\033[0m Skippinng grub theme..."
            sudo sed -i "s/^GRUB_THEME=/#GRUB_THEME=/g" /etc/default/grub
        else
            echo -e "\033[0;32m[BOOTLOADER]\033[0m Setting grub theme // ${grubtheme}"

            sudo tar -xzf ${cloneDir}/Source/arcs/Grub_${grubtheme}.tar.gz -C /usr/share/grub/themes/
            sudo sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
            /^GRUB_GFXMODE=/c\GRUB_GFXMODE=1280x1024x32,auto
            /^GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
            /^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
            /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" /etc/default/grub
        fi

        # el script aplica los cambios a la configuración de GRUB y genera un nuevo archivo de configuración:
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo -e "\033[0;33m[SKIP]\033[0m grub is already configured..."
    fi
fi

# systemd-boot
if pkg_installed systemd && nvidia_detect && [ $(bootctl status 2>/dev/null | awk '{if ($1 == "Product:") print $2}') == "systemd-boot" ]; then
    echo -e "\033[0;32m[BOOTLOADER]\033[0m detected // systemd-boot"

    if [ $(ls -l /boot/loader/entries/*.conf.t2.bkp 2>/dev/null | wc -l) -ne $(ls -l /boot/loader/entries/*.conf 2>/dev/null | wc -l) ]; then
        echo "nvidia detected, adding nvidia_drm.modeset=1 to boot option..."
        find /boot/loader/entries/ -type f -name "*.conf" | while read imgconf; do
            sudo cp ${imgconf} ${imgconf}.t2.bkp
            sdopt=$(grep -w "^options" ${imgconf} | sed 's/\b quiet\b//g' | sed 's/\b splash\b//g' | sed 's/\b nvidia_drm.modeset=.\b//g')
            sudo sed -i "/^options/c${sdopt} quiet splash nvidia_drm.modeset=1" ${imgconf}
        done
    else
        echo -e "\033[0;33m[SKIP]\033[0m systemd-boot is already configured..."
    fi
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
