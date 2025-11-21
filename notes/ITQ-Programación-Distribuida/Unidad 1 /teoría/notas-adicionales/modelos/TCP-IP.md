# TCP/IP

**El Modelo TCP/IP** (Transmission Control Protocol/Internet Protocol) es el modelo de referencia práctico que define la arquitectura de protocolos de Internet y la mayoría de redes modernas.

## ¿Qué es el Modelo TCP/IP?

### **Definición:**

- Modelo de protocolos desarrollado por DARPA en los años 70
- Base arquitectural de Internet
- Modelo práctico e implementado (vs OSI teórico)
- También conocido como Internet Protocol Suite

### **Características:**

- 4 capas principales (vs 7 del OSI)
- Orientado a la práctica
- Protocolos reales y funcionales
- Estándar de facto en redes

## Las 4 Capas del Modelo TCP/IP:

### **Capa 4 - Application (Aplicación)**

- **Función**: Servicios de red para aplicaciones de usuario
- **Equivale a**: OSI capas 5, 6 y 7
- **Responsabilidades**:
    - Interfaz con aplicaciones
    - Formateo y presentación de datos
    - Gestión de sesiones

#### **Protocolos principales:**

- **HTTP/HTTPS**: Navegación web
- **FTP/SFTP**: Transferencia de archivos
- **SMTP/POP3/IMAP**: Correo electrónico
- **DNS**: Resolución de nombres
- **DHCP**: Configuración automática de red
- **SSH**: Acceso remoto seguro
- **Telnet**: Acceso remoto no seguro
- **SNMP**: Gestión de red

### **Capa 3 - Transport (Transporte)**

- **Función**: Comunicación confiable end-to-end
- **Equivale a**: OSI capa 4
- **Responsabilidades**:
    - Segmentación y reensamblado
    - Control de flujo y errores
    - Multiplexing de aplicaciones

#### **Protocolos principales:**

##### **TCP (Transmission Control Protocol):**

- **Características**:
    - Orientado a conexión
    - Confiable (garantiza entrega)
    - Control de flujo
    - Detección y corrección de errores
- **Usos**: HTTP, HTTPS, FTP, SMTP, SSH
- **Header**: 20 bytes mínimo

##### **UDP (User Datagram Protocol):**

- **Características**:
    - Sin conexión (connectionless)
    - No confiable (best effort)
    - Rápido y eficiente
    - Sin control de flujo
- **Usos**: DNS, DHCP, streaming, gaming
- **Header**: 8 bytes

### **Capa 2 - Internet (Red)**

- **Función**: Enrutamiento de paquetes entre redes
- **Equivale a**: OSI capa 3
- **Responsabilidades**:
    - Direccionamiento lógico
    - Enrutamiento entre redes
    - Fragmentación de paquetes

#### **Protocolos principales:**

##### **IP (Internet Protocol):**

- **IPv4**: 32 bits (4.3 mil millones de direcciones)
- **IPv6**: 128 bits (340 sextillones de direcciones)

##### **Protocolos de soporte:**

- **ICMP**: Mensajes de control y error (ping, traceroute)
- **ARP**: Resolución de direcciones (IP a MAC)
- **RARP**: Resolución inversa (MAC a IP)

##### **Protocolos de enrutamiento:**

- **RIP**: Routing Information Protocol
- **OSPF**: Open Shortest Path First
- **BGP**: Border Gateway Protocol

### **Capa 1 - Network Access (Acceso a Red)**

- **Función**: Acceso al medio físico de transmisión
- **Equivale a**: OSI capas 1 y 2
- **Responsabilidades**:
    - Acceso al medio físico
    - Direccionamiento físico (MAC)
    - Framing y detección de errores

#### **Tecnologías comunes:**

- **Ethernet**: Redes cableadas
- **Wi-Fi (802.11)**: Redes inalámbricas
- **PPP**: Point-to-Point Protocol
- **Frame Relay**: WAN legacy
- **ATM**: Asynchronous Transfer Mode

## Comparación TCP/IP vs OSI:

