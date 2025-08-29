[[Protocolos]]

**HTTP** (HyperText Transfer Protocol) es el protocolo de comunicación que permite la transferencia de información en la World Wide Web entre clientes (navegadores) y servidores.

## ¿Qué es HTTP?

### **Definición:**

- Protocolo de aplicación para sistemas de información distribuidos
- Base de la comunicación de datos en la Web
- Protocolo sin estado (stateless)
- Funciona sobre TCP/IP en el puerto 80 por defecto

### **Características principales:**

- **Cliente-Servidor**: Arquitectura request-response
- **Sin estado**: Cada request es independiente
- **Basado en texto**: Headers y métodos legibles
- **Extensible**: Permite headers personalizados

## Componentes de HTTP:

### **1. Métodos HTTP (Verbos)**

#### **GET**

- **Propósito**: Obtener recursos
- **Características**: Seguro, idempotente, cacheable

- 
- 
- 
- 

#### **POST**

- **Propósito**: Crear recursos
- **Características**: No seguro, no idempotente

- 
- 
- 
- 

#### **PUT**

- **Propósito**: Actualizar/crear recursos completos
- **Características**: Idempotente

- 
- 
- 
- 

#### **PATCH**

- **Propósito**: Actualización parcial

- 
- 
- 
- 

#### **DELETE**

- **Propósito**: Eliminar recursos

- 
- 
- 
- 

#### **HEAD**

- **Propósito**: Obtener solo headers (sin body)

- 
- 
- 
- 

#### **OPTIONS**

- **Propósito**: Obtener métodos permitidos

- 
- 
- 
- 

### **2. Códigos de Estado (Status Codes)**

#### **1xx - Informacional**

- `100 Continue`: Continúa con el request
- `101 Switching Protocols`: Cambio de protocolo

#### **2xx - Éxito**

- `200 OK`: Solicitud exitosa
- `201 Created`: Recurso creado
- `202 Accepted`: Solicitud aceptada (procesamiento asíncrono)
- `204 No Content`: Éxito sin contenido

#### **3xx - Redirección**

- `301 Moved Permanently`: Recurso movido permanentemente
- `302 Found`: Redirección temporal
- `304 Not Modified`: Recurso no modificado (cache)

#### **4xx - Error del Cliente**

- `400 Bad Request`: Solicitud malformada
- `401 Unauthorized`: No autenticado
- `403 Forbidden`: No autorizado
- `404 Not Found`: Recurso no encontrado
- `409 Conflict`: Conflicto en el estado del recurso
- `422 Unprocessable Entity`: Entidad no procesable

#### **5xx - Error del Servidor**

- `500 Internal Server Error`: Error interno del servidor
- `502 Bad Gateway`: Gateway malo
- `503 Service Unavailable`: Servicio no disponible
- `504 Gateway Timeout`: Timeout del gateway

### **3. Headers HTTP**

#### **Request Headers:**

- 
- 
- 
- 

#### **Response Headers:**

- 
- 
- 
- 

#### **Headers comunes:**

##### **Autenticación:**

- `Authorization: Bearer token`
- `WWW-Authenticate: Basic realm="Protected"`

##### **Contenido:**

- `Content-Type: application/json`
- `Content-Length: 1024`
- `Content-Encoding: gzip`

##### **Cache:**

- `Cache-Control: no-cache`
- `ETag: "version-hash"`
- `Last-Modified: Wed, 27 Aug 2025 10:00:00 GMT`

##### **CORS:**

- `Access-Control-Allow-Origin: *`
- `Access-Control-Allow-Methods: GET, POST, PUT, DELETE`
- `Access-Control-Allow-Headers: Content-Type, Authorization`

## Estructura de una comunicación HTTP:

### **Request completo:**

- 
- 
- 
- 

### **Response completo:**

- 
- 
- 
- 

## Versiones de HTTP:

### **HTTP/1.0 (1996)**

- Una conexión por request
- Sin pipelining
- Headers básicos

### **HTTP/1.1 (1997)**

- **Keep-alive**: Conexiones persistentes
- **Pipelining**: Múltiples requests en una conexión
- **Chunked encoding**: Transferencia en chunks
- **Host header**: Virtual hosting

- 
- 
- 
- 

### **HTTP/2 (2015)**

- **Multiplexing**: Múltiples streams en una conexión
- **Server Push**: Servidor puede enviar recursos proactivamente
- **Header compression**: HPACK
- **Binary protocol**: Más eficiente que texto

### **HTTP/3 (2022)**

- **QUIC**: Sobre UDP en lugar de TCP
- **Menor latencia**: Conexión más rápida
- **Better performance**: En redes inestables

## Ejemplo práctico con cURL:

### **GET Request:**

- 
- 
- 
- 

### **POST Request:**

- 
- 
- 
- 

### **Con verbose para ver headers:**

- 
- 
- 
- 

## HTTPS - HTTP Seguro:

### **Diferencias:**

- **Puerto**: 443 en lugar de 80
- **Encriptación**: TLS/SSL
- **Certificados**: Validación de identidad
- **Integridad**: Datos no pueden ser modificados

### **Proceso de handshake:**

- 
- 
- 
- 

## Cookies y Sesiones:

### **Set-Cookie (Response):**

- 
- 
- 
- 

### **Cookie (Request):**

- 
- 
- 
- 

## Casos de uso comunes:

### **APIs REST:**

- 
- 
- 
- 

### **Web Applications:**

- 
- 
- 
- 

### **File Upload:**

- 
- 
- 
- 

HTTP es fundamental para el desarrollo web moderno y el funcionamiento de Internet tal como lo conocemos.
- Códigos de respuesta HTTP.
	https://developer.mozilla.org/en-US/docs/Web/HTTP/Status

[[Protocolos]]