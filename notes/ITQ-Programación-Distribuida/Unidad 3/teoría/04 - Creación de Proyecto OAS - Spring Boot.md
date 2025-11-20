# Creación de Proyecto OAS - Spring Boot

Enfoque "API-First" con OpenAPI (OAS) y Spring Boot.

Aquí tienes una guía paso a paso asumiendo que ya tienes tu archivo `.yaml` o `.json` de OpenAPI.

---

## 🚀 Paso 1: Crear el proyecto en Spring Initializr

Primero, generaremos la estructura base de nuestro proyecto Spring Boot.

1. Ve a [start.spring.io](https://start.spring.io/).

2. Configura tu proyecto:

    - **Project:** Maven
    - **Language:** Java
    - **Spring Boot:** Elige una versión estable (ej. 3.2.x).
    - **Project Metadata:**
        - **Group:** `com.ejemplo` (o el de tu organización)
        - **Artifact:** `oas-api-rest`
        - **Name:** `oas-api-rest`
        - **Package name:** `com.ejemplo.api` (¡Importante! Usaremos este como base).

3. **Añadir dependencias:** Busca y agrega las siguientes dependencias esenciales:

    - **Spring Web:** Necesario para crear controladores REST.

4. Haz clic en **"Generate"**. Esto descargará un archivo `.zip`.

5. Descomprime el archivo y abre el proyecto en tu IDE favorito (IntelliJ, Eclipse, VSCode).

---

## 📦 Paso 2: Estructura de paquetes y OAS

Una buena organización es clave.

1. **Colocar el OAS:** Dentro de la carpeta `src/main/resources`, crea una nueva carpeta llamada `api`. Copia tu archivo (ej. `openapi.yaml`) dentro de ella.

    - Ruta final: `src/main/resources/api/openapi.yaml`

2. **Verificar paquetes:** En `src/main/java`, ya tendrás tu paquete base (ej. `com.ejemplo.api`). Dentro de este, crea los siguientes sub-paquetes si no existen:

    - `com.ejemplo.api.controller` (Para nuestros controladores)

    - `com.ejemplo.api.model` (Aquí moveremos los modelos generados)

    - `com.ejemplo.api.service` (Para la lógica de negocio)

Tu estructura debería verse así:

```text
oas-api-rest/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/ejemplo/api/
│   │   │       ├── controller/
│   │   │       ├── model/
│   │   │       ├── service/
│   │   │       └── OasApiRestApplication.java
│   │   └── resources/
│   │       ├── api/
│   │       │   └── openapi.yaml  <-- Tu archivo OAS aquí
│   │       └── application.properties
└── pom.xml
```

---

## ⚙️ Paso 3: Configurar `pom.xml` para generar modelos

Ahora, le diremos a Maven cómo leer nuestro `openapi.yaml` y generar las clases POJO (Plain Old Java Objects) del modelo.

Abre tu archivo `pom.xml` en la raíz del proyecto.

1. **Añadir dependencias que faltaron:** Asegúrate de tener estas dependencias dentro de la etiqueta `<dependencies>`:

    ```xml
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
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>

        <dependency>
            <groupId>io.swagger.core.v3</groupId>
            <artifactId>swagger-annotations</artifactId>
            <version>2.2.19</version>
        </dependency>
    ```

2. **Añadir el plugin generador:** Dentro de la etiqueta `<build>`, agrega la sección `<plugins>` (si no existe) y añade el siguiente plugin. Este es el motor que generará el código.

    ```xml
            <plugin>
                <groupId>org.openapitools</groupId>
                <artifactId>openapi-generator-maven-plugin</artifactId>
                <version>7.1.0</version>
                <executions>
                    <execution>
                        <id>generate-sources</id>
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
                                <useJakartaEe>true</useJakartaEe>
                                <interfaceOnly>false</interfaceOnly>
                                <skipDefaultInterface>true</skipDefaultInterface>
                                <serializableModel>true</serializableModel>
                                <useBeanValidation>true</useBeanValidation>
                            </configOptions>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
    ```

---

## ☕ Paso 4: Generar y mover los modelos

Con el `pom.xml` configurado, vamos a generar las clases.

1. **Ejecutar Maven:** Abre una terminal en la raíz de tu proyecto y ejecuta el siguiente comando:

	**Opción 1:**
    ```bash
	   mvn generate-sources
    ```

	**Opción 2:**

	```bash
	mvn openapi-generator:generate
	mvn openapi-generator:generate@generate-sources
	```

	**Opción 3:**

	```bash
	mvn clean generate-sources
	```

    - **Nota:** Si se usa un IDE, puede hacerse desde la pestaña "Maven" -> "Plugins" -> "openapi-generator" -> "openapi-generator:generate".

2. **Verificar archivos generados:** Este comando _no_ pone los archivos en `src/main/java`. Los crea en la carpeta `target`. Ve a: `target/generated-sources/openapi/src/main/java/com/ejemplo/api/model`

3. **Mover los modelos:**

    - Copia todos los archivos `.java` que encuentres en ese directorio (por ejemplo: `Reservation.java`, `Confirmation.java`, `Error.java`, etc.).

    - Pégalos en tu paquete de código fuente: `src/main/java/com/ejemplo/api/model`

4. **Desactivar generación de modelos:** Comentar el plugin que permite generar los modelos.

¡Listo! Ahora tu proyecto "conoce" las estructuras de datos (Modelos/POJOs) definidas en tu API. 

---

## ➡️ Paso 5: Crear el Controller (Lógica del API)

Aquí es donde implementamos los _endpoints_. El OAS nos dice _qué_ debemos construir, y ahora lo _construimos_.

Supongamos que tu OAS define un endpoint `POST /reservations` que recibe una `Reservation` y devuelve un `Confirmation`.

1. **Crear la Clase Controller:** En el paquete `com.ejemplo.api.controller`, crea una nueva clase Java, por ejemplo, `ReservationController.java`.

2. **Añadir Anotaciones:**

    - `@RestController`: Le dice a Spring que esta clase manejará peticiones HTTP.

    - `@RequestMapping("/api/v1")`: (Opcional) Define un prefijo base para todas las rutas en esta clase. Debe coincidir con tu OAS.

    - `@Validated`: Necesario para que Spring active las validaciones en los parámetros.

    ```java
    package com.ejemplo.api.controller;

    import com.ejemplo.api.model.Confirmation; // <-- Importa el modelo generado
    import com.ejemplo.api.model.Reservation; // <-- Importa el modelo generado

    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.validation.annotation.Validated;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.PostMapping;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    import jakarta.validation.Valid; // --> Permite la validación de los request bodies

    @RestController
    @RequestMapping("/api/v1") // Prefijo base de la API
    @Validated // Activa la validación
    public class ReservationController {
        
        // ... aquí irán los métodos
    
    }
    ```

3. **Implementar el Endpoint (Método):**

    - Usamos `@PostMapping("/reservations")` para mapear la ruta y el método HTTP.

    - Usamos `@RequestBody` para indicarle a Spring que convierta el JSON de la petición en un objeto `Reservation`.

    - Usamos `@Valid` _antes_ del `@RequestBody` para que Spring revise las anotaciones de validación del modelo (ej. `@NotNull`) antes de que nuestro método se ejecute.

    - Devolvemos un `ResponseEntity<Confirmation>` para tener control total sobre la respuesta (código HTTP, headers y cuerpo).

    ```java
	    // ... dentro de la clase ReservationController ...
	    
	    @PostMapping("/reservations")
	    public ResponseEntity<Confirmation> createReservation(
	        @Valid @RequestBody Reservation reservationRequest) 
	    {
	        System.out.println("Controller - Reservation recibida: " + reservationRequest.getIdClient());
	
	        // Simulamos que la DB le asigna un ID
	        Confirmation confirmationResponse = new Confirmation();
	        confirmationResponse.setIdReservation(12345); // ID simulado
	        confirmationResponse.setIdRoom(5); // Sala asignada simulada
	        confirmationResponse.setInstructor("Juan Pérez"); // Instructor asignado simulado
	        confirmationResponse.setDiscount(null); // Sin descuento por defecto
	    
	        // Devolvemos el reservation creado con un código 201 (CREATED)
	        return new ResponseEntity<>(confirmationResponse, HttpStatus.CREATED);
	    }
    ```

    - Se agrega otro método de ejemplo implementando la operación GET.

    ```java
	    @GetMapping("/reservations/{reservationId}")
	    public ResponseEntity<Confirmation> getReservationById(@PathVariable("reservationId") Integer reservationId) 
	    {
	        System.out.println("Controller - Buscando Reservation con ID: " + reservationId);
	
	        // Validación básica del ID
	        if (reservationId == null || reservationId < 1 || reservationId > 999999) {
	            return ResponseEntity.notFound().build();
	        }
	        
	        // Simulamos buscar la reserva en la base de datos
	        // En un caso real, aquí harías: reservationService.findById(reservationId)
	        
	        // Simulamos que encontramos la reserva
	        Confirmation confirmationResponse = new Confirmation();
	        confirmationResponse.setIdReservation(reservationId);
	        confirmationResponse.setIdRoom(8); // Sala asignada simulada
	        confirmationResponse.setInstructor("Ana López"); // Instructor asignado simulado
	        confirmationResponse.setDiscount(15.00); // Descuento simulado
	        
	        // Devolvemos la confirmación con código 200 (OK)
	        return ResponseEntity.ok(confirmationResponse);
	    }
    ```

## 🛠️ Paso 6: (Opcional pero recomendado) Añadir Capa de Servicio

Los controladores no deben tener lógica de negocio (cálculos, acceso a base de datos). Deben delegar esa tarea a una **Capa de Servicio**.

1. **Crear `ReservationService`:** En `com.ejemplo.api.service`, crea una clase `ReservationService.java`.

2. **Anotar con `@Service`:** Esto le dice a Spring que gestione esta clase como un "bean".

    ```java
    package com.ejemplo.api.service;

    import org.springframework.stereotype.Service;

    import com.ejemplo.api.model.Confirmation;
    import com.ejemplo.api.model.Reservation;

    @Service
    public class ReservationService {

        public Confirmation createReservation(Reservation reservation) {
            System.out.println("Service - Reservation recibida: " + reservation.getIdClient());

            // Aquí iría la lógica para guardar en la base de datos

            // Simulamos que la DB le asigna un ID
            Confirmation confirmationResponse = new Confirmation();
            confirmationResponse.setIdReservation(12345); // ID simulado
            confirmationResponse.setIdRoom(5); // Sala asignada simulada
            confirmationResponse.setInstructor("Juan Pérez"); // Instructor asignado simulado
            confirmationResponse.setDiscount(null); // Sin descuento por defecto

            return confirmationResponse;
        }

        public Confirmation getReservationById(Integer reservationId) {
            System.out.println("Service - Buscando Reservation con ID: " + reservationId);

            // Aquí iría la lógica para buscar la reserva en la base de datos

            // Simulamos que encontramos la reserva
            Confirmation confirmationResponse = new Confirmation();
            confirmationResponse.setIdReservation(reservationId);
            confirmationResponse.setIdRoom(8); // Sala asignada simulada
            confirmationResponse.setInstructor("Ana López"); // Instructor asignado simulado
            confirmationResponse.setDiscount(15.00); // Descuento simulado

            return confirmationResponse;
        }
    }
    ```

3. **Usar el Servicio en el Controller:** Modifica tu `ReservationController` para "inyectar" (`@Autowired`) el servicio y usarlo.

    ```java
    // ... en ReservationController.java ...
    package com.ejemplo.api.controller;

    import com.ejemplo.api.model.ApiError;
    import com.ejemplo.api.model.Confirmation; // <-- Importa el modelo generado
    import com.ejemplo.api.model.Reservation; // <-- Importa el modelo generado
    import com.ejemplo.api.service.ReservationService;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.validation.annotation.Validated;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.PostMapping;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    import jakarta.validation.Valid; // --> Permite la validación de los request bodies 

    @RestController
    @RequestMapping("/api/v1") // Prefijo base de la API
    @Validated // Activa la validación
    public class ReservationController {

        // Inyección de dependencias: Spring nos "pasa" una instancia del servicio
        @Autowired
        private ReservationService reservationService;

        @PostMapping("/reservations")
        public ResponseEntity<Confirmation> createReservation(
            @Valid @RequestBody Reservation reservationRequest) 
        {
            System.out.println("Reservation recibido: " + reservationRequest.getIdClient());

            // El controller delega la lógica al servicio
            Confirmation confirmationResponse = reservationService.createReservation(reservationRequest);
        
            // Devolvemos el reservation creado con un código 201 (CREATED)
            return new ResponseEntity<>(confirmationResponse, HttpStatus.CREATED);
        }

        @GetMapping("/reservations/{reservationId}")
        public ResponseEntity<?> getReservationById(@PathVariable("reservationId") Integer reservationId) 
        {
            System.out.println("Buscando Reservation con ID: " + reservationId);

            // Validación básica del ID
            if (reservationId == null || reservationId < 1 || reservationId > 999999) {
                ApiError errorResponse = new ApiError();
                errorResponse.setCode("400");
                errorResponse.setMessage("El ID de la reserva es inválido. Debe estar entre 1 y 999999.");
                errorResponse.setDetails("ID proporcionado: " + reservationId);
                
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
            }
            
            // El controller delega la lógica al servicio
            Confirmation confirmationResponse = reservationService.getReservationById(reservationId);
            
            // Devolvemos la confirmación con código 200 (OK)
            return ResponseEntity.ok(confirmationResponse);
        }
    }
    ```

---

## 🧪 Paso 7: Probar con Postman

¡Es la hora de la verdad!

1. **Ejecutar la Aplicación:** Ejecuta tu clase principal `OasApiRestApplication.java` (o usa `mvn spring-boot:run`).

2. **Abrir Postman.**

3. **Probar el `POST /reservations`:**

    - **Método:** `POST`

    - **URL:** `http://localhost:8080/api/v1/reservations`

    - **Pestaña "Body"**:

        - Selecciona `raw` y `JSON`.

        - Escribe el JSON de tu reservation (¡los nombres deben coincidir con tu modelo!).

        ```json
        {
            "idReservation": 12345,
            "idRoom": 5,
            "instructor": "Juan Pérez",
            "discount": null
        }
        ```

    - **¡Enviar!** Deberías recibir una respuesta `201 Created` con el JSON del `confirmation`, ahora incluyendo el idReservation "12345".

4. **Probar el `GET /reservations/{id}`:**

    - **Método:** `GET`

    - **URL:** `http://localhost:8080/api/v1/reservations/1` (o el ID que quieras probar).

    - **¡Enviar!** Deberías recibir una respuesta `200 OK` con el JSON del `confirmation` de prueba.
