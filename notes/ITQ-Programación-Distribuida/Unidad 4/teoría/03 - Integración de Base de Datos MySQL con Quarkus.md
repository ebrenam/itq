# Integración de Base de Datos MySQL con Quarkus

Este documento continúa desde donde dejamos en la **"Creación de Proyecto OAS - Quarkus"** de la Unidad 3 y te guiará paso a paso para agregar persistencia con MySQL y completar las operaciones CRUD.

---

## 📋 Requisitos Previos

- Tener completado el proyecto del documento anterior
- MySQL Server instalado y ejecutándose
- Conocimientos básicos de SQL

---

## 🗄️ Paso 1: Validación de ls configurar MySQL y Base de Datos

Primero, necesitamos preparar nuestra base de datos.

### 1.1 Conectar a MySQL

Se puede realizar la conexión de diferentes formas, en este punto se recomienda utilizar un cliente como `MySQL Workbench` o `DBeaver` que presentan una interfaz gráfica.

Abre el cliente de tu elección y conecta con los siguientes datos:

| Dato     | Valor              |
| -------- | ------------------ |
| Server   | localhost          |
| Port     | 3306               |
| Database | reservation_system |
| Username | quarkus_user       |
| Password | quarkus_password   |

> Si no cuentas con una Base de Datos ya creada, necesitas realizar los pasos del punto `8.4 Configuración con Volúmenes Docker (Recomendado para producción)` del documento **Configuración de Base de Datos MySQL con Docker**.

---

## 📦 Paso 2: Agregar Dependencias de Base de Datos al `pom.xml`

Abre tu archivo `pom.xml` y agrega las siguientes dependencias dentro de la sección `<dependencies>`:

```bash
<!-- Dependencias para MySQL y Hibernate ORM -->
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-hibernate-orm</artifactId>
</dependency>

<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-jdbc-mysql</artifactId>
</dependency>

<!-- Dependencia para Hibernate ORM con Panache (simplifica JPA) -->
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-hibernate-orm-panache</artifactId>
</dependency>
``` 

**💡 Explicación:**

- `quarkus-hibernate-orm`: Proporciona JPA/Hibernate para el mapeo objeto-relacional
- `quarkus-jdbc-mysql`: Driver JDBC específico para MySQL
- `quarkus-hibernate-orm-panache`: Simplifica las operaciones de base de datos con un patrón Active Record

---

## ⚙️ Paso 3: Configurar la Conexión a la Base de Datos

Abre el archivo `src/main/resources/application.properties` y agrega la configuración de la base de datos:

```bash
# Configuración de la base de datos MySQL
quarkus.datasource.db-kind=mysql
quarkus.datasource.username=quarkus_user
quarkus.datasource.password=quarkus_password
quarkus.datasource.jdbc.url=jdbc:mysql://localhost:3306/reservation_system

# Configuración de Hibernate
quarkus.hibernate-orm.database.generation=none
quarkus.hibernate-orm.log.sql=true
quarkus.hibernate-orm.sql-load-script=no-file

# Configuración del pool de conexiones
quarkus.datasource.jdbc.min-size=2
quarkus.datasource.jdbc.max-size=10
``` 

**💡 Explicación de las propiedades:**

- `db-kind`: Tipo de base de datos
- `username/password`: Credenciales de acceso
- `jdbc.url`: URL de conexión a MySQL
- `database.generation=none`: No generar esquema automáticamente (ya lo creamos manualmente)
- `log.sql=true`: Mostrar las consultas SQL en los logs (útil para desarrollo)

---

## 🏗️ Paso 4: Crear la Entidad JPA

En lugar de usar solo el modelo generado por OpenAPI, crearemos una entidad JPA que mapee directamente a nuestra tabla de base de datos.

### 4.1 Crear el Paquete Entity

Crea un nuevo paquete: `src/main/java/com/ejemplo/api/entity`

### 4.2 Crear la Entidad ReservationEntity

Crea el archivo `ReservationEntity.java` en el paquete `entity`:

