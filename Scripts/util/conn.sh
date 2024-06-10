#!/usr/bin/env bash

# Comprueba la conectividad a Internet
if ping -c 1 google.com &>/dev/null; then
    echo "estado de coneccion: OK"
    return 0
else
    echo "Por favor comprueba tu conexión a Internet o vuelve a intentarlo más tarde."
    echo "¿Deseas salir? (s/n)"
    read -n 1 respuesta
    if [[ $respuesta =~ ^[Nn]$ ]]; then
        echo "Saliendo del script..."
        return 1
    else
        echo "Volverá a probar la conexión a Internet..."
        sleep 1
        return 0
    fi
fi
