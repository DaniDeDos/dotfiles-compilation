<h2>Instalar Volta + Tools</h2>
   
<details closed>
    <summary><b>Volta</b></summary>
    <h3>Descripción</h3>
    <p>
    Es una herramienta de administración de versiones de Node.js diseñada para simplificar el proceso de manejo de múltiples versiones de Node.js y paquetes globales en entornos de desarrollo. Con Volta, puedes seleccionar una versión de Node.js y dejar de preocuparte por cambiarla manualmente entre proyectos. Permite instalar binarios de paquetes npm en tu cadena de herramientas sin tener que reinstalarlos periódicamente o averiguar por qué han dejado de funcionar.
    </p>
</details>

<details closed>
    <summary><b>Node</b></summary>
    <h3>Descripción</h3>
    <p>
    Es un entorno de ejecución de JavaScript de alto rendimiento y de código abierto. Se utiliza para ejecutar código JavaScript fuera de un navegador web, permitiendo el desarrollo de aplicaciones de servidor, scripts y herramientas de línea de comandos.
    </p>
</details>

<details closed>
    <summary><b>Yarn</b></summary>
    <h3>Descripción</h3>
    <p>
    Es un administrador de paquetes de JavaScript alternativo a npm. Ofrece mejoras en términos de velocidad, seguridad y simplicidad en comparación con npm. Al igual que Node.js.
    </p>
</details>

<h3>Características</h3>
> Volta:
- Resolución inteligente de versiones: Basándose en los manifiestos de los gestores de paquetes, Volta asegura versiones confiables y consistentes en todos los proyectos.
- Cambios fluidos entre versiones de Node.js: Permite cambiar entre versiones de Node.js sin modificar las variables de entorno PATH.
- Soporte para herramientas instaladas globalmente: Integra directamente con npm y yarn, permitiendo gestionar tanto Node.js como los paquetes globales relacionados.
- Caché inteligente: Mejora el flujo de trabajo de desarrollo al acelerar la carga de paquetes y herramientas.
- Compatibilidad con .nvmrc: Soporta el mismo archivo de configuración que NVM, facilitando la transición entre herramientas.
- Ambientes reproductibles para colaboradores: Al guardar la versión exacta de Node.js en el package.json, garantiza que todos los colaboradores trabajen con la misma versión, promoviendo la consistencia en equipos de desarrollo distribuidos.

> Node:
> Yarn:

Nota: Volta actúa como una capa de abstracción que simplifica la gestión de versiones de Node.js y Yarn, permitiendo a los desarrolladores centrarse en el desarrollo sin tener que lidiar con la complejidad de mantener múltiples versiones de estas herramientas.

<!--
Agregar alias en la terminal para ajusta la imagen a la caja del neofetch

alias neofetch="neofetch --size none"
--!>
