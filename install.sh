#!/usr/bin/env bash
#|-----+---------------------------------+-----#
#|-----|           Main Script           |-----#
#|-----|          by DaniDeDos           |-----#
#|-----+---------------------------------+-----#

# shellcheck disable=SC1089
# shellcheck disable=SC1129
# shellcheck disable=SC1091
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2162
# shellcheck disable=SC2181
# shellcheck disable=SC2320
# shellcheck disable=SC2046

# Imprimir Banner
cat <<"EOF"

+---------------------------------------------------------+
   _____                      _ _       _   _             
  / ____|                    (_) |     | | (_)            
 | |     ___  _ __ ___  _ __  _| | __ _| |_ _  ___  _ __  
 | |    / _ \| '_ ` _ \| '_ \| | |/ _` | __| |/ _ \| '_ \ 
 | |___| (_) | | | | | | |_) | | | (_| | |_| | (_) | | | |
  \_____\___/|_| |_| |_| .__/|_|_|\__,_|\__|_|\___/|_| |_|
                       | |                                
                       |_|                                
+---------------------------------------------------------+
 
EOF

#--------------------------------#
# Importar variables y funciones #
#--------------------------------#

# Determina el directorio actual del script
scrDir=$(dirname "$(realpath "$0")")
echo "install.sh directory: $scrDir"

# Carga todas las funciones definidas en el archivo global_fn.sh
source "${scrDir}/scripts/utils/global.sh"

# Verifica si la carga fue exitosa
if [ $? -ne 0 ]; then
     echo "Error: incapaz de cargar global.sh..."
     exit 1
fi

#------------------#
# Evaluar opciones #
#------------------#

# Inicializa banderas
flg_Install=0
flg_Restore=0
flg_Service=0

# En 1 [i] indican que el script debe proceder con la instalación de Hyprland sin configuraciones.
# [d] Similar a [i], pero también establece la variable de entorno use_default con el valor "--noconfirm" para indicar que se deben utilizar los valores predeterminados sin confirmación adicional.
# r: Establece flg_Restore en 1, indicando que el script debe restaurar archivos de configuración.
# s: Establece flg_Service en 1, habilitando servicios del sistema relacionados con Hyprland.
# *: Si se recibe una opción no reconocida, el script imprime las opciones válidas disponibles y termina con un código de salida 1, indicando un error.
while getopts idrs RunStep; do
     case $RunStep in
     i) flg_Install=1 ;;
     d)
          flg_Install=1
          export use_default="--noconfirm"
          ;;
     r) flg_Restore=1 ;;
     s) flg_Service=1 ;;
     *)
          echo "...valid options are..."
          echo "i : [i]nstall hyprland without configs"
          echo "d : install hyprland [d]efaults without configs --noconfirm"
          echo "r : [r]estore config files"
          echo "s : enable system [s]ervices"
          exit 1
          ;;
     esac
done

# si $OPTIND es igual a 1. Esto significa que solo se ha pasado una opción. En este caso, todas las banderas (flg_Install, flg_Restore, flg_Service)
# se establecen en 1, indicando que todas las acciones posibles deben ser realizadas por el script.
# si no pasa flag = 1, si pasa 1 = 2, si pasa dos flag =3 y asi;
if [ $OPTIND -eq 1 ]; then
     flg_Install=1
     flg_Restore=1
     flg_Service=1
fi

echo "OPTIND: $OPTIND"
echo "flg_Install: $flg_Install"
echo "flg_Restore: $flg_Restore"
echo "flg_Service: $flg_Service"

#----------------------------#
# Pre-instalación del script #
#----------------------------#

if [ ${flg_Install} -eq 1 ] && [ ${flg_Restore} -eq 1 ]; then

     # Otorgar permisos de ejecución al script boot.sh
     sudo chown $(whoami):$(id -gn) "${scrDir}/scripts/boot.sh"
     sudo chown $(whoami):$(id -gn) "${scrDir}/scripts/pacman.sh"

     cat <<"EOF"
  _                 _   
 | |               | |  
 | |__   ___   ___ | |_ 
 | '_ \ / _ \ / _ \| __|
 | |_) | (_) | (_) | |_ 
 |_.__/ \___/ \___/ \__|
                        
EOF

     # Cambiar el propietario del script boot.sh a root
     # chown root:root "${scrDir}/scripts/boot.sh"

     # Ejecutar el script boot.sh
     "${scrDir}/scripts/boot.sh"

     cat <<"EOF"
  _ __   __ _  ___ _ __ ___   __ _ _ __  
 | '_ \ / _` |/ __| '_ ` _ \ / _` | '_ \ 
 | |_) | (_| | (__| | | | | | (_| | | | |
 | .__/ \__,_|\___|_| |_| |_|\__,_|_| |_|
 | |                                     
 |_|                                     

EOF
     # Ejecutar el script pacman.sh
     "${scrDir}/scripts/pacman.sh"
fi

#------------#
# installing #
#------------#
if [ ${flg_Install} -eq 1 ]; then
     cat <<"EOF"

 _         _       _ _ _
|_|___ ___| |_ ___| | |_|___ ___
| |   |_ -|  _| .'| | | |   | . |
|_|_|_|___|_| |__,|_|_|_|_|_|_  |
                            |___|

EOF

     #-------------------------------#
     # Preparar la lista de paquetes #
     #-------------------------------#

     shift $((OPTIND - 1))
     cust_pkg=$1
     cp "${scrDir}/data/custom_hypr.lst" "${scrDir}/install_pkg.lst"

     if [ -f "${cust_pkg}" ] && [ ! -z "${cust_pkg}" ]; then
          cat "${cust_pkg}" >>"${scrDir}/install_pkg.lst"
     fi

     #--------------------------------#
     # add nvidia drivers to the list #
     #--------------------------------#
     if nvidia_detect; then
          cat /usr/lib/modules/*/pkgbase | while read krnl; do
               echo "${krnl}-headers" >>"${scrDir}/install_pkg.lst"
          done
          nvidia_detect --drivers >>"${scrDir}/install_pkg.lst"
     fi

     nvidia_detect --verbose

     #----------------#
     # get user prefs #
     #----------------#
     if ! chk_list "aurhlpr" "${aurList[@]}"; then
          echo -e "Available aur helpers:\n[1] yay\n[2] paru"
          prompt_timer 120 "Enter option number"

          case "${promptIn}" in
          1) export getAur="yay" ;;
          2) export getAur="paru" ;;
          *)
               echo -e "...Invalid option selected..."
               exit 1
               ;;
          esac
     fi

     if ! chk_list "myShell" "${shlList[@]}"; then
          echo -e "Select shell:\n[1] zsh\n[2] fish"
          prompt_timer 120 "Enter option number"

          case "${promptIn}" in
          1) export myShell="zsh" ;;
          2) export myShell="fish" ;;
          *)
               echo -e "...Invalid option selected..."
               exit 1
               ;;
          esac
          echo "${myShell}" >>"${scrDir}/install_pkg.lst"
     fi

     #--------------------------------#
     # install packages from the list #
     #--------------------------------#
     "${scrDir}/install_pkg.sh" "${scrDir}/install_pkg.lst"
     rm "${scrDir}/install_pkg.lst"
fi
