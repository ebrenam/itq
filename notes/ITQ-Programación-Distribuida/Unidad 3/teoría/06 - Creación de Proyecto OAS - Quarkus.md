# Creación de Proyecto OAS - Quarkus

Enfoque "API-First" con OpenAPI (OAS) y Quarkus.

Quarkus es una opción moderna para diseñar REST. Su enfoque "API-First" es muy potente, aunque un poco diferente al de Spring Boot.

Aquí tienes la guía paso a paso para asumiendo que ya tienes tu archivo `.yaml` o `.json` de OpenAPI.

---

## 🚀 Paso 1: Crear el Proyecto en `code.quarkus.io`

Generaremos la estructura base del proyecto.

1. Ve a [code.quarkus.io](https://code.quarkus.io/).

2. Configura tu proyecto:

    - **Build Tool:** Maven
    - **Group ID:** `com.ejemplo.api`
    - **Artifact ID:** `oas-api-rest`
    - **Java Version:** `21`

3. **Añadir Extensiones (Dependencias):** Busca y agrega las siguientes extensiones esenciales:

    - **REST:** Implementación de Jakarta REST que utiliza procesamiento en tiempo de compilación y Vert.x. Esta extensión no es compatible con la extensión quarkus-resteasy ni con ninguna de las extensiones que dependen de ella.

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

```text
oas-api-rest/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/ejemplo/api/
│   │   │       ├── resource/
│   │   │       ├── model/
│   │   │       └── service/
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

1. **Agregar propiedades para OpenAPI Generator:** En la sección `<properties>`, después de la línea `<surefire-plugin.version>3.5.4</surefire-plugin.version>`, agrega.

```xml  
        <openapi-generator-maven-plugin.version>7.1.0</openapi-generator-maven-plugin.version>
        <javax.validation-api.version>2.0.1.Final</javax.validation-api.version>
```


2. **Añadir Dependencias que faltaron:** Asegúrate de tener estas dependencias dentro de la etiqueta `<dependencies>`:

```xml  
        <!-- OpenAPI Generator dependencies para modelos -->
        <dependency>
            <groupId>javax.validation</groupId>
            <artifactId>validation-api</artifactId>
            <version>${javax.validation-api.version}</version>
        </dependency>

        <dependency>
            <groupId>io.swagger.core.v3</groupId>
            <artifactId>swagger-annotations</artifactId>
            <version>2.2.16</version>
        </dependency>
        
        <dependency>
            <groupId>io.quarkus</groupId>
            <artifactId>quarkus-rest-jackson</artifactId>
        </dependency>
```

3. **Añadir el Plugin Generador:** En la sección `<plugins>` dentro de `<build>`, después del plugin `maven-compiler-plugin`, agrega:

```xml
            <plugin>
                <groupId>org.openapitools</groupId>
                <artifactId>openapi-generator-maven-plugin</artifactId>
                <version>${openapi-generator-maven-plugin.version}</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>generate</goal>
                        </goals>
                        <configuration>
                            <inputSpec>${project.basedir}/src/main/resources/api/openapi.yaml</inputSpec>
                            <generatorName>java</generatorName>
                            <library>native</library>
                            <output>${project.build.directory}/generated-sources/openapi</output>
                            <modelPackage>com.ejemplo.api.model</modelPackage>
                            <generateApis>false</generateApis>
                            <generateApiTests>false</generateApiTests>
                            <generateApiDocumentation>false</generateApiDocumentation>
                            <generateModels>true</generateModels>
                            <generateModelTests>false</generateModelTests>
                            <generateModelDocumentation>false</generateModelDocumentation>
                            <generateSupportingFiles>false</generateSupportingFiles>
    
                            <configOptions>
                                <sourceFolder>src/main/java</sourceFolder>
                                <dateLibrary>java8</dateLibrary>
                                <useBeanValidation>true</useBeanValidation>
                                <performBeanValidation>true</performBeanValidation>
                                <useJakartaEe>true</useJakartaEe>
                                <serializationLibrary>jackson</serializationLibrary>
                                <openApiNullable>false</openApiNullable>
                            </configOptions>
                        </configuration>
                    </execution>
                </executions>
            </plugin>     

            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>build-helper-maven-plugin</artifactId>
                <version>3.4.0</version>
                <executions>
                    <execution>
                        <id>add-source</id>
                        <phase>generate-sources</phase>
                        <goals>
                            <goal>add-source</goal>
                        </goals>
                        <configuration>
                            <sources>
                                <source>${project.build.directory}/generated-sources/openapi/src/main/java</source>
                            </sources>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
```

## ☕ Paso 4: Generar y Mover los Modelos

Este paso es idéntico al de Spring.

1. **Ejecutar Maven:** Abre una terminal en la raíz de tu proyecto y ejecuta:

    ```bash
    mvn clean compile
    ```

    (O usa la interfaz gráfica de tu IDE).

2. **Verificar Archivos Generados:** Los archivos aparecerán en: `target/generated-sources/openapi/src/main/java/com/ejemplo/api/model`

3. **Desactivar generación de modelos:** Comentar el plugin que permite generar los modelos.

4. **Mover los Modelos:**

    - Copia todos los archivos `.java` de ese directorio (`Reservation.java`, `Confirmation.java`, `Error.java`, etc.).

    - Pégalos en tu paquete de código fuente: `src/main/java/com/ejemplo/api/model`

Ahora tu proyecto Quarkus reconoce las clases del modelo.

---

## ➡️ Paso 5: Crear el Resource (Lógica del API)

En JAX-RS (Quarkus), los _Controllers_ se llaman _Resources_. Usan anotaciones diferentes a Spring.

Supongamos que tu OAS define `POST /reservations` y `GET /reservations/{id}`.

1. **Crear la Clase Resource:** En `com.ejemplo.api.resource`, crea una nueva clase Java, `ReservationResource.java`.

2. **Añadir Anotaciones JAX-RS:**

    - `@Path("/api/v1")`: Define el prefijo base para todas las rutas en esta clase.

    - `@Produces(MediaType.APPLICATION_JSON)`: Indica que, por defecto, los métodos _devuelven_ JSON.

    - `@Consumes(MediaType.APPLICATION_JSON)`: Indica que, por defecto, los métodos _reciben_ JSON.

    - Importa `jakarta.ws.rs.*` para estas anotaciones.

```java
package com.ejemplo.api.resource;

import com.ejemplo.api.model.Confirmation; // <-- Importa el modelo generado
import com.ejemplo.api.model.Reservation; // <-- Importa el modelo generado

import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/api/v1") // Prefijo base de la API
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ReservationResource {

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

```java
    // ... dentro de la clase ReservationResource ...
    
    @POST
    @Path("/reservations")
    public Response createReservation(@Valid Reservation reservationRequest)
    {
        // Por ahora, solo simularemos que lo guardamos
        System.out.println("Resource - Reservation recibido: " + reservationRequest.getIdClient());

        // Simulamos que la DB le asigna un ID
        Confirmation confirmationResponse = new Confirmation();
        confirmationResponse.setIdReservation(12345); // ID simulado
        confirmationResponse.setIdRoom(5); // Sala asignada simulada
        confirmationResponse.setInstructor("Juan Pérez"); // Instructor asignado simulado
        confirmationResponse.setDiscount(null); // Sin descuento por defecto

        // Devolvemos la respuesta de confirmación con código 201 (CREATED)
        // La sintaxis de JAX-RS es un poco diferente
        return Response.status(Response.Status.CREATED).entity(confirmationResponse).build();
    }
    
    @GET
    @Path("/reservations/{reservationId}")
    public Response getReservationById(@PathParam("reservationId") Integer reservationId) // <-- Nota el @PathParam
    {
        System.out.println("Resource - Buscando Reservation con ID: " + reservationId);

        // Simulamos buscar la reserva en la base de datos
        // En un caso real, aquí harías: reservationService.findById(reservationId)

        // Simulamos que encontramos la reserva
        Confirmation confirmationResponse = new Confirmation();
        confirmationResponse.setIdReservation(reservationId);
        confirmationResponse.setIdRoom(8); // Sala asignada simulada
        confirmationResponse.setInstructor("Ana López"); // Instructor asignado simulado
        confirmationResponse.setDiscount(15.00); // Descuento simulado
    
        // Devolvemos el reservation con código 200 (OK)
        return Response.ok(confirmationResponse).build();
    }
```

---

## 🛠️ Paso 6: (Opcional pero recomendado) Añadir Capa de Servicio

La lógica de negocio debe estar separada. En Quarkus, esto se hace con CDI (Contexts and Dependency Injection).

1. **Crear `ReservationService`:** En `com.ejemplo.api.service`, crea `ReservationService.java`.

2. **Anotar con `@ApplicationScoped`:** Esta es la anotación estándar de CDI (equivalente a `@Service` en Spring) para crear un "bean" que vive durante toda la aplicación.

```java
package com.ejemplo.api.service;

import com.ejemplo.api.model.Confirmation;
import com.ejemplo.api.model.Reservation;

import jakarta.enterprise.context.ApplicationScoped; // <-- Importante

@ApplicationScoped // Le dice a Quarkus que gestione esta clase como un servicio
public class ReservationService {

    public Confirmation createReservation(Reservation reservation)
    {
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

    public Confirmation getReservationById(Integer reservationId)
    {
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

3. **Usar el Servicio en el Resource:** Modifica tu `ReservationResource` para "inyectar" el servicio.

    - En CDI (Quarkus), usamos `@Inject` (de `jakarta.inject.Inject`) en lugar de `@Autowired`.

```java
// ... en ReservationResource.java ...
package com.ejemplo.api.resource;

import com.ejemplo.api.model.ApiError;
import com.ejemplo.api.model.Confirmation; // <-- Importa el modelo generado
import com.ejemplo.api.model.Reservation; // <-- Importa el modelo generado
import com.ejemplo.api.service.ReservationService; // <-- Importa el servicio

import jakarta.inject.Inject; // <-- Importante para inyección de dependencias
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/api/v1") // Prefijo base de la API
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ReservationResource {

    // Inyección de dependencias con CDI
    @Inject
    ReservationService reservationService; // <-- Inyecta el servicio

    @POST
    @Path("/reservations")
    public Response createReservation(@Valid Reservation reservationRequest)
    {
        // Por ahora, solo simularemos que lo guardamos
        System.out.println("Resource - Reservation recibido: " + reservationRequest.getIdClient());

        // Simulamos que la DB le asigna un ID
        Confirmation confirmationResponse = reservationService.createReservation(reservationRequest);

        // Devolvemos la respuesta de confirmación con código 201 (CREATED)
        return Response.status(Response.Status.CREATED).entity(confirmationResponse).build();
    }
    
    @GET
    @Path("/reservations/{reservationId}")
    public Response getReservationById(@PathParam("reservationId") Integer reservationId) // <-- Nota el @PathParam
    {
        System.out.println("Resource - Buscando Reservation con ID: " + reservationId);

        // Validación básica del ID
        if (reservationId == null || reservationId < 1 || reservationId > 999999) {
            ApiError errorResponse = new ApiError();
            errorResponse.setCode("400");
            errorResponse.setMessage("El ID de la reserva es inválido. Debe estar entre 1 y 999999.");
            errorResponse.setDetails("ID proporcionado: " + reservationId);

            return Response.status(Response.Status.BAD_REQUEST).entity(errorResponse).build();
        }

        // Simulamos que encontramos la reserva
        // El controller delega la lógica al servicio
        Confirmation confirmationResponse = reservationService.getReservationById(reservationId);
    
        // Devolvemos el reservation con código 200 (OK)
        return Response.ok(confirmationResponse).build();
    }
}
```

---

## 🧪 Paso 7: Probar con Postman

Quarkus brilla por su _live reload_.

1. **Ejecutar la Aplicación (Modo Desarrollo):** Abre una terminal en la raíz del proyecto y ejecuta:

    ```bash
    mvn quarkus:dev
    ```

    Verás el logo de Quarkus. ¡No cierres esta terminal! Quarkus recargará automáticamente los cambios que hagas en el código.

2. **Abrir Postman.**

3. **Probar el `POST /reservations`:**

    - **Método:** `POST`

    - **URL:** `http://localhost:8080/api/v1/reservations` (Quarkus usa el puerto 8080 por defecto).

    - **Pestaña "Body"**: `raw` y `JSON`.

        ```json
        {
            "idReservation": 12345,
            "idRoom": 5,
            "instructor": "Juan Pérez",
            "discount": null
        }
        ```

    - **¡Enviar!** Deberías recibir una respuesta `201 Created` con el JSON y el ID "1".

4. **Probar el `GET /reservations/{id}`:**

    - **Método:** `GET`

    - **URL:** `http://localhost:8080/api/v1/reservations/1`

    - **¡Enviar!** Deberías recibir una respuesta `200 OK` con el reservation simulado desde el servicio.
