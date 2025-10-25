## Crear un Proyecto REST API desde OAS con OpenAPI Generator y Spring Boot

## Prerrequisitos

- **Java 21** instalado
- **Node.js** (opcional, para herramientas de validación)
- **IDE** recomendado: VS Code, IntelliJ IDEA, Eclipse

---

## 1. Crear el archivo OAS (OpenAPI Specification)

1. Crea un archivo llamado `openapi.yaml` o `openapi.json` con la definición de tu API.
2. Puedes usar [Swagger Editor online](vscode-file://vscode-app/snap/code/211/usr/share/code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) para crear y validar tu OAS.

---

## 2. Instalar OpenAPI Generator

**Opción 1: Usando npm (recomendado, multiplataforma)**

```bash
npm install @openapitools/openapi-generator-cli -g
```

**Opción 2: Descargar el JAR**

```bash
wget https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.9.0/openapi-generator-cli-7.9.0.jar -O openapi-generator-cli.jar

# Usar con: java -jar openapi-generator-cli.jar ...
``` 

---

## 3. Generar el código base a partir del OAS

### Para Spring Boot

```bash
openapi-generator-cli generate -i openapi.yaml -g spring -o spring-api
```

```bash
java -jar openapi-generator-cli.jar generate -i openapi.yaml -g spring -o spring-api
```

- `-i`: archivo de entrada OAS
- `-g`: lenguaje/framework (`spring`)
- `-o`: carpeta de salida

---

## 4. Importar el proyecto en tu IDE

- Abre la carpeta generada (`spring-api`) en tu IDE favorito.

---

## 5. Compilar y ejecutar el proyecto

```bash
cd spring-api
./mvnw spring-boot:run
# O en Windows:
mvnw.cmd spring-boot:run
```

---

## 6. Probar la API

- Accede a la documentación Swagger generada:
    
    - Spring Boot: [http://localhost:8080/swagger-ui.html](vscode-file://vscode-app/snap/code/211/usr/share/code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)

- Usa herramientas como **curl** o **Postman** para probar los endpoints.
    

---

## 7. Personalizar la lógica de negocio

- Edita los controladores y servicios generados para implementar la lógica de tu API.

---

## 8. Validar y actualizar el OAS

- Si cambias la API, actualiza el archivo OAS y vuelve a generar el código si es necesario.

---

## Recursos útiles

- [OpenAPI Generator Docs](vscode-file://vscode-app/snap/code/211/usr/share/code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)
- [Spring Boot Docs](vscode-file://vscode-app/snap/code/211/usr/share/code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)
- [Swagger Editor](vscode-file://vscode-app/snap/code/211/usr/share/code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)

---

**Notas:**

- El proceso es igual en Windows, Linux y Mac (solo cambia el uso de `./mvnw` vs `mvnw.cmd`).
- Puedes usar otros generadores soportados por OpenAPI Generator según tus necesidades.