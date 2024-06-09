<h1>Dotfiles Compilation</h1>
<h3>Optimizing Productivity: Dotfiles for Developers & Pentesters on Arch Linux</h3>


<h2>Instalar node y yarn utilizando Volta.</h2>

> ##### Utilizando el script

- Desinstalar Volta.
  ```js
  rm -rf ~/.volta
  ```
- Eliminar las variables del archivo de perfil de la shell.
  ```js
  sed -i '/^ *export VOLTA_HOME="\$HOME\/\.volta"/d' ~/.zshrc
  sed -i '/^ *export PATH="\$VOLTA_HOME\/bin:\$PATH"/d' ~/.zshrc
  ```
- Recargar el archivo del perfil.
  ```js
  source ~/.zshrc
  ```
<!--
Agregar alias en la terminal para ajusta la imagen a la caja del neofetch

alias neofetch="neofetch --size none"
--!>
