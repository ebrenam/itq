Ennfoque "API-First" con OpenAPI (OAS) y Spring Boot.

Aquí tienes una guía paso a paso asumiendo que ya tienes tu archivo `.yaml` o `.json` de OpenAPI.

---

## 🚀 Paso 1: Crear el Proyecto en Spring Initializr

Primero, generaremos la estructura base de nuestro proyecto Spring Boot.

1. Ve a [start.spring.io](https://start.spring.io/).
    
2. Configura tu proyecto:
    
    - **Project:** Maven        
    - **Language:** Java      
    - **Spring Boot:** Elige una versión estable (ej. 3.2.x).        
    - **Project Metadata:**        
        - **Group:** `com.ejemplo` (o el de tu organización)       
        - **Artifact:** `mi-api-rest`            
        - **Name:** `mi-api-rest`           
        - **Package name:** `com.ejemplo.api` (¡Importante! Usaremos este como base).
            
3. **Añadir Dependencias:** Busca y agrega las siguientes dependencias esenciales:
    
    - **Spring Web:** Necesario para crear controladores REST.
        
    - **Spring Boot Starter Validation:** Para usar las anotaciones de validación (ej. `@Valid`, `@NotNull`) que se generarán en los modelos.
        
    - **Lombok:** (Opcional, pero muy recomendado) Reduce el código repetitivo (getters, setters, etc.) en tus modelos.
        
    - **Jackson Databind Nullable:** (Dependencia de soporte) A menudo es necesaria para manejar correctamente los campos `nullable` definidos en tu OAS.
        
4. Haz clic en **"Generate"**. Esto descargará un archivo `.zip`.
    
5. Descomprime el archivo y abre el proyecto en tu IDE favorito (IntelliJ, Eclipse, VSCode).
    

---

## 📦 Paso 2: Estructura de Paquetes y OAS

Una buena organización es clave.

1. **Colocar el OAS:** Dentro de la carpeta `src/main/resources`, crea una nueva carpeta llamada `api`. Copia tu archivo (ej. `openapi.yaml`) dentro de ella.
    
    - Ruta final: `src/main/resources/api/openapi.yaml`
        
2. **Verificar Paquetes:** En `src/main/java`, ya tendrás tu paquete base (ej. `com.ejemplo.api`). Dentro de este, crea los siguientes sub-paquetes si no existen:
    
    - `com.ejemplo.api.controller` (Para nuestros controladores)
        
    - `com.ejemplo.api.model` (Aquí moveremos los modelos generados)
        
    - `com.ejemplo.api.service` (Para la lógica de negocio)
        

Tu estructura debería verse así:

```
mi-api-rest/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/ejemplo/api/
│   │   │       ├── controller/
│   │   │       ├── model/
│   │   │       ├── service/
│   │   │       └── MiApiRestApplication.java
│   │   └── resources/
│   │       ├── api/
│   │       │   └── openapi.yaml  <-- Tu archivo OAS aquí
│   │       └── application.properties
└── pom.xml
```

---

## ⚙️ Paso 3: Configurar `pom.xml` para Generar Modelos

Ahora, le diremos a Maven cómo leer nuestro `openapi.yaml` y generar las clases POJO (Plain Old Java Objects) del modelo.

Abre tu archivo `pom.xml` en la raíz del proyecto.

1. **Añadir Dependencias (si faltaron):** Asegúrate de tener estas dependencias dentro de la etiqueta `<dependencies>`:
    
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
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
    ```
    
2. **Añadir el Plugin Generador:** Dentro de la etiqueta `<build>`, agrega la sección `<plugins>` (si no existe) y añade el siguiente plugin. Este es el motor que generará el código.
    
    XML
    
    ```
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
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
    
                            <generatorName>spring</generatorName>
    
                            <modelPackage>com.ejemplo.api.model</modelPackage>
    
                            <generateModels>true</generateModels>
                            <generateApis>false</generateApis>
                            <generateSupportingFiles>false</generateSupportingFiles>
    
                            <configOptions>
                                <useJakartaEe>true</useJakartaEe> <interfaceOnly>false</interfaceOnly>
                                <skipDefaultInterface>true</skipDefaultInterface>
                                <serializableModel>true</serializableModel>
                                <useBeanValidation>true</useBeanValidation> </configOptions>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            </plugins>
    </build>
    ```
    

---

## ☕ Paso 4: Generar y Mover los Modelos

Con el `pom.xml` configurado, vamos a generar las clases.

1. **Ejecutar Maven:** Abre una terminal en la raíz de tu proyecto y ejecuta el siguiente comando:
    
    Bash
    
    ```
    mvn clean openapi-generator:generate
    ```
    
    - **Nota:** Si tus alumnos usan un IDE, pueden hacerlo desde la pestaña "Maven" -> "Plugins" -> "openapi-generator" -> "openapi-generator:generate".
        
2. **Verificar Archivos Generados:** Este comando _no_ pone los archivos en `src/main/java`. Los crea en la carpeta `target`. Ve a: `target/generated-sources/openapi/src/main/java/com/ejemplo/api/model`
    
3. **Mover los Modelos:**
    
    - Copia todos los archivos `.java` que encuentres en ese directorio (`Producto.java`, `Error.java`, `Usuario.java`, etc.).
        
    - Pégalos en tu paquete de código fuente: `src/main/java/com/ejemplo/api/model`
        

¡Listo! Ahora tu proyecto "conoce" las estructuras de datos (Modelos/POJOs) definidas en tu API. Si usas Lombok, verás que las clases son limpias, solo con las anotaciones `@NotNull`, `@Size`, etc.

---

## ➡️ Paso 5: Crear el Controller (La Lógica API)

Aquí es donde implementamos los _endpoints_. El OAS nos dice _qué_ debemos construir, y ahora lo _construimos_.

Supongamos que tu OAS define un endpoint `POST /productos` que recibe un `Producto` y devuelve un `Producto`.

1. **Crear la Clase Controller:** En el paquete `com.ejemplo.api.controller`, crea una nueva clase Java, por ejemplo, `ProductoController.java`.
    
2. **Añadir Anotaciones:**
    
    - `@RestController`: Le dice a Spring que esta clase manejará peticiones HTTP.
        
    - `@RequestMapping("/api/v1")`: (Opcional) Define un prefijo base para todas las rutas en esta clase. Debe coincidir con tu OAS.
        
    - `@Validated`: Necesario para que Spring active las validaciones en los parámetros.
        
    
    Java
    
    ```
    package com.ejemplo.api.controller;
    
    import com.ejemplo.api.model.Producto; // <-- Importa tu modelo generado
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.validation.annotation.Validated;
    import org.springframework.web.bind.annotation.*;
    
    @RestController
    @RequestMapping("/api/v1") // Prefijo base de la API
    @Validated // Activa la validación
    public class ProductoController {
    
        // ... aquí irán los métodos
    }
    ```
    
3. **Implementar el Endpoint (Método):**
    
    - Usamos `@PostMapping("/productos")` para mapear la ruta y el método HTTP.
        
    - Usamos `@RequestBody` para indicarle a Spring que convierta el JSON de la petición en un objeto `Producto`.
        
    - Usamos `@Valid` _antes_ del `@RequestBody` para que Spring revise las anotaciones de validación del modelo (ej. `@NotNull`) antes de que nuestro método se ejecute.
        
    - Devolvemos un `ResponseEntity<Producto>` para tener control total sobre la respuesta (código HTTP, headers y cuerpo).
        
    
    Java
    
    ```
    // ... dentro de la clase ProductoController ...
    
    @PostMapping("/productos")
    public ResponseEntity<Producto> crearProducto(
        @Valid @RequestBody Producto productoRequest
    ) {
        // Por ahora, solo simularemos que lo guardamos
        // y le asignamos un ID
        System.out.println("Producto recibido: " + productoRequest.getNombre());
    
        // Simulamos que la DB le asigna un ID
        productoRequest.setId(1L); 
    
        // Devolvemos el producto creado con un código 201 (CREATED)
        return new ResponseEntity<>(productoRequest, HttpStatus.CREATED);
    }
    
    @GetMapping("/productos/{id}")
    public ResponseEntity<Producto> obtenerProductoPorId(
        @PathVariable("id") Long id
    ) {
        // Simulación: creamos un producto de prueba
        Producto productoEncontrado = new Producto();
        productoEncontrado.setId(id);
        productoEncontrado.setNombre("Producto de prueba");
        productoEncontrado.setPrecio(99.99);
    
        // Devolvemos el producto con código 200 (OK)
        return ResponseEntity.ok(productoEncontrado);
    }
    ```
    

---

## 🛠️ Paso 6: (Opcional pero recomendado) Añadir Capa de Servicio

Los controladores no deben tener lógica de negocio (cálculos, acceso a base de datos). Deben delegar esa tarea a una **Capa de Servicio**.

1. **Crear `ProductoService`:** En `com.ejemplo.api.service`, crea una clase `ProductoService.java`.
    
2. **Anotar con `@Service`:** Esto le dice a Spring que gestione esta clase como un "bean".
    
    Java
    
    ```
    package com.ejemplo.api.service;
    
    import com.ejemplo.api.model.Producto;
    import org.springframework.stereotype.Service;
    
    @Service
    public class ProductoService {
    
        public Producto guardarProducto(Producto producto) {
            // Aquí iría la lógica para guardar en la base de datos (ej. usando un Repository)
            System.out.println("Guardando producto en el servicio: " + producto.getNombre());
    
            // Simulamos que la DB le asigna un ID
            producto.setId(1L);
            return producto;
        }
    
        public Producto buscarProducto(Long id) {
            // Aquí iría la lógica de búsqueda en la DB
            Producto productoEncontrado = new Producto();
            productoEncontrado.setId(id);
            productoEncontrado.setNombre("Producto de prueba desde Servicio");
            productoEncontrado.setPrecio(99.99);
            return productoEncontrado;
        }
    }
    ```
    
3. **Usar el Servicio en el Controller:** Modifica tu `ProductoController` para "inyectar" (`@Autowired`) el servicio y usarlo.
    
    Java
    
    ```
    // ... en ProductoController.java ...
    import com.ejemplo.api.service.ProductoService;
    import org.springframework.beans.factory.annotation.Autowired;
    
    @RestController
    @RequestMapping("/api/v1")
    @Validated
    public class ProductoController {
    
        // Inyección de dependencias: Spring nos "pasa" una instancia del servicio
        @Autowired
        private ProductoService productoService;
    
        @PostMapping("/productos")
        public ResponseEntity<Producto> crearProducto(
            @Valid @RequestBody Producto productoRequest
        ) {
            // El controller delega la lógica al servicio
            Producto productoGuardado = productoService.guardarProducto(productoRequest);
    
            return new ResponseEntity<>(productoGuardado, HttpStatus.CREATED);
        }
    
        @GetMapping("/productos/{id}")
        public ResponseEntity<Producto> obtenerProductoPorId(
            @PathVariable("id") Long id
        ) {
            // El controller delega la lógica al servicio
            Producto productoEncontrado = productoService.buscarProducto(id);
    
            return ResponseEntity.ok(productoEncontrado);
        }
    }
    ```
    

---

## 🧪 Paso 7: Probar con Postman

¡Es la hora de la verdad!

1. **Ejecutar la Aplicación:** Ejecuta tu clase principal `MiApiRestApplication.java` (o usa `mvn spring-boot:run`).
    
2. **Abrir Postman.**
    
3. **Probar el `POST /productos`:**
    
    - **Método:** `POST`
        
    - **URL:** `http://localhost:8080/api/v1/productos`
        
    - **Pestaña "Body"**:
        
        - Selecciona `raw` y `JSON`.
            
        - Escribe el JSON de tu producto (¡los nombres deben coincidir con tu modelo!).
            
        
        JSON
        
        ```
        {
          "nombre": "Mi Primer Producto",
          "precio": 150.75,
          "categoria": "tecnologia"
        }
        ```
        
    - **¡Enviar!** Deberías recibir una respuesta `201 Created` con el JSON del producto, ahora incluyendo el ID "1".
        
4. **Probar el `GET /productos/{id}`:**
    
    - **Método:** `GET`
        
    - **URL:** `http://localhost:8080/api/v1/productos/1` (o el ID que quieras probar).
        
    - **¡Enviar!** Deberías recibir una respuesta `200 OK` con el JSON del producto de prueba.