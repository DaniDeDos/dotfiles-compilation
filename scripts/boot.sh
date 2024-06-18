#!/usr/bin/env bash

# shellcheck disable=SC1091
# shellcheck disable=SC2181
# shellcheck disable=SC2154
# shellcheck disable=SC2086
# shellcheck disable=SC2162
# shellcheck disable=SC2046
# shellcheck disable=SC2012
# shellcheck disable=SC2320
# shellcheck disable=SC1072
# shellcheck disable=SC1035
# shellcheck disable=SC2034
# shellcheck disable=SC1083
# shellcheck disable=SC2090

# Determinación del Directorio del Script:
scrDir=$(dirname "$(realpath "$0")")
grub_screen=1080p

# Carga de Funciones Globales:
source "${scrDir}/utils/global.sh"
echo "global.sh directory: $scrDir"

# Verificación de Éxito:
if [ $? -ne 0 ]; then
    echo "Error: incapaz de cargar global_fn.sh..."
    exit 1
fi

configure_grub() {

    echo -e "\033[0;32m[BOOTLOADER]\033[0m configurando el grub..."
    sudo cp /etc/default/grub /etc/default/grub.t2.bkp
    sudo cp /boot/grub/grub.cfg /boot/grub/grub.t2.bkp

    # Deteción de NVIDIA y Modificación de la Configuración.
    if nvidia_detect; then
        echo -e "\033[0;32m[BOOTLOADER]\033[0m nvidia detected, adding nvidia_drm.modeset=1 to boot option..."
        gcld=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" | cut -d'"' -f2 | sed 's/\b nvidia_drm.modeset=.\b//g')
        sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"${gcld} nvidia_drm.modeset=1\"" /etc/default/grub
        grub_screen=4k
    fi

    # Elegir un tema para GRUB:
    echo -e "Seleccione un tema para el GRUB:\n[1] tela\n[2] vimix\n[3] stylish\n"
    read -p " :: Press enter to skip grub theme <or> Enter option number : " grubopt
    case ${grubopt} in
    1) grubtheme="tela" ;;
    2) grubtheme="vimix" ;;
    3) grubtheme="stylish" ;;
    *) grubtheme="None" ;;
    esac

    if [ "${grubtheme}" == "None" ]; then
        echo -e "\033[0;32m[BOOTLOADER]\033[0m Saltándose el tema grub..."
        sudo sed -i "s/^GRUB_THEME=/#GRUB_THEME=/g" /etc/default/grub
    else
        echo -e "\033[0;32m[BOOTLOADER]\033[0m configurando grub theme // ${grubtheme}"

        create_tempPath

        # Extraer el archivo.tar.gz en el directorio especificado
        tar -xzf ${cloneDir}/data/arcs/grub/grub2-themes-master.tar.gz -C $HOME/repos/temp/
        chmod +x $HOME/repos/temp/grub2-themes-master/install.sh

        bash $HOME/repos/temp/grub2-themes-master/install.sh -t $grubtheme -s $grub_screen

        # Eliminar la carpeta con los archivos del tema GRUB.
        rm -rf $HOME/repos/temp/grub2-themes-master

    fi
}

# grub
if pkg_installed grub && [ -f /boot/grub/grub.cfg ]; then
    echo -e "\033[0;32m[BOOTLOADER]\033[0m detected // grub"

    # Antes de modificar la configuración de GRUB, el script crea copias de seguridad de los archivos relevantes:
    if [ ! -f /etc/default/grub.t2.bkp ] && [ ! -f /boot/grub/grub.t2.bkp ]; then
        configure_grub
    else
        echo -e "\033[0;33m[SKIP]\033[0m el grub ya está configurado..."

        # Pregunta al usuario si desea reconfigurar GRUB
        read -p "El GRUB ya está configurado, ¿desea reconfigurar? (s/n): " resp
        if [[ $resp =~ ^([sS])$ ]]; then
            configure_grub
        fi

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
