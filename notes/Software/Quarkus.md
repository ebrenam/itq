[[Software/Software]]

**Quarkus** es un framework Java moderno diseñado específicamente para aplicaciones nativas en la nube (cloud-native) y contenedores.

## ¿Qué es Quarkus?

### **Definición:**

- Framework Java/Kotlin supersónico y subatómico
- Optimizado para GraalVM y OpenJDK HotSpot
- Diseñado para Kubernetes y contenedores
- Desarrollado por Red Hat

### **Características principales:**

- **Startup ultra-rápido** (milisegundos)
- **Consumo mínimo de memoria**
- **Compilación nativa** con GraalVM
- **Live coding** (recarga en caliente)

## Ventajas clave:

### **1. Performance**

```
Tiempo de inicio:
- Spring Boot: ~2.5 segundos
- Quarkus JVM: ~0.75 segundos  
- Quarkus Native: ~0.016 segundos

Memoria:
- Spring Boot: ~136MB
- Quarkus JVM: ~73MB
- Quarkus Native: ~12MB
```

### **2. Developer Experience**

- **Live Reload**: Cambios instantáneos sin reiniciar
- **Dev UI**: Interfaz web para desarrollo
- **Testing integrado**: @QuarkusTest
- **CLI tools** para scaffolding

### **3. Cloud Native**

- **Kubernetes-first** design
- **Microservicios** optimizados
- **Serverless** compatible
- **Container-friendly**

## Extensiones principales:

### **Web & REST:**

- RESTEasy JAX-RS
- Spring Web compatibilidad
- GraphQL
- WebSockets

### **Datos:**

- Hibernate ORM con Panache
- MongoDB con Panache
- Reactive SQL clients
- Elasticsearch

### **Messaging:**

- Apache Kafka
- AMQP
- JMS
- Apache Camel

### **Observabilidad:**

- OpenTracing/OpenTelemetry
- Metrics (Micrometer)
- Health checks
- Logging

## Ejemplo básico:

### **REST Endpoint:**

```Java
@Path("/hello")
public class HelloResource {
    
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "Hello Quarkus!";
    }
}
```

### **Entity con Panache:**

```Java
@Entity
public class Person extends PanacheEntity {
    public String name;
    public LocalDate birth;
    
    public static Person findByName(String name) {
        return find("name", name).firstResult();
    }
}
```

### **Configuration:**

```Java
@ConfigMapping(prefix = "greeting")
public interface GreetingConfig {
    String message();
    String suffix();
}
```

## Modos de ejecución:

### **1. JVM Mode:**

- Desarrollo rápido
- Compatibilidad total
- Live reload

### **2. Native Mode:**

- Compilación con GraalVM
- Startup instantáneo
- Memoria mínima
- Ideal para contenedores

## Casos de uso ideales:

### **Microservicios:**

- APIs REST ligeras
- Comunicación entre servicios
- Service mesh integration

### **Serverless:**

- AWS Lambda
- Azure Functions
- Google Cloud Functions
- Knative

### **Edge Computing:**

- IoT applications
- CDN edge functions
- Low-latency requirements

## Comparación con otros frameworks:

### **vs Spring Boot:**

- **Quarkus**: Más rápido, menos memoria
- **Spring**: Ecosistema más maduro

### **vs Micronaut:**

- **Quarkus**: Better GraalVM support
- **Micronaut**: Reflection-free desde el inicio

### **vs Helidon:**

- **Quarkus**: Mayor ecosistema
- **Helidon**: Oracle backing

## Getting Started:

### **1. Crear proyecto:**

```bash
mvn io.quarkus:quarkus-maven-plugin:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=getting-started \
    -DclassName="org.acme.getting.started.GreetingResource" \
    -Dpath="/hello"
```

### **2. Modo desarrollo:**

```bash
./mvnw compile quarkus:dev
```


### **3. Build nativo:**

```bash
./mvnw package -Pnative
```

## Ecosistema:

### **Quarkiverse:**

- Hub de extensiones comunitarias
- +200 extensiones disponibles
- Integración con frameworks populares

### **Tooling:**

- IntelliJ plugin
- VS Code extension
- CLI tools
- Maven/Gradle plugins


## Generación de proyectos Quarkus
	
	https://quarkus.io/

[[Software/Software]]