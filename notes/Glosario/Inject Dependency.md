[[Conceptos Java]]
# ¿Qué es "inject dependency" (inyección de dependencias)?

**Inject dependency** o **inyección de dependencias** es un patrón de diseño en el que los objetos que una clase necesita (sus dependencias) se proporcionan desde el exterior, en lugar de que la propia clase los cree.

## ¿Para qué sirve?
- Facilita la reutilización y el mantenimiento del código.
- Permite cambiar fácilmente las implementaciones de las dependencias.
- Hace posible el testing unitario (mocking de dependencias).

## Ejemplo en Java (Spring)

```java
@Component
public class ServicioA {
    private final ServicioB servicioB;

    // Inyección de dependencias por constructor
    @Autowired
    public ServicioA(ServicioB servicioB) {
        this.servicioB = servicioB;
    }
}
```

En este ejemplo, `ServicioA` necesita un objeto de tipo `ServicioB`. Spring se encarga de crear e "inyectar" esa dependencia automáticamente.


## Otro ejemplo en Spring

```java
// Ejemplo sencillo de inyección de dependencias por atributo (field injection) en Spring

import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

// Dependencia
@Component
public class Motor {
    public void encender() {
        System.out.println("Motor encendido");
    }
}

// Clase que depende de Motor
@Component
public class Auto {
    @Autowired
    private Motor motor; // Inyección de dependencias por atributo

    public void arrancar() {
        motor.encender();
    }
}
```

**Explicación:**

- Aquí, la dependencia `Motor` se inyecta directamente en el campo de la clase `Auto` usando `@Autowired`.
- `Auto` no crea el objeto `Motor`, Spring lo proporciona automáticamente.
- No se usa el constructor para la inyección, sino el atributo directamente.
## Resumen

La inyección de dependencias es una técnica para desacoplar componentes y delegar la creación de objetos a un framework o contenedor, mejorando la flexibilidad y testabilidad del software.

[[Conceptos Java]]