```text
TCP/IP              OSI
┌─────────────┐    ┌─────────────┐
│ Application │    │ Application │ 7
│             │    ├─────────────┤
│             │    │Presentation │ 6
│             │    ├─────────────┤
│             │    │   Session   │ 5
├─────────────┤    ├─────────────┤
│ Transport   │    │ Transport   │ 4
├─────────────┤    ├─────────────┤
│  Internet   │    │   Network   │ 3
├─────────────┤    ├─────────────┤
│Network      │    │ Data Link   │ 2
│Access       │    ├─────────────┤
│             │    │  Physical   │ 1
└─────────────┘    └─────────────┘
```

## Ejemplo práctico - Navegación web:

### **Proceso completo:**

#### **1. Application Layer:**

```text
Usuario → navegador → solicitud HTTP
GET /index.html HTTP/1.1
Host: www.ejemplo.com
```

#### **2. Transport Layer:**

```text
TCP establece conexión:
- SYN (cliente → servidor)
- SYN-ACK (servidor → cliente)  
- ACK (cliente → servidor)

Puerto origen: 12345
Puerto destino: 80
```

#### **3. Internet Layer:**

```text
IP encapsula datos TCP:
IP origen: 192.168.1.100
IP destino: 93.184.216.34
TTL: 64
Protocolo: TCP (6)
```

#### **4. Network Access Layer:**

```text
Ethernet frame:
MAC origen: AA:BB:CC:DD:EE:FF
MAC destino: 11:22:33:44:55:66
Tipo: IPv4 (0x0800)
```

## Direccionamiento en TCP/IP:

### **Direcciones IPv4:**

```text
Clases principales:
Clase A: 1.0.0.0    - 126.0.0.0     (/8)
Clase B: 128.0.0.0  - 191.255.0.0   (/16)
Clase C: 192.0.0.0  - 223.255.255.0 (/24)

Direcciones privadas:
10.0.0.0/8         (Clase A)
172.16.0.0/12      (Clase B)
192.168.0.0/16     (Clase C)
```

### **Puertos comunes:**

```text
Aplicación    Puerto TCP    Puerto UDP
HTTP          80           -
HTTPS         443          -
FTP           21           -
SSH           22           -
Telnet        23           -
SMTP          25           -
DNS           -            53
DHCP          -            67/68
SNMP          -            161/162
```

## Encapsulación de datos:

### **Proceso de envío:**

```text
Application:  HTTP Request
Transport:    TCP Header + Data = Segment
Internet:     IP Header + Segment = Packet
Network:      Ethernet Header + Packet = Frame
```

### **Headers típicos:**

```text
Ethernet Header (14 bytes):
[Dest MAC][Src MAC][Type]

IP Header (20 bytes mínimo):
[Ver][Len][ToS][Total Len][ID][Flags][Fragment][TTL][Protocol][Checksum][Src IP][Dest IP]

TCP Header (20 bytes mínimo):
[Src Port][Dest Port][Seq][Ack][Flags][Window][Checksum][Urgent]
```

## Ventajas del Modelo TCP/IP:

### **Practicidad:**

- Protocolos realmente implementados
- Probado en el mundo real
- Base de Internet actual

### **Escalabilidad:**

- Funciona desde LANs hasta Internet global
- Soporta millones de dispositivos
- Routing jerárquico eficiente

### **Flexibilidad:**

- Independiente del hardware
- Múltiples tecnologías de red
- Extensible y adaptable

## Herramientas de diagnóstico:

### **Capa Internet:**

```bash
# Verificar conectividad
ping 8.8.8.8

# Rastrear ruta
traceroute google.com

# Ver tabla de enrutamiento
route -n  # Linux
netstat -r  # macOS/Windows
```

### **Capa Transport:**

```bash
# Ver conexiones TCP/UDP
netstat -an
ss -tuln  # Linux moderno

# Escanear puertos
nmap -sT target.com
```

### **Capa Application:**

```bash
# Resolución DNS
nslookup google.com
dig google.com

# Conectividad HTTP
curl -I http://ejemplo.com
telnet ejemplo.com 80
```
