# ¿Qué es un servlet?

Un **servlet** es una clase Java que se ejecuta en un servidor web (como Tomcat) y permite manejar solicitudes y respuestas HTTP de manera dinámica en aplicaciones web Java.

## Características principales

- Especificación estándar de Java EE (ahora Jakarta EE).
- Permite procesar peticiones HTTP (GET, POST, etc.) y generar respuestas (HTML, JSON, etc.).
- Se ejecuta en un contenedor de servlets (por ejemplo, Apache Tomcat, Jetty).
- Es la base de tecnologías como JSP y frameworks web Java (Spring MVC, JSF).

## Ejemplo básico de servlet

```java
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class HolaServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>¡Hola desde un servlet!</h1>");
    }
}
```

## ¿Para qué se usan?

- Crear aplicaciones web dinámicas en Java.
- Procesar formularios, manejar sesiones, generar contenido dinámico.
- Servir como base para APIs REST (aunque hoy se usan frameworks más modernos).

**Resumen:**  
Un servlet es un componente Java que permite crear aplicaciones web dinámicas procesando solicitudes y respuestas HTTP en el servidor.