```bash
package com.ejemplo.api.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservations")
public class ReservationEntity extends PanacheEntity {

    @Column(name = "id_reservation", insertable = false, updatable = false)
    public Long idReservation;

    @Column(name = "id_client", nullable = false)
    public Integer idClient;

    @Column(name = "id_room", nullable = false)
    public Integer idRoom;

    @Column(name = "instructor", length = 100)
    public String instructor;

    @Column(name = "discount", precision = 5, scale = 2)
    public BigDecimal discount;

    @Column(name = "created_at", updatable = false)
    public LocalDateTime createdAt;

    @Column(name = "updated_at")
    public LocalDateTime updatedAt;

    // Métodos de ciclo de vida de JPA
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Método toString para debugging
    @Override
    public String toString() {
        return "ReservationEntity{" +
                "id=" + id +
                ", idReservation=" + idReservation +
                ", idClient=" + idClient +
                ", idRoom=" + idRoom +
                ", instructor='" + instructor + '\'' +
                ", discount=" + discount +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
``` 

**💡 Explicación:**

- Extendemos `PanacheEntity` que nos da un campo `id` automático y métodos CRUD básicos
- `@PrePersist` y `@PreUpdate` manejan automáticamente las fechas de creación y actualización
- Los campos son públicos (patrón de Panache) para simplificar el acceso

---

## 🔄 Paso 5: Crear el Mapper para Conversión de Datos

Necesitamos convertir entre nuestros modelos OpenAPI y las entidades JPA.

### 5.1 Crear el Paquete Mapper

Crea el paquete: `src/main/java/com/ejemplo/api/mapper`

### 5.2 Crear ReservationMapper

Crea el archivo `ReservationMapper.java`:

```bash
package com.ejemplo.api.mapper;

import com.ejemplo.api.entity.ReservationEntity;
import com.ejemplo.api.model.Confirmation;
import com.ejemplo.api.model.Reservation;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ReservationMapper {

    /**
     * Convierte de modelo OpenAPI a entidad JPA
     */
    public ReservationEntity toEntity(Reservation reservation) {
        if (reservation == null) {
            return null;
        }

        ReservationEntity entity = new ReservationEntity();
        entity.idClient = reservation.getIdClient();
        entity.idRoom = reservation.getIdRoom();
        entity.instructor = reservation.getInstructor();
        
        // Convertir Double a BigDecimal si no es null
        if (reservation.getDiscount() != null) {
            entity.discount = java.math.BigDecimal.valueOf(reservation.getDiscount());
        }

        return entity;
    }

    /**
     * Convierte de entidad JPA a modelo de confirmación
     */
    public Confirmation toConfirmation(ReservationEntity entity) {
        if (entity == null) {
            return null;
        }

        Confirmation confirmation = new Confirmation();
        confirmation.setIdReservation(entity.id.intValue()); // PanacheEntity usa Long, convertimos a Integer
        confirmation.setIdRoom(entity.idRoom);
        confirmation.setInstructor(entity.instructor);
        
        // Convertir BigDecimal a Double si no es null
        if (entity.discount != null) {
            confirmation.setDiscount(entity.discount.doubleValue());
        }

        return confirmation;
    }

    /**
     * Convierte de entidad JPA a modelo Reservation
     */
    public Reservation toReservation(ReservationEntity entity) {
        if (entity == null) {
            return null;
        }

        Reservation reservation = new Reservation();
        reservation.setIdClient(entity.idClient);
        reservation.setIdRoom(entity.idRoom);
        reservation.setInstructor(entity.instructor);
        
        if (entity.discount != null) {
            reservation.setDiscount(entity.discount.doubleValue());
        }

        return reservation;
    }
}
``` 

---

## 🛠️ Paso 6: Crear el Repository (Patrón Repository)

Aunque Panache nos da métodos básicos, crearemos un repository para operaciones más complejas.

### 6.1 Crear el Paquete Repository

Crea el paquete: `src/main/java/com/ejemplo/api/repository`

### 6.2 Crear ReservationRepository

Crea el archivo `ReservationRepository.java`:

```bash
package com.ejemplo.api.repository;

import com.ejemplo.api.entity.ReservationEntity;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class ReservationRepository implements PanacheRepository<ReservationEntity> {

    /**
     * Buscar reservaciones por ID de cliente
     */
    public List<ReservationEntity> findByClientId(Integer clientId) {
        return list("idClient", clientId);
    }

    /**
     * Buscar reservaciones por instructor
     */
    public List<ReservationEntity> findByInstructor(String instructor) {
        return list("instructor", instructor);
    }

    /**
     * Buscar reservaciones por sala
     */
    public List<ReservationEntity> findByRoomId(Integer roomId) {
        return list("idRoom", roomId);
    }

    /**
     * Buscar reservación por ID (más explícito que el método heredado)
     */
    public Optional<ReservationEntity> findByIdOptional(Long id) {
        return find("id", id).firstResultOptional();
    }

    /**
     * Verificar si existe una reservación para una sala específica
     */
    public boolean existsByRoomId(Integer roomId) {
        return count("idRoom", roomId) > 0;
    }

    /**
     * Contar reservaciones por instructor
     */
    public long countByInstructor(String instructor) {
        return count("instructor", instructor);
    }

    /**
     * Eliminar reservaciones por cliente
     */
    @Transactional
    public long deleteByClientId(Integer clientId) {
        return delete("idClient", clientId);
    }

    /**
     * Obtener todas las reservaciones ordenadas por fecha de creación
     */
    public List<ReservationEntity> findAllOrderedByCreatedAt() {
        return list("ORDER BY createdAt DESC");
    }
}
``` 

