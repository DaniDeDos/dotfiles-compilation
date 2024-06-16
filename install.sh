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
echo "Current directory: $scrDir"

# Carga todas las funciones definidas en el archivo global_fn.sh
source "${scrDir}/utils/global.sh"

###########/\
###########||
###########||
###########||

# Verifica si la carga fue exitosa
if [ $? -ne 0 ]; then
     echo "Error: incapaz de cargar global_fn.sh..."
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

#  si $OPTIND es igual a 1. Esto significa que solo se ha pasado una opción. En este caso, todas las banderas (flg_Install, flg_Restore, flg_Service) se establecen en 1, indicando que todas las acciones posibles deben ser realizadas por el script.
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
     cat <<"EOF"
                _         _       _ _
 ___ ___ ___   |_|___ ___| |_ ___| | |
| . |  _| -_|  | |   |_ -|  _| .'| | |
|  _|_| |___|  |_|_|_|___|_| |__,|_|_|
|_|

EOF

     "${scrDir}/scripts/install_pre.sh"
fi
