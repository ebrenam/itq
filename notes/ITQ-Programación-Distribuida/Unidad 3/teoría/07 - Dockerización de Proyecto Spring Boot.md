# Dockerización de Proyecto Spring Boot

Guía paso a paso para dockerizar tu proyecto Spring Boot con API REST basada en OpenAPI.

Aprenderás a crear los artefactos necesarios, generar la imagen Docker y desplegarla como contenedor.

---

## 📋 Prerrequisitos

Antes de comenzar, asegúrate de tener:

1. **Proyecto Spring Boot funcional** (siguiendo el documento "05 - Creación de Proyecto OAS - Spring Boot"). Puedes tomar como base el proyecto que está en la siguiente **[ruta de github](../proyecto/spring-boot/02-final/oas-api-rest-final.zip)**.
2. **Docker instalado** en tu sistema:
   - Linux: Verifica con `docker --version`
   - Windows/Mac: Docker Desktop instalado y ejecutándose
3. **Maven** instalado (o usa el wrapper `mvnw` incluido en el proyecto).
4. **Conocimientos básicos** de línea de comandos.

---

## 🐳 Paso 1: Crear el Dockerfile

El `Dockerfile` es el plano que describe cómo construir tu imagen Docker.

1. **Ubicación:** En la **raíz de tu proyecto** (al mismo nivel que `pom.xml`), crea un archivo llamado `Dockerfile` (sin extensión).

2. **Contenido del Dockerfile:** Utilizaremos un enfoque **multi-stage build** para optimizar el tamaño de la imagen final.

    ```dockerfile
    # ========================================
    # ETAPA 1: Build (Construcción)
    # ========================================
    # Usamos una imagen base con Maven y JDK para compilar
    FROM maven:3.9.5-eclipse-temurin-21 AS build

    # Establecemos el directorio de trabajo dentro del contenedor
    WORKDIR /app

    # Copiamos el archivo pom.xml primero (para aprovechar cache de Docker)
    COPY pom.xml .

    # Descargamos las dependencias (esto se cachea si pom.xml no cambia)
    RUN mvn dependency:go-offline -B

    # Copiamos el resto del código fuente
    COPY src ./src

    # Compilamos el proyecto y generamos el JAR
    # -DskipTests: Omite la ejecución de tests para acelerar (opcional)
    RUN mvn clean package -DskipTests

    # ========================================
    # ETAPA 2: Runtime (Ejecución)
    # ========================================
    # Usamos una imagen ligera solo con JRE para ejecutar
    FROM eclipse-temurin:21-jre-alpine

    # Establecemos el directorio de trabajo
    WORKDIR /app

    # Copiamos el JAR desde la etapa de build
    # Ajusta el nombre del JAR según tu proyecto (revisa target/ después de compilar)
    COPY --from=build /app/target/oas-api-rest-*.jar app.jar

    # Exponemos el puerto 8080 (puerto por defecto de Spring Boot)
    EXPOSE 8080

    # Comando para ejecutar la aplicación
    ENTRYPOINT ["java", "-jar", "app.jar"]
    ```

    **Explicación de las secciones:**

    - **Etapa 1 (Build):** Usa una imagen con Maven para compilar el proyecto y generar el archivo `.jar`.
    - **Etapa 2 (Runtime):** Usa una imagen ligera con solo JRE para ejecutar el `.jar`, reduciendo el tamaño final.
    - **`EXPOSE 8080`:** Documenta que el contenedor escucha en el puerto 8080.
    - **`ENTRYPOINT`:** Define el comando que se ejecutará al iniciar el contenedor.

---

## 📝 Paso 2: Crear el archivo .dockerignore (Opcional pero recomendado)

Similar a `.gitignore`, este archivo le dice a Docker qué archivos/carpetas **NO** copiar al contenedor, mejorando la eficiencia.

1. **Ubicación:** En la **raíz del proyecto** (junto al `Dockerfile`).

2. **Contenido del `.dockerignore`:**

    ```
    # Archivos compilados
    target/
    
    # Dependencias de Maven (se descargan en el Dockerfile)
    .mvn/
    
    # IDEs
    .idea/
    .vscode/
    *.iml
    .project
    .classpath
    .settings/
    
    # Git
    .git/
    .gitignore
    
    # Logs
    *.log
    
    # Documentación
    README.md
    
    # Archivos del sistema
    .DS_Store
    Thumbs.db
    ```

