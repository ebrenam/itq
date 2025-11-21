# OSI

**El Modelo OSI** (Open Systems Interconnection) es un modelo conceptual de referencia que describe cómo los datos se transmiten a través de una red de comunicaciones en 7 capas.

## ¿Qué es el Modelo OSI?

### **Definición:**

- Estándar desarrollado por la ISO en 1984
- Modelo de referencia para interconexión de sistemas
- Divide la comunicación de red en 7 capas abstractas
- Facilita la comprensión y desarrollo de protocolos

### **Propósito:**

- Estandarizar protocolos de comunicación
- Permitir interoperabilidad entre diferentes sistemas
- Facilitar el diseño y troubleshooting de redes
- Separar responsabilidades en capas independientes


TIME OUT SOCKET CONNECTION
## Las 7 Capas del Modelo OSI:

### **Capa 7 - Application (Aplicación)**

- **Función**: Interfaz directa con aplicaciones de usuario
- **Responsabilidades**:
    - Servicios de red para aplicaciones
    - Identificación de usuarios
    - Formateo de datos
- **Protocolos**: HTTP, HTTPS, FTP, SMTP, POP3, IMAP, DNS, DHCP
- **Ejemplos**: Navegadores web, clientes de email, aplicaciones de chat

### **Capa 6 - Presentation (Presentación)**

- **Función**: Traducción, encriptación y compresión de datos
- **Responsabilidades**:
    - Formateo de datos (ASCII, JPEG, MP3)
    - Encriptación/desencriptación
    - Compresión/descompresión
- **Protocolos**: SSL/TLS, JPEG, GIF, MPEG
- **Ejemplos**: Conversión de caracteres, cifrado de datos

### **Capa 5 - Session (Sesión)**

- **Función**: Establecimiento, gestión y terminación de sesiones
- **Responsabilidades**:
    - Control de diálogo (full-duplex, half-duplex)
    - Establecimiento de sesiones
    - Sincronización y recuperación
- **Protocolos**: NetBIOS, RPC, SQL, NFS
- **Ejemplos**: Login de usuario, conexiones de base de datos

### **Capa 4 - Transport (Transporte)**

- **Función**: Entrega confiable de datos end-to-end
- **Responsabilidades**:
    - Segmentación y reensamblado
    - Control de flujo
    - Detección y corrección de errores
    - Multiplexing
- **Protocolos**: TCP, UDP, SPX
- **Ejemplos**: Puertos (80, 443, 22), conexiones TCP

### **Capa 3 - Network (Red)**

- **Función**: Enrutamiento de paquetes entre diferentes redes
- **Responsabilidades**:
    - Direccionamiento lógico (IP)
    - Enrutamiento de paquetes
    - Determinación de rutas
    - Control de congestión
- **Protocolos**: IP, ICMP, ARP, OSPF, BGP
- **Dispositivos**: Routers, switches de capa 3
- **Ejemplos**: Direcciones IP, tablas de enrutamiento

### **Capa 2 - Data Link (Enlace de Datos)**

- **Función**: Transmisión confiable de frames entre nodos adyacentes
- **Responsabilidades**:
    - Framing (encapsulación en frames)
    - Direccionamiento físico (MAC)
    - Detección y corrección de errores
    - Control de acceso al medio
- **Protocolos**: Ethernet, Wi-Fi (802.11), PPP, Frame Relay
- **Dispositivos**: Switches, bridges, NICs
- **Ejemplos**: Direcciones MAC, frames Ethernet

### **Capa 1 - Physical (Física)**

- **Función**: Transmisión de bits puros a través del medio físico
- **Responsabilidades**:
    - Especificaciones eléctricas y físicas
    - Activación/desactivación de conexiones
    - Transmisión de señales
- **Protocolos**: RS-232, RJ45, USB, Bluetooth físico
- **Dispositivos**: Cables, hubs, repetidores, antenas
- **Ejemplos**: Cables de cobre, fibra óptica, señales de radio

## Flujo de datos:

### **Envío (Encapsulación):**

```text
Aplicación    → Data
Presentación  → Data
Sesión        → Data
Transporte    → Segments
Red           → Packets
Enlace        → Frames
Física        → Bits
```

### **Recepción (Desencapsulación):**

```text
Física        → Bits
Enlace        → Frames
Red           → Packets
Transporte    → Segments
Sesión        → Data
Presentación  → Data
Aplicación    → Data
```

## Ejemplo práctico - Navegación web:

### **Envío de solicitud HTTP:**

```text
7 - Aplicación:    Usuario escribe URL en navegador
6 - Presentación:  Codificación de caracteres (UTF-8)
5 - Sesión:        Establecer sesión HTTP
4 - Transporte:    TCP puerto 80/443, segmentación
3 - Red:           IP routing hacia servidor web
2 - Enlace:        Frame Ethernet con MAC addresses
1 - Física:        Señales eléctricas por cable/WiFi
```

## Ventajas del Modelo OSI:

### **Modularidad:**

- Cada capa tiene responsabilidades específicas
- Cambios en una capa no afectan otras
- Facilita el desarrollo y mantenimiento

### **Interoperabilidad:**

- Estándar común para fabricantes
- Productos de diferentes vendors pueden comunicarse
- Facilita la integración de sistemas

### **Troubleshooting:**

- Metodología sistemática para resolver problemas
- Aislamiento de problemas por capa
- Herramientas específicas para cada nivel

## Modelo OSI vs TCP/IP:

### **OSI (7 capas):**

- Modelo teórico completo
- Mayor granularidad
- Educativo y de referencia

### **TCP/IP (4 capas):**

- Modelo práctico implementado
- Más simple y directo
- Base de Internet actual

```
OSI                 TCP/IP
7. Aplicación   ┐
8. Presentación ├─→ Aplicación
9. Sesión       ┘
10. Transporte   ──→ Transporte
11. Red          ──→ Internet
12. Enlace       ┐
13. Física       └─→ Acceso a Red
```

## Herramientas por capa:

### **Capa 1-2:**

- Analizadores de cable
- Switches managed
- Wireshark (frames)

### **Capa 3:**

- Ping, traceroute
- Routers, firewalls
- Wireshark (packets)

### **Capa 4:**

- Netstat, ss
- Load balancers
- Port scanners

### **Capa 5-7:**

- Telnet, curl
- Proxies, WAFs
- Application monitors
