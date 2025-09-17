[[Web Services]]

# ¿Qué son los servicios REST?

**REST** (Representational State Transfer) es un estilo de arquitectura para diseñar servicios web ligeros y escalables, que permiten la comunicación entre sistemas a través de HTTP usando operaciones estándar.

## Características principales

- **Usan HTTP:** Los servicios REST suelen usar los métodos HTTP (`GET`, `POST`, `PUT`, `DELETE`, etc.) para operar sobre recursos.
- **Basados en recursos:** Cada recurso (por ejemplo, usuario, producto) se identifica con una URL única.
- **Sin estado (stateless):** Cada petición contiene toda la información necesaria; el servidor no guarda estado entre peticiones.
- **Formato flexible:** Los datos suelen intercambiarse en JSON o XML (JSON es el más común).
- **Escalables y simples:** Son fáciles de consumir desde cualquier cliente HTTP (navegador, app móvil, etc.).

## Ejemplo de endpoints REST

```
GET    /api/countries           # Obtener lista de países
GET    /api/countries/ES        # Obtener información de España
POST   /api/countries           # Crear un nuevo país
PUT    /api/countries/ES        # Actualizar información de España
DELETE /api/countries/ES        # Eliminar España
```

## ¿Para qué se usan?

- APIs para aplicaciones web y móviles.
- Integración entre sistemas modernos.
- Microservicios y arquitecturas distribuidas.

**Resumen:**  
Un servicio REST es un servicio web que sigue el estilo arquitectónico REST, usando HTTP y recursos identificados por URLs, permitiendo la comunicación sencilla y eficiente entre aplicaciones.

[[Web Services]]
