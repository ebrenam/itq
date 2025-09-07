[[Software/Software]]

- Descarga de Curl para Windows.
	https://curl.se/windows

**cURL** (Client URL) es una herramienta de línea de comandos y biblioteca para transferir datos desde o hacia un servidor utilizando diversos protocolos de red.

## ¿Qué es cURL?

### **Definición:**

- Herramienta de línea de comandos libre
- Cliente para múltiples protocolos de red
- Disponible en prácticamente todos los sistemas operativos
- Ampliamente usado para testing de APIs

### **Protocolos soportados:**

- HTTP/HTTPS
- FTP/FTPS
- SMTP/SMTPS
- POP3/POP3S
- IMAP/IMAPS
- SSH/SCP/SFTP
- Y muchos más...

## Sintaxis básica:

```bash
curl [opciones] [URL]
```

## Ejemplos comunes:

### **1. GET Request básico:**

```bash
# Obtener contenido de una página
curl https://api.github.com/users/octocat

# Guardar respuesta en archivo
curl https://api.github.com/users/octocat -o response.json

# Mostrar headers HTTP
curl -i https://api.github.com/users/octocat
```

### **2. POST Request:**

```bash
# Enviar datos JSON
curl -X POST https://api.ejemplo.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Juan","email":"juan@email.com"}'

# Enviar datos desde archivo
curl -X POST https://api.ejemplo.com/users \
  -H "Content-Type: application/json" \
  -d @data.json
```

### **3. PUT Request:**

```bash
curl -X PUT https://api.ejemplo.com/users/123 \
  -H "Content-Type: application/json" \
  -d '{"name":"Juan Actualizado"}'
```

### **4. DELETE Request:**

```bash
curl -X PUT https://api.ejemplo.com/users/123 \
  -H "Content-Type: application/json" \
  -d '{"name":"Juan Actualizado"}'
```

### **5. Autenticación:**

```bash
# Basic Auth
curl -u usuario:password https://api.ejemplo.com/data

# Bearer Token
curl -H "Authorization: Bearer tu_token_aqui" \
  https://api.ejemplo.com/data

# API Key
curl -H "X-API-Key: tu_api_key" \
  https://api.ejemplo.com/data
```

## Opciones principales:

### **Headers y datos:**

- `-H, --header`: Agregar header personalizado
- `-d, --data`: Enviar datos POST
- `-F, --form`: Enviar formulario multipart
- `-u, --user`: Autenticación básica

### **Métodos HTTP:**

- `-X, --request`: Especificar método HTTP
- `-G, --get`: Forzar método GET

### **Output y debugging:**

- `-o, --output`: Guardar en archivo
- `-O, --remote-name`: Usar nombre del archivo remoto
- `-i, --include`: Incluir headers en output
- `-v, --verbose`: Modo verbose para debugging
- `-s, --silent`: Modo silencioso

### **Seguimiento y redirects:**

- `-L, --location`: Seguir redirects
- `-w, --write-out`: Formatear output personalizado

## Ejemplos avanzados:

### **Testing de APIs REST:**

```bash
# Crear usuario
curl -X POST https://jsonplaceholder.typicode.com/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Juan Pérez",
    "username": "juanp",
    "email": "juan@ejemplo.com"
  }'

# Obtener usuario
curl https://jsonplaceholder.typicode.com/users/1

# Actualizar usuario
curl -X PUT https://jsonplaceholder.typicode.com/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "name": "Juan Pérez Actualizado",
    "username": "juanp",
    "email": "juan.nuevo@ejemplo.com"
  }'

# Eliminar usuario
curl -X DELETE https://jsonplaceholder.typicode.com/users/1
```

## Casos de uso comunes:

### **1. Testing de APIs:**

- Verificar endpoints
- Probar autenticación
- Validar respuestas

### **2. Automatización:**

- Scripts de deployment
- Monitoreo de servicios
- Webhooks

### **3. Descarga de archivos:**

```bash
# Descargar archivo grande con progress
curl -L --progress-bar \
  https://ejemplo.com/archivo-grande.zip \
  -o archivo-grande.zip
```

### **4. Health checks:**

```bash
# Check simple de estado
curl -f https://mi-api.com/health || echo "Servicio caído"

# Con timeout
curl --max-time 10 https://mi-api.com/health
```

[[Software/Software]]