<h1>Instalar Volta + Tools</h1>
 
### Volta ( Istalacion manual )
> ##### ⚠ Sustituir `~/.bashrc` por `~/.zshrc` si uasas bash
- Actualizar el sistema.
  ```js
  sudo pacman -Sy
  ```
- Descargar e instalar Volta.
  ```bash
  curl https://get.volta.sh | bash
  ```
- Editar el archivo de perfil de la shell para ejecutarlo global.
  ```bash
  echo 'export PATH="/opt/V/bin:$PATH"' >> ~/.zshrc
  ```
- Recargar el archivo del perfil.
  ```bash
  source ~/.zshrc
  ```
- Comprobar version.
  ```js
  volta --version
  ```
<details closed>
<summary><b>Descripción</b></summary>
<h5>
  
> - Es una herramienta de administración de versiones de Node.js diseñada para simplificar el proceso de manejo de múltiples versiones de Node.js y paquetes globales en entornos de desarrollo. Con Volta, puedes seleccionar una versión de Node.js y dejar de preocuparte por cambiarla manualmente entre proyectos. Permite instalar binarios de paquetes npm en tu cadena de herramientas sin tener que reinstalarlos periódicamente o averiguar por qué han dejado de funcionar.

</h5>
</details>
<details closed>
    <summary><b>Características</b></summary>
 <h5>

> - Resolución inteligente de versiones: Basándose en los manifiestos de los gestores de paquetes, Volta asegura versiones confiables y consistentes en todos los proyectos.
> - Cambios fluidos entre versiones de Node.js: Permite cambiar entre versiones de Node.js sin modificar las variables de entorno PATH.
> - Soporte para herramientas instaladas globalmente: Integra directamente con npm y yarn, permitiendo gestionar tanto Node.js como los paquetes globales relacionados.
> - Caché inteligente: Mejora el flujo de trabajo de desarrollo al acelerar la carga de paquetes y herramientas.
> - Compatibilidad con .nvmrc: Soporta el mismo archivo de configuración que NVM, facilitando la transición entre herramientas.
> - Ambientes reproductibles para colaboradores: Al guardar la versión exacta de Node.js en el package.json, garantiza que todos los colaboradores trabajen con la misma versión, promoviendo la consistencia en equipos de desarrollo distribuidos.

   </h5>
</details>

---

### Tool ( Node )

> ##### 💡 Recurde que `node` ya trae cosigo `npm` y `npx`.

- Instalar node.
  ```js
  volta install node
  ```
- Comprobar version None.

  ```js
  node --version
  ```

<details closed>
  <summary><h5>Descripción</h5></summary>

> - Es un entorno de ejecución de JavaScript de alto rendimiento y de código abierto. Se utiliza para ejecutar código JavaScript fuera de un navegador web, permitiendo el desarrollo de aplicaciones de servidor, scripts y herramientas de línea de comandos.

</details>

---

### Tool ( Yarn )

> ##### ⚠ Sustituir `~/.bashrc` por `~/.zshrc` si uasas bash

- Instalar yarn.
  ```js
  volta install yarn
  ```
- Comprobar version.
  ```js
  yarn --version
  ```

<details closed>
  <summary><h5>Descripción</h5></summary>

> - Es un administrador de paquetes de JavaScript alternativo a npm. Ofrece mejoras en términos de velocidad, seguridad y simplicidad en comparación con npm.

</details>



> - `Nota:` Volta actúa como una capa de abstracción que simplifica la gestión de versiones de Node.js y Yarn, permitiendo a los desarrolladores centrarse en el desarrollo sin tener que lidiar con la complejidad de mantener múltiples versiones de estas herramientas.

sed -i '/^ \*export PATH="\/opt\/V\/bin:$PATH"/d' ~/.zshrc

<!--
Agregar alias en la terminal para ajusta la imagen a la caja del neofetch

alias neofetch="neofetch --size none"
--!>