---

## 🏗️ Paso 3: Construir la imagen Docker

Con el `Dockerfile` listo, vamos a construir nuestra imagen.

1. **Abrir terminal** en la raíz de tu proyecto (donde está el `Dockerfile`).

2. **Ejecutar el comando de build:**

    ```bash
    docker build -t oas-api-rest:1.0 .
    ```

    **Explicación:**
    - `docker build`: Comando para construir una imagen.
    - `-t oas-api-rest:1.0`: Etiqueta (tag) para nombrar tu imagen. Formato: `nombre:versión`.
    - `.`: Indica que el contexto de construcción es el directorio actual.

3. **Observar el proceso:** Docker ejecutará cada instrucción del `Dockerfile`. La primera vez tardará más (descarga de imágenes base y dependencias). Verás output similar a:

    ```
    [+] Building 45.3s (15/15) FINISHED
     => [internal] load build definition from Dockerfile
     => [internal] load .dockerignore
     => [build 1/6] FROM docker.io/library/maven:3.9.5...
     => [build 2/6] WORKDIR /app
     => [build 3/6] COPY pom.xml .
     => [build 4/6] RUN mvn dependency:go-offline -B
     => [build 5/6] COPY src ./src
     => [build 6/6] RUN mvn clean package -DskipTests
     => [stage-1 2/3] WORKDIR /app
     => [stage-1 3/3] COPY --from=build /app/target/oas-api-rest-*.jar app.jar
     => exporting to image
     => => naming to docker.io/library/oas-api-rest:1.0
    ```

4. **Verificar la imagen creada:**

    ```bash
    docker images
    docker image ls
    ```

    Deberías ver tu imagen listada:

    ```
    REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
    oas-api-rest      1.0       a1b2c3d4e5f6   2 minutes ago    350MB
    ```

---

## 🚀 Paso 4: Ejecutar el contenedor

Con la imagen construida, ahora podemos crear y ejecutar un contenedor.

### Opción A: Ejecución básica

```bash
docker run -p 8080:8080 oas-api-rest:1.0
```

**Explicación:**
- `docker run`: Crea y ejecuta un contenedor.
- `-p 8080:8080`: Mapea el puerto 8080 del host al puerto 8080 del contenedor.
- `oas-api-rest:1.0`: Nombre de la imagen a ejecutar.

**Salida esperada:**

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.2.x)

...
2025-11-24T10:30:15.123  INFO 1 --- [main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http)
2025-11-24T10:30:15.456  INFO 1 --- [main] com.ejemplo.api.OasApiRestApplication   : Started OasApiRestApplication in 3.245 seconds
```

La aplicación está corriendo. **Nota:** El terminal quedará "bloqueado" mostrando los logs.

### Opción B: Ejecución en modo detached (segundo plano)

```bash
docker run -d -p 8080:8080 --name mi-api oas-api-rest:1.0
```

**Parámetros adicionales:**
- `-d`: Ejecuta el contenedor en segundo plano (detached).
- `--name mi-api`: Asigna un nombre personalizado al contenedor.

**Verificar contenedores en ejecución:**

```bash
docker ps
docker container ls
```

Salida:

```
CONTAINER ID   IMAGE              COMMAND            CREATED          STATUS         PORTS                    NAMES
a1b2c3d4e5f6   oas-api-rest:1.0   "java -jar app.jar"   10 seconds ago   Up 9 seconds   0.0.0.0:8080->8080/tcp   mi-api
```

---

## 🧪 Paso 5: Probar la API en el contenedor

Con el contenedor en ejecución, la API está disponible en `http://localhost:8080`.

### Probar con cURL:

**GET:**

```bash
curl http://localhost:8080/api/v1/reservations/1
```

**POST:**

```bash
curl -X POST 'http://localhost:8080/api/v1/reservations' \
--header 'Content-Type: application/json' \
--data '{
  "idClient": "PC-061",
  "activity": "yoga",
  "dayOfWeek": "Lun",
  "time": "09:00"
}'
```

