# @SpringBootApplication

La anotación `@SpringBootApplication` es una de las más importantes en aplicaciones Spring Boot. Se coloca sobre la clase principal del proyecto y sirve para habilitar varias configuraciones automáticas.

## ¿Qué hace?

- Marca la clase principal como punto de inicio de la aplicación Spring Boot.
- Combina tres anotaciones clave:
  - `@SpringBootConfiguration`: Marca la clase como configuración de Spring.
  - `@EnableAutoConfiguration`: Activa la configuración automática de Spring Boot.
  - `@ComponentScan`: Permite la detección automática de componentes (`@Component`, `@Service`, `@Repository`, etc.) en el paquete y subpaquetes.

## Ejemplo de uso

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MiAplicacion {
    public static void main(String[] args) {
        SpringApplication.run(MiAplicacion.class, args);
    }
}
```

## Resumen

`@SpringBootApplication` simplifica la configuración y el arranque de aplicaciones Spring Boot, permitiendo que el framework detecte y configure automáticamente los componentes

[[Annotations]]