**💡 Explicación:**

- Implementamos `PanacheRepository` para obtener métodos CRUD básicos
- Agregamos métodos de consulta específicos para nuestro dominio
- `@Transactional` es necesario para operaciones que modifican datos

---

## 💼 Paso 7: Actualizar el Service con Operaciones CRUD Completas

Ahora actualizaremos nuestro `ReservationService` para usar la base de datos real.

```bash
package com.ejemplo.api.service;

import com.ejemplo.api.entity.ReservationEntity;
import com.ejemplo.api.mapper.ReservationMapper;
import com.ejemplo.api.model.Confirmation;
import com.ejemplo.api.model.Reservation;
import com.ejemplo.api.repository.ReservationRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@ApplicationScoped
public class ReservationService {

    @Inject
    ReservationRepository reservationRepository;

    @Inject
    ReservationMapper reservationMapper;

    /**
     * Crear una nueva reservación
     */
    @Transactional
    public Confirmation createReservation(Reservation reservation) {
        System.out.println("Service - Creando reservación para cliente: " + reservation.getIdClient());
        
        // Convertir el modelo OpenAPI a entidad JPA
        ReservationEntity entity = reservationMapper.toEntity(reservation);
        
        // Persistir en la base de datos
        reservationRepository.persist(entity);
        
        // Convertir la entidad guardada a modelo de confirmación
        Confirmation confirmation = reservationMapper.toConfirmation(entity);
        
        System.out.println("Service - Reservación creada con ID: " + entity.id);
        return confirmation;
    }

    /**
     * Obtener reservación por ID
     */
    public Confirmation getReservationById(Long reservationId) {
        System.out.println("Service - Buscando reservación con ID: " + reservationId);
        
        Optional<ReservationEntity> entityOptional = reservationRepository.findByIdOptional(reservationId);
        
        if (entityOptional.isPresent()) {
            ReservationEntity entity = entityOptional.get();
            System.out.println("Service - Reservación encontrada: " + entity.toString());
            return reservationMapper.toConfirmation(entity);
        } else {
            System.out.println("Service - Reservación no encontrada con ID: " + reservationId);
            return null;
        }
    }

    /**
     * Obtener todas las reservaciones
     */
    public List<Confirmation> getAllReservations() {
        System.out.println("Service - Obteniendo todas las reservaciones");
        
        List<ReservationEntity> entities = reservationRepository.findAllOrderedByCreatedAt();
        
        return entities.stream()
                .map(reservationMapper::toConfirmation)
                .collect(Collectors.toList());
    }

    /**
     * Actualizar una reservación existente
     */
    @Transactional
    public Confirmation updateReservation(Long reservationId, Reservation reservation) {
        System.out.println("Service - Actualizando reservación con ID: " + reservationId);
        
        Optional<ReservationEntity> entityOptional = reservationRepository.findByIdOptional(reservationId);
        
        if (entityOptional.isPresent()) {
            ReservationEntity entity = entityOptional.get();
            
            // Actualizar los campos
            entity.idClient = reservation.getIdClient();
            entity.idRoom = reservation.getIdRoom();
            entity.instructor = reservation.getInstructor();
            
            if (reservation.getDiscount() != null) {
                entity.discount = java.math.BigDecimal.valueOf(reservation.getDiscount());
            } else {
                entity.discount = null;
            }
            
            // Panache automáticamente detecta cambios y los persiste
            System.out.println("Service - Reservación actualizada: " + entity.toString());
            return reservationMapper.toConfirmation(entity);
        } else {
            System.out.println("Service - No se puede actualizar. Reservación no encontrada con ID: " + reservationId);
            return null;
        }
    }

    /**
     * Eliminar una reservación
     */
    @Transactional
    public boolean deleteReservation(Long reservationId) {
        System.out.println("Service - Eliminando reservación con ID: " + reservationId);
        
        boolean deleted = reservationRepository.deleteById(reservationId);
        
        if (deleted) {
            System.out.println("Service - Reservación eliminada exitosamente");
        } else {
            System.out.println("Service - No se pudo eliminar. Reservación no encontrada con ID: " + reservationId);
        }
        
        return deleted;
    }

    /**
     * Buscar reservaciones por cliente
     */
    public List<Confirmation> getReservationsByClientId(Integer clientId) {
        System.out.println("Service - Buscando reservaciones para cliente: " + clientId);
        
        List<ReservationEntity> entities = reservationRepository.findByClientId(clientId);
        
        return entities.stream()
                .map(reservationMapper::toConfirmation)
                .collect(Collectors.toList());
    }

    /**
     * Buscar reservaciones por instructor
     */
    public List<Confirmation> getReservationsByInstructor(String instructor) {
        System.out.println("Service - Buscando reservaciones para instructor: " + instructor);
        
        List<ReservationEntity> entities = reservationRepository.findByInstructor(instructor);
        
        return entities.stream()
                .map(reservationMapper::toConfirmation)
                .collect(Collectors.toList());
    }
}
``` 

