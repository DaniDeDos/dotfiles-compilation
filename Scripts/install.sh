#!/usr/bin/env bash
#|-----+--------------------------+--------/\#
#|-----| Script principal de instalación +-|-#
#|-----| by DaniDeDos                    +-|-#
#|-----+--------------------------+--------|-#

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

-------------------------------------------------
 __      __   _ _                  _______          _     
 \ \    / /  | | |           _    |__   __|        | |    
  \ \  / /__ | | |_ __ _   _| |_     | | ___   ___ | |___ 
   \ \/ / _ \| | __/ _` | |_   _|    | |/ _ \ / _ \| / __|
    \  / (_) | | || (_| |   |_|      | | (_) | (_) | \__ \
     \/ \___/|_|\__\__,_|            |_|\___/ \___/|_|___/
                                                          
----------------------------------------------------------

EOF

#--------------------------------#
# Importar variables y funciones #
#--------------------------------#

# Determina el directorio actual del script
scrDir=$(dirname "$(realpath "$0")")
echo "Current directory: $scrDir"

# Carga todas las funciones definidas en el archivo global_fn.sh
source "${scrDir}/global_fn.sh"
########################################################################################
# Verifica si la carga fue exitosa
if [ $? -ne 0 ]; then
     echo "Error: incapaz de cargar global_fn.sh..."
     exit 1
fi

# Comprueba la conectividad a Internet
if ping -c 1 google.com &>/dev/null; then
     echo "estado de coneccion: OK"

else
     echo "Por favor comprueba tu conexión a Internet o vuelve a intentarlo más tarde."
     echo "¿Deseas salir? (s/n)"
     read -n 1 respuesta
     if [[ $respuesta =~ ^[Nn]$ ]]; then
          echo "Saliendo del script..."
          exit 0
     else
          echo "Volverá a probar la conexión a Internet..."
          sleep 1
          ./install.sh # Asume que este script se llama 'script.sh' y está en el mismo directorio
     fi
fi
############################################################################################################################S
#------------------#
# Evaluar opciones #
#------------------#

# Inicializa banderas
# Inicializa banderas
flg_Install=0
flg_Restore=0
flg_Service=0

# Función para mostrar ayuda
show_help() {
     echo "...opciones válidas son..."
     echo "i : [i]nstall hyprland sin configuraciones"
     echo "d : install hyprland [d]efaults sin configuraciones --noconfirm"
     echo "r : [r]estore archivos de configuración"
     echo "s : habilitar servicios del sistema"
}

# Procesa opciones
while getopts idrs RunStep; do
     case $RunStep in
     i) # Si se pasa la opción -i
          flg_Install=1 ;;
     d) # Si se pasa la opción -d
          flg_Install=1
          export use_default="--noconfirm"
          ;;
     r) # Si se pasa la opción -r
          flg_Restore=1 ;;
     s) # Si se pasa la opción -s
          flg_Service=1 ;;
     *) # Si se pasa una opción no reconocida
          show_help
          exit 1
          ;;
     esac
done

# Verifica si se pasaron opciones
if [ $# -lt 1 ]; then
     echo "No se proporcionaron opciones. Por favor, ejecute el script con -h para obtener ayuda."
     exit 1
elif [ $OPTIND -ne 1 ]; then
     echo "Se proporcionaron múltiples opciones. Solo se puede especificar una opción a la vez."
     exit 1
else
     echo "flg_Restore: $flg_Restore"
     echo "flg_Install: $flg_Install"
     echo "flg_Service: $flg_Service"
     # Aquí puedes continuar con la lógica específica de cada opción
fi

#----------------------------#
# Pre-instalación del script #
#----------------------------#
# Aquí se pueden agregar tareas previas a la instalación
if [ ${flg_Install} -eq 1 ] && [ ${flg_Restore} -eq 1 ]; then

     cat <<"EOF"
                _         _       _ _
 ___ ___ ___   |_|___ ___| |_ ___| | |
| . |  _| -_|  | |   |_ -|  _| .'| | |
|  _|_| |___|  |_|_|_|___|_| |__,|_|_|
|_|

EOF

     "${scrDir}/install_pre.sh"
fi
