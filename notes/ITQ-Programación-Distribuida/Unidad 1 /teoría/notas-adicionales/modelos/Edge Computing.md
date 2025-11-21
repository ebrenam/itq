# Edge Computing

**Edge Computing** es un paradigma de computación distribuida que acerca el procesamiento de datos y los servicios computacionales al lugar donde se generan o consumen los datos, es decir, al "borde" de la red.

## ¿Qué es Edge Computing?

### **Definición:**

- Procesamiento de datos cerca de la fuente
- Reducción de latencia y ancho de banda
- Computación distribuida en el "edge" de la red
- Complemento (no reemplazo) del cloud computing

### **Concepto clave:**

En lugar de enviar todos los datos al cloud centralizado, el procesamiento se realiza localmente en dispositivos edge o servidores cercanos.

## Arquitectura de Edge Computing:

### **Niveles del Edge:**

```
Cloud (Datacenter Centralizado)
        ↕
Regional Edge (CDN, Regional DC)
        ↕
Local Edge (Edge Servers, Gateways)
        ↕
Device Edge (IoT, Smartphones, Sensores)
```

### **Componentes principales:**

#### **1. Edge Devices:**

- **IoT sensors**: Temperatura, presión, movimiento
- **Smart devices**: Smartphones, tablets, wearables
- **Industrial equipment**: Máquinas, robots, vehículos
- **Cameras**: Sistemas de videovigilancia

#### **2. Edge Gateways:**

- **Función**: Agregación y preprocesamiento
- **Capacidades**: Conectividad, almacenamiento temporal
- **Ejemplos**: Routers industriales, gateways IoT

#### **3. Edge Servers:**

- **Mini datacenters**: Servidores locales o regionales
- **Edge nodes**: Infraestructura distribuida
- **Ejemplos**: Torres de telecomunicaciones, micro-DCs

#### **4. Edge Software:**

- **Runtime environments**: Kubernetes edge, Docker
- **Analytics platforms**: Stream processing, ML
- **Management tools**: Orquestación, monitoreo

## Casos de Uso Principales:

### **1. Vehículos Autónomos**

- **Latencia crítica**: Decisiones en milisegundos
- **Procesamiento local**: Detección de obstáculos
- **Conectividad limitada**: Túneles, áreas rurales

### **2. Manufactura Inteligente (Industry 4.0)**

- **Control en tiempo real**: Líneas de producción
- **Mantenimiento predictivo**: Análisis de vibraciones
- **Calidad**: Inspección visual automatizada

### **3. Smart Cities**

- **Tráfico inteligente**: Semáforos adaptativos
- **Seguridad pública**: Videoanalítica en tiempo real
- **Gestión de energía**: Redes eléctricas inteligentes

### **4. Retail y Comercio**

- **Análisis de clientes**: Comportamiento en tienda
- **Inventory management**: RFID, computer vision
- **Checkout autónomo**: Tiendas sin cajeros

### **5. Healthcare**

- **Monitoreo remoto**: Wearables médicos
- **Telemedicina**: Consultas en tiempo real
- **Diagnóstico**: Procesamiento de imágenes médicas

### **6. Gaming y Entertainment**

- **Cloud gaming**: Reducción de latencia
- **AR/VR**: Experiencias inmersivas
- **Content delivery**: Streaming de video

### **7. Agricultura Inteligente**

- **Sensores de cultivos**: Humedad, nutrientes
- **Drones agrícolas**: Análisis de imágenes
- **Riego automatizado**: Sistemas adaptativos

## Beneficios del Edge Computing:

### **1. Latencia Reducida**

```
Cloud Computing:    50-100ms típico
Edge Computing:     1-10ms típico
Device Processing:  <1ms
```

### **2. Ancho de Banda Optimizado**

- **Menos datos al cloud**: Solo información relevante
- **Costos reducidos**: Menos transferencia de datos
- **Mejor performance**: Red menos congestionada

### **3. Disponibilidad Mejorada**

- **Operación offline**: Funciona sin conectividad
- **Redundancia**: Múltiples puntos de procesamiento
- **Resilencia**: Menos puntos de falla únicos

### **4. Privacidad y Seguridad**

- **Datos locales**: Información sensible no sale del edge
- **Compliance**: Cumplimiento de regulaciones locales
- **Soberanía de datos**: Control jurisdiccional

### **5. Costo-Efectividad**

- **Menos cloud usage**: Reducción de costos operativos
- **Eficiencia de red**: Menor uso de ancho de banda
- **Escalabilidad**: Distribución de carga

## Desafíos del Edge Computing:

### **1. Gestión y Orquestación**

- **Complejidad**: Miles de dispositivos distribuidos
- **Updates**: Actualización de software remota
- **Monitoreo**: Visibilidad de la infraestructura

### **2. Seguridad**

- **Surface area**: Más puntos de ataque
- **Gestión de credenciales**: Autenticación distribuida
- **Parches de seguridad**: Actualización remota

### **3. Recursos Limitados**

- **Poder computacional**: Menos que cloud
- **Almacenamiento**: Capacidad limitada
- **Energía**: Especialmente en IoT

### **4. Conectividad**

- **Red intermitente**: Conexiones no confiables
- **Sincronización**: Estado entre edge y cloud
- **Protocolos**: Optimización para baja latencia

## Tecnologías Habilitadoras:

### **5G y Redes**

- **Ultra-low latency**: <1ms en algunos casos
- **Network slicing**: Redes virtuales dedicadas
- **MEC**: Multi-access Edge Computing

### **AI/ML en el Edge**

- **TensorFlow Lite**: ML optimizado para edge
- **ONNX Runtime**: Inferencia optimizada
- **Edge TPUs**: Hardware especializado

### **Containerización**

- **Docker**: Contenedores ligeros
- **Kubernetes**: Orquestación distribuida
- **KubeEdge**: Kubernetes para edge

### **Hardware Especializado**

- **ARM processors**: Eficiencia energética
- **FPGAs**: Procesamiento personalizable
- **GPUs edge**: Aceleración de AI

## Arquitecturas Populares:

### **1. Fog Computing (Cisco)**

- **Concepto**: Extensión del cloud al edge
- **Jerarquía**: Cloud → Fog → Edge devices

### **2. Multi-access Edge Computing (MEC)**

- **Estándar**: ETSI MEC
- **Enfoque**: Telecomunicaciones y 5G
- **Ubicación**: Base stations, cell towers

### **3. Cloudlets (CMU)**

- **Concepto**: "Mini-clouds" distribuidos
- **Propósito**: Mobile computing offloading

## Comparación Edge vs Cloud vs Fog:

```
                Edge        Fog         Cloud
Latencia:       <1ms        1-10ms      50-100ms
Ubicación:      Device      Local       Remoto
Recursos:       Limitados   Medios      Ilimitados
Conectividad:   Opcional    Requerida   Siempre
Costo:          Bajo        Medio       Variable
```

## Futuro del Edge Computing:

### **Tendencias emergentes:**

- **Autonomous edge**: Self-managing systems
- **Edge-to-edge**: Comunicación directa entre edges
- **Quantum edge**: Computación cuántica distribuida
- **Neuromorphic computing**: Chips que imitan el cerebro

### **Mercado:**

- **Crecimiento**: 38%+ CAGR hasta 2028
- **Valor**: $250+ billones proyectados para 2028
- **Drivers**: 5G, IoT, AI, autonomous vehicles