**💡 Explicación:**

- `@Transactional` es necesario para operaciones que modifican la base de datos
- Usamos el mapper para convertir entre modelos OpenAPI y entidades JPA
- Manejamos casos donde la reservación no existe retornando `null` o `false`

---

## 🌐 Paso 8: Actualizar el Resource con Endpoints CRUD Completos

Ahora expandimos nuestro `ReservationResource` para incluir todas las operaciones CRUD:

```bash
package com.ejemplo.api.resource;

import com.ejemplo.api.model.ApiError;
import com.ejemplo.api.model.Confirmation;
import com.ejemplo.api.model.Reservation;
import com.ejemplo.api.service.ReservationService;

import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/api/v1")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ReservationResource {

    @Inject
    ReservationService reservationService;

    /**
     * CREATE - Crear una nueva reservación
     * POST /api/v1/reservations
     */
    @POST
    @Path("/reservations")
    public Response createReservation(@Valid Reservation reservationRequest) {
        System.out.println("Resource - Creando reservación para cliente: " + reservationRequest.getIdClient());
        
        try {
            Confirmation confirmation = reservationService.createReservation(reservationRequest);
            return Response.status(Response.Status.CREATED).entity(confirmation).build();
        } catch (Exception e) {
            System.err.println("Error al crear reservación: " + e.getMessage());
            
            ApiError error = new ApiError();
            error.setCode("500");
            error.setMessage("Error interno del servidor al crear la reservación");
            error.setDetails(e.getMessage());
            
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }

    /**
     * READ - Obtener una reservación por ID
     * GET /api/v1/reservations/{reservationId}
     */
    @GET
    @Path("/reservations/{reservationId}")
    public Response getReservationById(@PathParam("reservationId") Long reservationId) {
        System.out.println("Resource - Buscando reservación con ID: " + reservationId);
        
        // Validación básica del ID
        if (reservationId == null || reservationId < 1) {
            ApiError error = new ApiError();
            error.setCode("400");
            error.setMessage("El ID de la reservación es inválido");
            error.setDetails("ID debe ser un número positivo");
            
            return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
        }
        
        Confirmation confirmation = reservationService.getReservationById(reservationId);
        
        if (confirmation != null) {
            return Response.ok(confirmation).build();
        } else {
            ApiError error = new ApiError();
            error.setCode("404");
            error.setMessage("Reservación no encontrada");
            error.setDetails("No existe una reservación con ID: " + reservationId);
            
            return Response.status(Response.Status.NOT_FOUND).entity(error).build();
        }
    }

    /**
     * READ - Obtener todas las reservaciones
     * GET /api/v1/reservations
     */
    @GET
    @Path("/reservations")
    public Response getAllReservations() {
        System.out.println("Resource - Obteniendo todas las reservaciones");
        
        try {
            List<Confirmation> reservations = reservationService.getAllReservations();
            return Response.ok(reservations).build();
        } catch (Exception e) {
            System.err.println("Error al obtener reservaciones: " + e.getMessage());
            
            ApiError error = new ApiError();
            error.setCode("500");
            error.setMessage("Error interno del servidor al obtener las reservaciones");
            error.setDetails(e.getMessage());
            
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }

    /**
     * UPDATE - Actualizar una reservación existente
     * PUT /api/v1/reservations/{reservationId}
     */
    @PUT
    @Path("/reservations/{reservationId}")
    public Response updateReservation(@PathParam("reservationId") Long reservationId, 
                                    @Valid Reservation reservationRequest) {
        System.out.println("Resource - Actualizando reservación con ID: " + reservationId);
        
        // Validación básica del ID
        if (reservationId == null || reservationId < 1) {
            ApiError error = new ApiError();
            error.setCode("400");
            error.setMessage("El ID de la reservación es inválido");
            error.setDetails("ID debe ser un número positivo");
            
            return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
        }
        
        try {
            Confirmation confirmation = reservationService.updateReservation(reservationId, reservationRequest);
            
            if (confirmation != null) {
                return Response.ok(confirmation).build();
            } else {
                ApiError error = new ApiError();
                error.setCode("404");
                error.setMessage("Reservación no encontrada para actualizar");
                error.setDetails("No existe una reservación con ID: " + reservationId);
                
                return Response.status(Response.Status.NOT_FOUND).entity(error).build();
            }
        } catch (Exception e) {
            System.err.println("Error al actualizar reservación: " + e.getMessage());
            
            ApiError error = new ApiError();
            error.setCode("500");
            error.setMessage("Error interno del servidor al actualizar la reservación");
            error.setDetails(e.getMessage());
            
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }

    /**
     * DELETE - Eliminar una reservación
     * DELETE /api/v1/reservations/{reservationId}
     */
    @DELETE
    @Path("/reservations/{reservationId}")
    public Response deleteReservation(@PathParam("reservationId") Long reservationId) {
        System.out.println("Resource - Eliminando reservación con ID: " + reservationId);
        
        // Validación básica del ID
        if (reservationId == null || reservationId < 1) {
            ApiError error = new ApiError();
            error.setCode("400");
            error.setMessage("El ID de la reservación es inválido");
            error.setDetails("ID debe ser un número positivo");
            
            return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
        }
        
        try {
            boolean deleted = reservationService.deleteReservation(reservationId);
            
            if (deleted) {
                return Response.noContent().build(); // 204 No Content
            } else {
                ApiError error = new ApiError();
                error.setCode("404");
                error.setMessage("Reservación no encontrada para eliminar");
                error.setDetails("No existe una reservación con ID: " + reservationId);
                
                return Response.status(Response.Status.NOT_FOUND).entity(error).build();
            }
        } catch (Exception e) {
            System.err.println("Error al eliminar reservación: " + e.getMessage());
            
            ApiError error = new ApiError();
            error.setCode("500");
            error.setMessage("Error interno del servidor al eliminar la reservación");
            error.setDetails(e.getMessage());
            
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }

    /**
     * BÚSQUEDA - Obtener reservaciones por cliente
     * GET /api/v1/reservations/client/{clientId}
     */
    @GET
    @Path("/reservations/client/{clientId}")
    public Response getReservationsByClientId(@PathParam("clientId") Integer clientId) {
        System.out.println("Resource - Buscando reservaciones para cliente: " + clientId);
        
        if (clientId == null || clientId < 1) {
            ApiError error = new ApiError();
            error.setCode("400");
            error.setMessage("El ID del cliente es inválido");
            error.setDetails("ID del cliente debe ser un número positivo");
            
            return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
        }
        
        try {
            List<Confirmation> reservations = reservationService.getReservationsByClientId(clientId);
            return Response.ok(reservations).build();
        } catch (Exception e) {
            System.err.println("Error al buscar reservaciones por cliente: " + e.getMessage());
            
            ApiError error = new ApiError();
            error.setCode("500");
            error.setMessage("Error interno del servidor al buscar reservaciones por cliente");
            error.setDetails(e.getMessage());
            
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }

    /**
     * BÚSQUEDA - Obtener reservaciones por instructor
     * GET /api/v1/reservations/instructor/{instructor}
     */
    @GET
    @Path("/reservations/instructor/{instructor}")
    public Response getReservationsByInstructor(@PathParam("instructor") String instructor) {
        System.out.println("Resource - Buscando reservaciones para instructor: " + instructor);
        
        if (instructor == null || instructor.trim().isEmpty()) {
            ApiError error = new ApiError();
            error.setCode("400");
            error.setMessage("El nombre del instructor es inválido");
            error.setDetails("El nombre del instructor no puede estar vacío");
            
            return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
        }
        
        try {
            List<Confirmation> reservations = reservationService.getReservationsByInstructor(instructor);
            return Response.ok(reservations).build();
        } catch (Exception e) {
            System.err.println("Error al buscar reservaciones por instructor: " + e.getMessage());
            
            ApiError error = new ApiError();
            error.setCode("500");
            error.setMessage("Error interno del servidor al buscar reservaciones por instructor");
            error.setDetails(e.getMessage());
            
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
}
``` 

