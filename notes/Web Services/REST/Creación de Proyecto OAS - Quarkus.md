
Quarkus es una opción fantástica y moderna para enseñar REST. Su enfoque "API-First" es muy potente, aunque un poco diferente al de Spring Boot.

Aquí tienes la guía paso a paso adaptada para Quarkus, asumiendo que ya tienen su archivo `.yaml` o `.json` de OpenAPI.

---

## 🚀 Paso 1: Crear el Proyecto en `code.quarkus.io`

Generaremos la estructura base del proyecto.

1. Ve a [code.quarkus.io](https://code.quarkus.io/).
    
2. Configura tu proyecto:
    
    - **Build Tool:** Maven        
    - **Group ID:** `com.ejemplo`        
    - **Artifact ID:** `mi-api-quarkus`        
    - **Package Name:** `com.ejemplo.api` (¡Importante! Usaremos este como base).
        
3. **Añadir Extensiones (Dependencias):** Busca y agrega las siguientes extensiones esenciales:
    
    - **RESTEasy Reactive Jackson:** Es el stack completo para crear endpoints REST (JAX-RS) y manejar JSON.
        
    - **Hibernate Validator:** Para usar las anotaciones de validación (ej. `@Valid`, `@NotNull`) que se generarán en los modelos.
        
4. Haz clic en **"Generate your application"** y luego en **"Download as zip"**.
    
5. Descomprime el archivo y abre el proyecto en tu IDE (IntelliJ, Eclipse, VSCode).
    

---

## 📦 Paso 2: Estructura de Paquetes y OAS

La organización es fundamental.

1. **Colocar el OAS:** Dentro de la carpeta `src/main/resources`, crea una nueva carpeta llamada `api`. Copia tu archivo (ej. `openapi.yaml`) dentro de ella.
    
    - Ruta final: `src/main/resources/api/openapi.yaml`
        
2. **Verificar Paquetes:** En `src/main/java`, ya tendrás tu paquete base (ej. `com.ejemplo.api`). Dentro de este, crea los siguientes sub-paquetes:
    
    - `com.ejemplo.api.resource` (Para nuestros "Resources", el equivalente a Controllers en Quarkus/JAX-RS)
        
    - `com.ejemplo.api.model` (Aquí moveremos los modelos generados)
        
    - `com.ejemplo.api.service` (Para la lógica de negocio)
        

Tu estructura debería verse así:

```
mi-api-quarkus/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/ejemplo/api/
│   │   │       ├── resource/
│   │   │       ├── model/
│   │   │       ├── service/
│   │   └── resources/
│   │       ├── api/
│   │       │   └── openapi.yaml  <-- Tu archivo OAS aquí
│   │       └── application.properties
└── pom.xml
```

---

## ⚙️ Paso 3: Configurar `pom.xml` para Generar Modelos

Usaremos el mismo plugin de Maven que en el ejemplo de Spring, pero lo configuraremos para que genere código compatible con JAX-RS (el estándar que usa Quarkus) en lugar de Spring MVC.

Abre tu archivo `pom.xml`.

1. **Añadir Dependencias (si faltaran):** Asegúrate de tener estas dependencias dentro de la etiqueta `<dependencies>`. El validador y RESTEasy ya deberían estar si los seleccionaste en el paso 1.
    
    XML
    
    ```
    <dependency>
        <groupId>org.openapitools</groupId>
        <artifactId>jackson-databind-nullable</artifactId>
        <version>0.2.6</version>
    </dependency>
    
    <dependency>
        <groupId>jakarta.validation</groupId>
        <artifactId>jakarta.validation-api</artifactId>
    </dependency>
    
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-resteasy-reactive-jackson</artifactId>
    </dependency>
    
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-hibernate-validator</artifactId>
    </dependency>
    ```
    
2. **Añadir el Plugin Generador:** Dentro de la etiqueta `<build>`, busca la sección `<plugins>` y añade el siguiente plugin:
    
    XML
    
    ```
    <build>
        <plugins>
            <plugin>
                <groupId>${quarkus.platform.group-id}</groupId>
                <artifactId>quarkus-maven-plugin</artifactId>
                <version>${quarkus.platform.version}</version>
                </plugin>
    
            <plugin>
                <groupId>org.openapitools</groupId>
                <artifactId>openapi-generator-maven-plugin</artifactId>
                <version>7.1.0</version> <executions>
                    <execution>
                        <goals>
                            <goal>generate</goal>
                        </goals>
                        <configuration>
                            <inputSpec>${project.basedir}/src/main/resources/api/openapi.yaml</inputSpec>
    
                            <generatorName>jaxrs-resteasy-reactive</generatorName>
    
                            <modelPackage>com.ejemplo.api.model</modelPackage>
    
                            <generateModels>true</generateModels>
                            <generateApis>false</generateApis>
                            <generateSupportingFiles>false</generateSupportingFiles>
    
                            <configOptions>
                                <useJakartaEe>true</useJakartaEe> <useBeanValidation>true</useBeanValidation>
                                <serializableModel>true</serializableModel>
                            </configOptions>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            </plugins>
    </build>
    ```
    

---

## ☕ Paso 4: Generar y Mover los Modelos

Este paso es idéntico al de Spring.

1. **Ejecutar Maven:** Abre una terminal en la raíz de tu proyecto y ejecuta:
    
    Bash
    
    ```
    mvn clean openapi-generator:generate
    ```
    
    (O usa la interfaz gráfica de tu IDE).
    
2. **Verificar Archivos Generados:** Los archivos aparecerán en: `target/generated-sources/openapi/src/main/java/com/ejemplo/api/model`
    
3. **Mover los Modelos:**
    
    - Copia todos los archivos `.java` de ese directorio (`Producto.java`, `Error.java`, etc.).
        
    - Pégalos en tu paquete de código fuente: `src/main/java/com/ejemplo/api/model`
        

Ahora tu proyecto Quarkus reconoce las clases del modelo.

---

## ➡️ Paso 5: Crear el Resource (Lógica del API)

En JAX-RS (Quarkus), los _Controllers_ se llaman _Resources_. Usan anotaciones diferentes a Spring.

Supongamos que tu OAS define `POST /productos` y `GET /productos/{id}`.

1. **Crear la Clase Resource:** En `com.ejemplo.api.resource`, crea una nueva clase Java, `ProductoResource.java`.
    
2. **Añadir Anotaciones JAX-RS:**
    
    - `@Path("/api/v1")`: Define el prefijo base para todas las rutas en esta clase.
        
    - `@Produces(MediaType.APPLICATION_JSON)`: Indica que, por defecto, los métodos _devuelven_ JSON.
        
    - `@Consumes(MediaType.APPLICATION_JSON)`: Indica que, por defecto, los métodos _reciben_ JSON.
        
    - Importa `jakarta.ws.rs.*` para estas anotaciones.
        
    
    Java
    
    ```
    package com.ejemplo.api.resource;
    
    import com.ejemplo.api.model.Producto; // <-- Importa tu modelo generado
    import jakarta.validation.Valid;
    import jakarta.ws.rs.*;
    import jakarta.ws.rs.core.MediaType;
    import jakarta.ws.rs.core.Response; // <-- El "ResponseEntity" de JAX-RS
    
    @Path("/api/v1") // Prefijo base de la API
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public class ProductoResource {
    
        // ... aquí irán los métodos
    }
    ```
    
3. **Implementar los Endpoints (Métodos):**
    
    - Usamos `@POST` y `@GET`.
        
    - Usamos `@Path` en el método para la sub-ruta.
        
    - `@Valid`: Activa la validación (igual que en Spring).
        
    - `@PathParam`: Se usa para capturar variables de la URL (en lugar de `@PathVariable`).
        
    - **Importante:** En JAX-RS, no se necesita `@RequestBody`. Si un método POST/PUT recibe un POJO, Quarkus automáticamente intenta deserializarlo desde el cuerpo.
        
    - **Retorno:** El estándar de JAX-RS usa `Response` para tener control total del código HTTP.
        
    
    Java
    
    ```
    // ... dentro de la clase ProductoResource ...
    
    @POST
    @Path("/productos")
    public Response crearProducto(@Valid Producto productoRequest) {
        // Por ahora, solo simularemos que lo guardamos
        System.out.println("Producto recibido: " + productoRequest.getNombre());
    
        // Simulamos que la DB le asigna un ID
        productoRequest.setId(1L); 
    
        // Devolvemos el producto con código 201 (CREATED)
        // La sintaxis de JAX-RS es un poco diferente
        return Response.status(Response.Status.CREATED).entity(productoRequest).build();
    }
    
    @GET
    @Path("/productos/{id}")
    public Response obtenerProductoPorId(
        @PathParam("id") Long id // <-- Nota el @PathParam
    ) {
        // Simulación: creamos un producto de prueba
        Producto productoEncontrado = new Producto();
        productoEncontrado.setId(id);
        productoEncontrado.setNombre("Producto de prueba (Quarkus)");
        productoEncontrado.setPrecio(99.99);
    
        // Devolvemos el producto con código 200 (OK)
        return Response.ok(productoEncontrado).build();
    }
    ```
    

---

## 🛠️ Paso 6: (Opcional pero recomendado) Añadir Capa de Servicio

La lógica de negocio debe estar separada. En Quarkus, esto se hace con CDI (Contexts and Dependency Injection).

1. **Crear `ProductoService`:** En `com.ejemplo.api.service`, crea `ProductoService.java`.
    
2. **Anotar con `@ApplicationScoped`:** Esta es la anotación estándar de CDI (equivalente a `@Service` en Spring) para crear un "bean" que vive durante toda la aplicación.
    
    Java
    
    ```
    package com.ejemplo.api.service;
    
    import com.ejemplo.api.model.Producto;
    import jakarta.enterprise.context.ApplicationScoped; // <-- Importante
    
    @ApplicationScoped // Le dice a Quarkus que gestione esta clase
    public class ProductoService {
    
        public Producto guardarProducto(Producto producto) {
            // Aquí iría la lógica de Panache (ORM de Quarkus) o JDBC
            System.out.println("Guardando producto en el servicio: " + producto.getNombre());
    
            producto.setId(1L);
            return producto;
        }
    
        public Producto buscarProducto(Long id) {
            // Lógica de búsqueda
            Producto productoEncontrado = new Producto();
            productoEncontrado.setId(id);
            productoEncontrado.setNombre("Producto de prueba desde Servicio (Quarkus)");
            productoEncontrado.setPrecio(99.99);
            return productoEncontrado;
        }
    }
    ```
    
3. **Usar el Servicio en el Resource:** Modifica tu `ProductoResource` para "inyectar" el servicio.
    
    - En CDI (Quarkus), usamos `@Inject` (de `jakarta.inject.Inject`) en lugar de `@Autowired`.
        
    
    Java
    
    ```
    // ... en ProductoResource.java ...
    import com.ejemplo.api.service.ProductoService;
    import jakarta.inject.Inject; // <-- ¡El inyector de CDI!
    
    @Path("/api/v1")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public class ProductoResource {
    
        // Inyección de dependencias con CDI
        @Inject
        ProductoService productoService;
    
        @POST
        @Path("/productos")
        public Response crearProducto(@Valid Producto productoRequest) {
            // El resource delega la lógica al servicio
            Producto productoGuardado = productoService.guardarProducto(productoRequest);
    
            return Response.status(Response.Status.CREATED).entity(productoGuardado).build();
        }
    
        @GET
        @Path("/productos/{id}")
        public Response obtenerProductoPorId(@PathParam("id") Long id) {
            // El resource delega la lógica al servicio
            Producto productoEncontrado = productoService.buscarProducto(id);
    
            return Response.ok(productoEncontrado).build();
        }
    }
    ```
    

---

## 🧪 Paso 7: Probar con Postman

Quarkus brilla por su _live reload_.

1. **Ejecutar la Aplicación (Modo Desarrollo):** Abre una terminal en la raíz del proyecto y ejecuta:
    
    Bash
    
    ```
    mvn quarkus:dev
    ```
    
    Verás el logo de Quarkus. ¡No cierres esta terminal! Quarkus recargará automáticamente los cambios que hagas en el código.
    
2. **Abrir Postman.**
    
3. **Probar el `POST /productos`:**
    
    - **Método:** `POST`
        
    - **URL:** `http://localhost:8080/api/v1/productos` (Quarkus usa el puerto 8080 por defecto).
        
    - **Pestaña "Body"**: `raw` y `JSON`.
        
        JSON
        
        ```
        {
          "nombre": "Mi Producto Quarkus",
          "precio": 200.00
        }
        ```
        
    - **¡Enviar!** Deberías recibir una respuesta `201 Created` con el JSON y el ID "1".
        
4. **Probar el `GET /productos/{id}`:**
    
    - **Método:** `GET`
        
    - **URL:** `http://localhost:8080/api/v1/productos/1`
        
    - **¡Enviar!** Deberías recibir una respuesta `200 OK` con el producto simulado desde el servicio.