### Probar con Postman:

- **Método:** `GET` o `POST`
- **URL:** `http://localhost:8080/api/v1/reservations`
- Envía las peticiones como lo harías normalmente.

---

## 🔍 Paso 6: Comandos útiles de gestión

> Para probar los siguientes comandos, necesitas detener el contenedor actual e iniciar otro con un `nombre de contenedor` asignado, se recomienda que se inicie en modo `detach`.

```bash
docker run -p 8080:8080 --name mi-api -d oas-api-rest:1.0
```

### Ver logs del contenedor:

```bash
docker logs mi-api
```

Para seguir los logs en tiempo real:

```bash
docker logs -f mi-api
```

### Detener el contenedor:

```bash
docker stop mi-api
```

### Iniciar un contenedor detenido:

```bash
docker start mi-api
```

### Eliminar el contenedor:

```bash
docker rm mi-api
```

**Nota:** El contenedor debe estar detenido antes de eliminarlo. Para forzar la eliminación:

```bash
docker rm -f mi-api
```

### Acceder al shell del contenedor (para debugging):

```bash
docker exec -it mi-api sh
```

Esto te da acceso a la línea de comandos dentro del contenedor (usa `exit` para salir).

### Eliminar la imagen:

```bash
docker rmi oas-api-rest:1.0
docker image rm oas-api-rest:1.0
```

---

## 🌐 Paso 7: Variables de entorno (Configuración avanzada)

Puedes configurar tu aplicación Spring Boot usando variables de entorno sin modificar el código.

### Ejemplo: Cambiar el puerto

```bash
docker run -d -p 9090:9090 --name mi-api \
  -e SERVER_PORT=9090 \
  oas-api-rest:1.0
```

**Explicación:**
- `-e SERVER_PORT=9090`: Define la variable de entorno `SERVER_PORT` con valor `9090`.
- `-p 9090:9090`: Mapea el nuevo puerto.

Spring Boot lee automáticamente `SERVER_PORT` y cambia el puerto del servidor.

### Ejemplo: Configurar perfil activo

```bash
docker run -d -p 8080:8080 --name mi-api \
  -e SPRING_PROFILES_ACTIVE=prod \
  oas-api-rest:1.0
```

Esto activará el perfil `prod` (debes tener `application-prod.properties`).

---

## 📦 Paso 8: Subir la imagen a Docker Hub (Opcional)

Si quieres compartir tu imagen o desplegarla en otro servidor:

1. **Crear cuenta en Docker Hub:** [hub.docker.com](https://hub.docker.com)

2. **Iniciar sesión desde terminal:**

    ```bash
    docker login
    ```

3. **Etiquetar la imagen con tu usuario:**

    ```bash
    docker tag oas-api-rest:1.0 tuusuario/oas-api-rest:1.0
    ```

4. **Subir la imagen:**

    ```bash
    docker push tuusuario/oas-api-rest:1.0
    ```

5. **Descargar y ejecutar desde otro equipo:**

    ```bash
    docker run -p 8080:8080 tuusuario/oas-api-rest:1.0
    ```

---

## 🎯 Paso 9: Docker Compose (Despliegue multi-contenedor)

Si tu aplicación necesita otros servicios (base de datos, caché, etc.), Docker Compose simplifica la gestión.

### Crear docker-compose.yml

En la raíz del proyecto, crea `docker-compose.yml`:

```yaml
version: '3.8'

services:
  # Servicio de la API
  api:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/gym_db
      - SPRING_DATASOURCE_USERNAME=root
      - SPRING_DATASOURCE_PASSWORD=rootpassword
    depends_on:
      - db
    networks:
      - app-network

  # Servicio de Base de Datos (ejemplo con MySQL)
  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword
      - MYSQL_DATABASE=gym_db
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  mysql-data:
```

### Ejecutar con Docker Compose:

```bash
# Construir y levantar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes
docker-compose down -v
```

---

## ⚙️ Paso 10: Optimizaciones adicionales

### 1. Optimizar el tamaño de la imagen

**Usar Layered JARs (Spring Boot 2.3+):**

Modifica el `pom.xml`:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <layers>
                    <enabled>true</enabled>
                </layers>
            </configuration>
        </plugin>
    </plugins>
</build>
```

Actualiza el `Dockerfile`:

```dockerfile
# ETAPA 2: Runtime mejorada con capas
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Extraer las capas del JAR
COPY --from=build /app/target/oas-api-rest-*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

# Copiar capas en orden de menor a mayor frecuencia de cambios
COPY --from=build /app/dependencies/ ./
COPY --from=build /app/spring-boot-loader/ ./
COPY --from=build /app/snapshot-dependencies/ ./
COPY --from=build /app/application/ ./

EXPOSE 8080

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
```

**Beneficio:** Docker cachea las capas que no cambian, acelerando builds subsecuentes.

### 2. Healthcheck

Agrega al `Dockerfile`:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1
```

**Nota:** Requiere Spring Boot Actuator. Agrega al `pom.xml`:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### 3. Usuario no-root (Seguridad)

Agrega al `Dockerfile` antes del `ENTRYPOINT`:

```dockerfile
# Crear usuario no-root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
```

---

## 🐛 Solución de problemas comunes

### Error: "Cannot find JAR file"

**Causa:** El nombre del JAR en el `Dockerfile` no coincide.

**Solución:**
1. Compila el proyecto: `mvn clean package`
2. Revisa el nombre del JAR en `target/`: `ls target/*.jar`
3. Actualiza la línea `COPY` en el `Dockerfile` con el nombre exacto.

### Error: "Port 8080 already in use"

**Causa:** Otro servicio está usando el puerto 8080.

**Soluciones:**
- Detén el servicio que usa el puerto.
- Mapea a otro puerto: `docker run -p 9090:8080 ...` (accede en `localhost:9090`).

### La aplicación se cae inmediatamente

**Revisar logs:**

```bash
docker logs mi-api
```

Busca excepciones o errores de configuración.

### No se ven los cambios después de modificar el código

**Causa:** Docker usa la imagen cacheada.

**Solución:** Reconstruir la imagen:

```bash
docker build --no-cache -t oas-api-rest:1.0 .
docker stop mi-api
docker rm mi-api
docker run -d -p 8080:8080 --name mi-api oas-api-rest:1.0
```

---

## 📚 Resumen de comandos

```bash
# Construir imagen
docker build -t oas-api-rest:1.0 .

# Ejecutar contenedor
docker run -d -p 8080:8080 --name mi-api oas-api-rest:1.0

# Ver contenedores activos
docker ps
docker container ls

# Ver logs
docker logs -f mi-api
docker container logs -f mi-api

# Detener contenedor
docker stop mi-api

# Iniciar contenedor
docker start mi-api

# Eliminar contenedor
docker rm mi-api
docker container rm mi-api

# Eliminar imagen
docker rmi oas-api-rest:1.0
docker image rm oas-api-rest:1.0

# Limpiar recursos no usados
docker system prune -a
```

---

## ✅ Checklist de verificación

- [ ] Dockerfile creado en la raíz del proyecto
- [ ] .dockerignore configurado
- [ ] Imagen construida exitosamente (`docker build`)
- [ ] Contenedor ejecutándose (`docker ps`)
- [ ] API responde en `http://localhost:8080`
- [ ] Endpoints probados con Postman/cURL
- [ ] Logs del contenedor revisados
- [ ] Comandos de gestión practicados

---

## 🎓 Conceptos clave aprendidos

1. **Multi-stage builds:** Optimización del tamaño de imagen separando compilación y ejecución.
2. **Port mapping:** Exposición de servicios del contenedor al host.
3. **Variables de entorno:** Configuración dinámica sin reconstruir imágenes.
4. **Docker Compose:** Orquestación de múltiples servicios.
5. **Buenas prácticas:** Uso de `.dockerignore`, healthchecks, usuarios no-root.

---

## 📖 Recursos adicionales

- [Documentación oficial de Docker](https://docs.docker.com/)
- [Spring Boot Docker Guide](https://spring.io/guides/topicals/spring-boot-docker/)
- [Docker Hub](https://hub.docker.com/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

---

¡Felicidades! 🎉 Ahora tienes tu aplicación Spring Boot completamente dockerizada y lista para desplegar en cualquier entorno que soporte Docker.
