## Modelos de Red Alternativos:

### **1. Modelo DoD (Department of Defense)**

- **Origen**: Predecesor del TCP/IP, desarrollado por DARPA
- **Capas**: 4 capas similar a TCP/IP
- **Importancia**: Base histórica de Internet

### **2. Modelo Híbrido de 5 Capas**

- **Combinación**: OSI + TCP/IP
- **Capas**:
    1. Física
    2. Enlace de Datos
    3. Red
    4. Transporte
    5. Aplicación
- **Uso**: Educativo, combina lo mejor de ambos modelos

### **3. Modelo SNA (Systems Network Architecture)**

- **Desarrollador**: IBM (1974)
- **Propósito**: Redes mainframe IBM
- **Características**:
    - 7 capas (similar a OSI)
    - Orientado a conexión
    - Arquitectura propietaria de IBM

#### **Capas SNA:**

```text
7 - Transaction Services
6 - Presentation Services
5 - Data Flow Control
4 - Transmission Control
3 - Path Control
2 - Data Link Control
1 - Physical Control
```


### **4. Modelo DNA (Digital Network Architecture)**

- **Desarrollador**: Digital Equipment Corporation (DEC)
- **Protocolo**: DECnet
- **Características**:
    - Arquitectura de redes distribuidas
    - Competidor histórico de SNA

### **5. Modelo ATM (Asynchronous Transfer Mode)**

- **Propósito**: Redes de alta velocidad
- **Características**:
    - Basado en celdas de 53 bytes
    - Garantías de QoS
    - Integra voz, video y datos

#### **Capas ATM:**

```text
Higher Layer Protocols
ATM Adaptation Layer (AAL)
ATM Layer
Physical Layer
```

### **6. Modelo Frame Relay**

- **Tipo**: Protocolo WAN
- **Características**:
    - Conmutación de paquetes
    - Orientado a conexión
    - Usado en WANs empresariales

### **7. Modelo X.25**

- **Estándar**: ITU-T
- **Características**:
    - Protocolo WAN legacy
    - Conmutación de paquetes
    - Muy confiable pero lento

#### **Capas X.25:**

```text
Packet Layer (Layer 3)
Frame Layer (Layer 2) 
Physical Layer (Layer 1)
``` 

### **8. Modelo AppleTalk**

- **Desarrollador**: Apple
- **Propósito**: Redes Apple/Macintosh
- **Estado**: Descontinuado

### **9. Modelo NetWare (IPX/SPX)**

- **Desarrollador**: Novell
- **Protocolo**: IPX/SPX
- **Uso histórico**: Redes de área local en los 90s

### **10. Modelo DECNET**

- **Desarrollador**: Digital Equipment Corporation
- **Características**:
    - Arquitectura peer-to-peer
    - Routing jerárquico

## Modelos Modernos y Especializados:

### **11. Modelo SDN (Software-Defined Networking)**

- **Capas**:
    - Application Layer
    - Control Layer (SDN Controller)
    - Infrastructure Layer (Switches)
- **Características**:
    - Separación de control y datos
    - Centralización del control
    - Programabilidad

### **12. Modelo IoT (Internet of Things)**

- **Capas especializadas**:
    - Perception Layer (Sensores)
    - Network Layer (Conectividad)
    - Middleware Layer (Procesamiento)
    - Application Layer (Servicios)

### **13. Modelo Cloud Computing**

- **Capas de servicio**:
    - SaaS (Software as a Service)
    - PaaS (Platform as a Service)
    - IaaS (Infrastructure as a Service)

## Comparación de Adopción:

### **Modelos Históricos (Legacy):**

- **SNA**: Mainframes IBM (descontinuado)
- **DECnet**: Redes DEC (descontinuado)
- **AppleTalk**: Redes Apple (descontinuado)
- **IPX/SPX**: Redes Novell (descontinuado)

### **Modelos Actuales:**

- **TCP/IP**: Estándar dominante
- **OSI**: Modelo de referencia educativo
- **ATM**: Nichos específicos (telecom)
- **Frame Relay**: Legacy WAN (siendo reemplazado)

### **Modelos Emergentes:**

- **SDN**: Redes empresariales modernas
- **IoT**: Dispositivos conectados
- **Edge Computing**: Procesamiento distribuido

## ¿Por qué TCP/IP dominó?

### **Factores de éxito:**

1. **Adopción temprana en Internet**
2. **Implementación práctica y funcional**
3. **Código abierto y estándares abiertos**
4. **Simplicidad relativa (4 vs 7 capas)**
5. **Escalabilidad probada**
6. **Soporte universal de fabricantes**

### **Limitaciones de otros modelos:**

- **Propietarios**: SNA, DECnet, AppleTalk
- **Complejos**: OSI (demasiado teórico)
- **Especializados**: ATM, Frame Relay
- **Timing**: Llegaron tarde al mercado

## Uso Actual:

### **En Producción:**

- **TCP/IP**: 99%+ de redes
- **ATM**: Algunas redes de telecom
- **Frame Relay**: WANs legacy (declinando)

### **En Educación:**

- **OSI**: Modelo de referencia teórico
- **Híbrido 5 capas**: Enseñanza práctica
- **TCP/IP**: Implementación real

### **En Investigación:**

- **SDN/OpenFlow**: Redes programables
- **Named Data Networking**: Internet del futuro
- **QUIC**: Protocolo de transporte moderno

