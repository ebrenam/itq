[[Software/Software]]

## ¿Qué es Maven?

**Maven** es una herramienta de gestión y automatización de proyectos, principalmente para proyectos Java.

Maven se basa en el concepto de un Modelo de Objeto de Proyecto (POM - Project Object Model), que es un archivo XML (pom.xml) que describe el proyecto, sus dependencias, cómo se compila, empaqueta, prueba y despliega.

Sus funciones clave incluyen:

* **Gestión de Dependencias:** Esta es quizás su característica más importante. Maven descarga automáticamente las bibliotecas (JARs) y otros artefactos necesarios para tu proyecto desde repositorios centrales (como Maven Central) y los incluye en tu compilación. Esto elimina la necesidad de descargar manualmente innumerables archivos JAR.

	Ejemplo: Si tu proyecto necesita la librería de logging [[Logback]], solo la declaras en tu pom.xml, y Maven se encarga de descargarla y hacerla disponible.

* **Construcción del Proyecto:** Maven estandariza el ciclo de vida de la construcción de un proyecto. Los comandos comunes como ```mvn compile```, ```mvn test```, ```mvn package``` y ```mvn install``` ejecutan fases específicas del ciclo de vida.

	- compile: Compila el código fuente del proyecto.

	- test: Ejecuta las pruebas unitarias.

	- package: Empaqueta el código compilado en un formato distribuible (ej. un archivo [[JAR]] o [[WAR]]).

	- install: Instala el paquete en el repositorio local de Maven para ser usado por otros proyectos.

- **Gestión de Repositorios:** Maven utiliza repositorios (locales, centrales y remotos) para almacenar y compartir artefactos (bibliotecas, plugins, etc.). El repositorio local se encuentra en tu máquina y almacena los artefactos que Maven descarga.

- **Generación de Informes:** Puede generar informes sobre el proyecto, como informes de pruebas, cobertura de código y dependencias.

En resumen, Maven es una herramienta fundamental en el ecosistema Java para gestionar las dependencias de un proyecto y estandarizar el proceso de construcción, haciendo el desarrollo de software más eficiente y organizado.

## ¿Qué es una dependencia?

En desarrollo de software, una **dependency** (dependencia) es una librería, módulo o componente externo que tu proyecto necesita para funcionar correctamente.

Por ejemplo, si tu aplicación en Python usa la librería `pandas` para procesar datos, `pandas` es una dependencia de tu proyecto.

### Características clave:

- Las dependencias pueden ser frameworks, utilidades, APIs, bases de datos, etc.
- Se gestionan automáticamente con herramientas como **Maven** (Java), **npm** (JavaScript), **pip** (Python), etc.
- Permiten reutilizar código y acelerar el desarrollo.


### Ejemplo en Maven (`pom.xml`):

```yaml
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-core</artifactId>
  <version>5.3.10</version>
</dependency>
```

## Repository

* https://mvnrepository.com/

Descargar Maven.
	https://maven.apache.org/download.cgi


[[Software/Software]]