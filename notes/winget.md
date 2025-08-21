## ¿Qué es winget.run?

Es una interfaz web no oficial para el repositorio de winget que hace más fácil:

- Buscar aplicaciones disponibles en winget
- Ver comandos de instalación listos para copiar
- Explorar paquetes populares

## Cómo usar winget.run:

### 1. **Buscar aplicaciones**

- Ve a [https://winget.run](vscode-file://vscode-app/Applications/Visual%20Studio%20Code.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)
- Usa la barra de búsqueda para encontrar la aplicación que necesitas
- Ejemplo: busca "Visual Studio Code", "Chrome", "Git", etc.

### 2. **Ver información del paquete**

- Cada resultado muestra:
    - Nombre del paquete
    - ID del paquete
    - Versión disponible
    - Comando de instalación listo para copiar

### 3. **Instalar desde terminal**

- Copia el comando mostrado
- Ábrelo en PowerShell o Command Prompt como administrador
- Pega y ejecuta el comando

## Ejemplo práctico:

Si buscas "GitHub CLI" en winget.run, obtienes:

```bash
winget install GitHub.cli
```

## Ventajas de winget.run:

- **Interfaz amigable**: Más fácil que recordar comandos
- **Búsqueda visual**: Ves todas las opciones disponibles
- **Comandos listos**: Solo copiar y pegar
- **Información adicional**: Versiones, descripciones, etc.

## Limitaciones:

- Solo funciona en Windows 10/11
- Requiere que tengas winget instalado (viene con Windows App Installer)
- Es un sitio no oficial (aunque muy confiable)