---

## 🧪 Paso 9: Compilar y Probar la Aplicación

### 9.1 Compilar el Proyecto

```bash
mvn clean compile
``` 

### 9.2 Ejecutar en Modo Desarrollo

```bash
mvn quarkus:dev
``` 

### 9.3 Verificar la Conexión a la Base de Datos

En los logs, deberías ver algo como:

```bash
2024-01-15 10:30:45,123 INFO  [io.qua.hib.orm.dep.HibernateOrmProcessor] (build-4) Setting quarkus.hibernate-orm.database.generation=none
2024-01-15 10:30:45,456 INFO  [io.qua.agi.dep.AgroalProcessor] (build-4) Agroal connection pool created for: <default>
``` 

---

## 🔧 Paso 10: Probar con Postman - CRUD Completo

### 10.1 **CREATE** - Crear Reservación

- **Método:** `POST`
- **URL:** `http://localhost:8080/api/v1/reservations`
- **Body (JSON):**

```bash
{
    "idClient": 2001,
    "idRoom": 8,
    "instructor": "María García",
    "discount": 20.5
}
``` 

**Respuesta esperada:** `201 Created`

```bash
{
    "idReservation": 4,
    "idRoom": 8,
    "instructor": "María García",
    "discount": 20.5
}
``` 

