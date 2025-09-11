[[Definición]]

## Programación Distribuida

### Definición

- Paradigma donde el procesamiento se divide entre múltiples computadoras
- Los componentes están físicamente separados pero colaboran
- Se comunican a través de la red para resolver problemas

### Características

- **Ubicación**: Múltiples máquinas (pueden estar en cualquier lugar)
- **Control**: Generalmente bajo control directo del desarrollador
- **Infraestructura**: Hardware propio o dedicado
- **Comunicación**: Protocolos de red (TCP/IP, RPC, messaging)

### Ejemplos

```text
- Cluster de servidores en un datacenter
- Grid computing
- Peer-to-peer networks
- Microservicios en múltiples servidores
- Sistemas distribuidos académicos
```

## Programación en la Nube

### Definición

- Desarrollo de aplicaciones que utilizan servicios de cloud computing
- Aprovecha recursos y servicios gestionados por proveedores
- Se ejecuta en infraestructura virtualizada y escalable

### Características

- **Ubicación**: Datacenters del proveedor de nube
- **Control**: Infraestructura gestionada por terceros
- **Servicios**: APIs y servicios pre-construidos
- **Escalabilidad**: Automática y bajo demanda

### Ejemplos

```text
- Aplicaciones en AWS, Azure, Google Cloud
- Serverless functions (Lambda, Azure Functions)
- Bases de datos como servicio (RDS, Cosmos DB)
- APIs y microservicios en Kubernetes
```

## Comparación Detallada

### **1. Infraestructura**

#### **Distribuida:**

- Hardware físico específico
- Red propia o dedicada
- Control total sobre la configuración
- Mantenimiento manual

#### **Nube:**

- Infraestructura virtualizada
- Red global del proveedor
- Configuración a través de APIs/consolas
- Mantenimiento automático

### **2. Escalabilidad**

#### **Distribuida:**

```bash
# Escalabilidad manual
def scale_cluster():
    # Agregar nodos manualmente
    new_nodes = provision_servers(count=3)
    configure_cluster(new_nodes)
    balance_load()
```

#### **Nube:**

```bash
# Auto-scaling automático
auto_scaling_group = {
    "min_instances": 2,
    "max_instances": 10,
    "target_cpu": 70
}
```

### **3. Modelo de Costos**

#### **Distribuida:**

- **CAPEX**: Inversión inicial en hardware
- **OPEX**: Mantenimiento, electricidad, personal
- **Costos fijos**: Independiente del uso

#### **Nube:**

- **Pay-as-you-use**: Solo pagas lo que consumes
- **No CAPEX**: Sin inversión inicial
- **Costos variables**: Escalan con el uso

### **4. Complejidad de Desarrollo**

#### **Distribuida:**

```java
// Ejemplo: Sistema distribuido tradicional
public class DistributedService {
    private List<ServerNode> nodes;
    
    public void processRequest(Request req) {
        // Gestión manual de nodos
        ServerNode availableNode = findAvailableNode();
        if (availableNode == null) {
            handleFailover();
        }
        // Comunicación directa entre nodos
        Result result = availableNode.process(req);
    }
}
```

#### **Nube:**

```java
# Ejemplo: Aplicación cloud-native
import boto3

def lambda_handler(event, context):
    # Servicios gestionados
    dynamodb = boto3.resource('dynamodb')
    s3 = boto3.client('s3')
    
    # Procesamiento sin gestión de infraestructura
    table = dynamodb.Table('users')
    response = table.get_item(Key={'id': event['user_id']})
    
    return {
        'statusCode': 200,
        'body': response['Item']
    }
```

### **5. Gestión de Estado y Datos**

#### **Distribuida:**

- Estado distribuido entre nodos
- Sincronización manual
- Consensus algorithms (Raft, Paxos)
- Bases de datos distribuidas propias

#### **Nube:**

- Servicios de estado gestionados
- Bases de datos como servicio
- Caching distribuido (Redis, Memcached)
- Object storage (S3, Blob Storage)

## Ventajas y Desventajas:

### **Programación Distribuida**

#### **Ventajas:**

- Control total sobre la infraestructura
- Sin vendor lock-in
- Optimización específica para el caso de uso
- Cumplimiento de regulaciones específicas

#### **Desventajas:**

- Alta complejidad de gestión
- Costos de mantenimiento
- Escalabilidad manual
- Requiere expertise en infraestructura

### **Programación en la Nube**

#### **Ventajas:**

- Desarrollo más rápido
- Escalabilidad automática
- Servicios gestionados
- Reducción de costos operativos

#### **Desventajas:**

- Vendor lock-in
- Menos control sobre infraestructura
- Costos variables e impredecibles
- Dependencia de conectividad

## Casos de Uso Típicos:

### **Distribuida:**

```text
- Sistemas bancarios críticos
- Investigación científica (HPC)
- Telecomunicaciones
- Sistemas embebidos distribuidos
- Aplicaciones con requisitos de latencia extrema
```

### **Nube:**

```text
- Aplicaciones web modernas
- Startups y desarrollo ágil
- E-commerce y retail
- Aplicaciones móviles
- Analytics y Big Data
```

## Híbridos Modernos:

### **Multi-Cloud:**

- Combinación de múltiples proveedores
- Evita vendor lock-in
- Optimización por región/servicio

### **Edge + Cloud:**

- Procesamiento local (edge)
- Almacenamiento y analytics en cloud
- Mejor latencia y disponibilidad

### **Hybrid Cloud:**

- Infraestructura propia + nube
- Datos sensibles on-premise
- Workloads variables en cloud

## Tendencias Actuales:

### **Convergencia:**

- **Cloud-native distributed systems**
- **Serverless computing**
- **Container orchestration** (Kubernetes)
- **Event-driven architectures**

### **Ejemplo moderno:**

```yaml
# Kubernetes: Distribuido + Cloud
apiVersion: apps/v1
kind: Deployment
metadata:
  name: microservice
spec:
  replicas: 3
  selector:
    matchLabels:
      app: microservice
  template:
    spec:
      containers:
      - name: app
        image: myapp:latest
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
```

## Conclusión:

- **Distribuida**: Más control, mayor complejidad
- **Nube**: Más agilidad, menor control
- **Tendencia**: Sistemas híbridos que combinan ambos enfoques
- **Decisión**: Depende de requisitos específicos, recursos y expertise

[[Definición]]