### 10.2 **READ** - Obtener Todas las Reservaciones

- **Método:** `GET`
- **URL:** `http://localhost:8080/api/v1/reservations`

**Respuesta esperada:** `200 OK` con lista de todas las reservaciones

### 10.3 **READ** - Obtener Reservación por ID

- **Método:** `GET`
- **URL:** `http://localhost:8080/api/v1/reservations/1`

**Respuesta esperada:** `200 OK` con los datos de la reservación

### 10.4 **UPDATE** - Actualizar Reservación

- **Método:** `PUT`
- **URL:** `http://localhost:8080/api/v1/reservations/1`
- **Body (JSON):**

```bash
{
    "idClient": 1001,
    "idRoom": 10,
    "instructor": "Juan Pérez Actualizado",
    "discount": 25.0
}
``` 

**Respuesta esperada:** `200 OK` con los datos actualizados

### 10.5 **DELETE** - Eliminar Reservación

- **Método:** `DELETE`
- **URL:** `http://localhost:8080/api/v1/reservations/4`

**Respuesta esperada:** `204 No Content`

### 10.6 **BÚSQUEDAS** - Filtros Específicos

**Por Cliente:**

- **Método:** `GET`
- **URL:** `http://localhost:8080/api/v1/reservations/client/1001`

**Por Instructor:**

- **Método:** `GET`
- **URL:** `http://localhost:8080/api/v1/reservations/instructor/Juan%20Pérez`

---

## 📊 Paso 11: Verificación en la Base de Datos

Puedes verificar los cambios directamente en MySQL:

```bash
-- Ver todas las reservaciones
SELECT * FROM reservations ORDER BY created_at DESC;

-- Ver reservaciones por cliente
SELECT * FROM reservations WHERE id_client = 1001;

-- Ver reservaciones por instructor
SELECT * FROM reservations WHERE instructor LIKE '%Juan%';
``` 

---

## 🎯 Resumen de lo Aprendido

1. **Configuración de MySQL** con Quarkus usando `application.properties`
2. **Entidades JPA** con Panache para mapeo objeto-relacional
3. **Patrón Repository** para operaciones de base de datos complejas
4. **Mapper** para conversión entre modelos OpenAPI y entidades JPA
5. **Transacciones** con `@Transactional` para operaciones que modifican datos
6. **CRUD completo** con manejo de errores y validaciones
7. **Búsquedas personalizadas** por diferentes criterios

---

## 🚀 Próximos Pasos

- Agregar paginación para consultas que retornan muchos resultados
- Implementar validaciones de negocio más complejas
- Agregar logging estructurado
- Configurar profiles para diferentes ambientes (dev, test, prod)
- Implementar tests unitarios e integración

¡Has completado exitosamente la integración de Quarkus con MySQL y tienes un API REST completamente funcional con operaciones CRUD!