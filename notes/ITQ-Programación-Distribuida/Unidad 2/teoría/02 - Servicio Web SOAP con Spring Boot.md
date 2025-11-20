# 📚 Guía Didáctica
## Proyecto: Sistema de Reservas de Gimnasio

### 🎯 Objetivo
Entender los conceptos básicos de servicios web SOAP y su implementación en Spring Boot para futuros desarrolladores.

---

## 📖 ¿Qué es SOAP?

**SOAP (Simple Object Access Protocol)** es un protocolo estándar para intercambiar información estructurada en aplicaciones distribuidas.

### Características principales:
- ✅ **Basado en XML**: Todos los mensajes son documentos XML
- ✅ **Protocolo estándar**: Especificación W3C bien definida  
- ✅ **Transport agnóstico**: Puede usar HTTP, JMS, etc.
- ✅ **Contratos bien definidos**: WSDL describe exactamente el servicio
- ✅ **Enterprise ready**: Soporte robusto para transacciones, seguridad

### 🆚 SOAP vs REST (Comparación rápida)
| Aspecto | SOAP | REST |
|---------|------|------|
| **Formato** | XML obligatorio | JSON, XML, HTML |
| **Protocolo** | Estricto, basado en estándares | Arquitectónico, flexible |
| **Contratos** | WSDL (definición formal) | OpenAPI (opcional) |
| **Casos de uso** | Sistemas empresariales, transacciones críticas | APIs web modernas, móviles |

---

## 🏗️ Arquitectura del Proyecto

```
gym-reservation-service/
├── 📁 src/main/resources/
│   ├── 📄 wsdl/gymReservation.wsdl    # Contrato del servicio (WSDL)
│   └── 📄 xsd/gym.xsd                 # Esquema de datos (XSD)
├── 📁 src/main/java/com/gym/reservation/
│   ├── 📄 GymReservationServiceApplication.java  # Aplicación principal
│   ├── 📁 dto/                        # Clases generadas automáticamente
│   │   ├── 📄 Reservation.java
│   │   ├── 📄 ReservationType.java
│   │   └── 📄 Confirmation.java
│   └── 📁 service/
│       ├── 📄 GymEndpoint.java        # Lógica del servicio SOAP
│       └── 📄 GymReservationWebServiceConfig.java  # Configuración
└── 📄 pom.xml                         # Dependencias Maven
```

---

## 🏷️ ¿Qué son las Anotaciones en Java?

### 📝 Concepto Básico

Las **anotaciones** son metadatos que se agregan al código Java para proporcionar información adicional al compilador, frameworks o herramientas de desarrollo. Son como "etiquetas" que le dicen al programa cómo debe comportarse.

### 🔍 Sintaxis y Estructura

```java
@NombreDeLaAnotacion
public class MiClase {
    
    @OtraAnotacion(parametro = "valor")
    public void miMetodo() {
        // código aquí
    }
}
```

**Características importantes:**
- Comienzan con el símbolo `@`
- Pueden tener parámetros opcionales
- No afectan directamente la lógica del programa
- Son procesadas por frameworks o herramientas externas

### 🎯 ¿Para qué se Utilizan las Anotaciones?

#### 1. **Configuración Declarativa**
En lugar de escribir archivos XML complejos, las anotaciones permiten configurar directamente en el código:

```java
// ❌ Antes (XML): <bean id="miServicio" class="com.ejemplo.MiServicio"/>
// ✅ Ahora (Anotación):
@Service
public class MiServicio {
    // Spring automáticamente registra esta clase como un servicio
}
```

#### 2. **Inyección de Dependencias**
Las anotaciones le dicen a Spring qué objetos necesita crear y cómo conectarlos:

```java
@Service
public class ReservationService {
    
    @Autowired  // ← Spring automáticamente inyecta la dependencia
    private DatabaseRepository repository;
}
```

#### 3. **Mapeo de Rutas y Endpoints**
Definen cómo responder a diferentes peticiones:

```java
@PayloadRoot(namespace = "http://com.gym", localPart = "reservation")
public Confirmation createReservation(@RequestPayload Reservation request) {
    // Este método maneja peticiones SOAP para "reservation"
}
```

#### 4. **Validación Automática**
```java
public class Usuario {
    @NotNull
    @Size(min = 2, max = 30)
    private String nombre;  // Spring validará automáticamente estos campos
}
```

### 🚀 Ventajas de las Anotaciones

| Ventaja | Descripción | Ejemplo |
|---------|-------------|---------|
| **Simplicidad** | Menos código, más claro | `@Service` vs configuración XML |
| **Cercanía** | La configuración está junto al código | Validaciones junto a los campos |
| **Type-Safe** | Detección de errores en tiempo de compilación | El IDE detecta anotaciones incorrectas |
| **Autocompletado** | Los IDEs pueden sugerir anotaciones | IntelliJ/VS Code muestran opciones |

### 🔧 Tipos de Anotaciones en nuestro Proyecto

#### **🌱 Anotaciones de Spring Framework**

```java
@SpringBootApplication  // Punto de entrada de la aplicación
@Configuration          // Clase de configuración
@Service                // Clase de servicio de negocio
@Component              // Componente genérico de Spring
@Bean                   // Método que produce un bean
@Autowired              // Inyección automática de dependencias
```

#### **🌐 Anotaciones de Web Services**

```java
@EnableWs           // Habilita soporte para Web Services SOAP
@Endpoint           // Marca la clase como endpoint SOAP
@PayloadRoot        // Define qué mensajes maneja cada método
@RequestPayload     // Parámetro de entrada del mensaje SOAP
@ResponsePayload    // Valor de retorno del mensaje SOAP
```

#### **📄 Anotaciones de JAXB (XML Binding)**

```java
@XmlRootElement     // Elemento raíz del XML
@XmlElement         // Campo que se mapea a un elemento XML
@XmlAccessorType    // Cómo acceder a los campos (FIELD, PROPERTY)
@XmlType            // Información del tipo XML
```

### 🎓 Ejemplo Práctico: Análisis de GymEndpoint

```java
@Endpoint  // ← Le dice a Spring: "Esta clase maneja peticiones SOAP"
public class GymEndpoint {
    
    // ↓ Este método maneja peticiones XML que tengan:
    //   - namespace: "http://com.gym" 
    //   - elemento raíz: "reservation"
    @PayloadRoot(namespace = NAMESPACE_URI, localPart = "reservation")
    @ResponsePayload  // ← El objeto retornado se convierte a XML automáticamente
    public Confirmation createReservation(
            @RequestPayload Reservation request) {  // ← El XML se convierte a objeto automáticamente
        
        // Lógica de negocio aquí...
        return confirmation;
    }
}
```

**🔍 ¿Qué pasa "detrás de escena"?**

1. **Spring escanea** todas las clases buscando `@Endpoint`
2. **Registra automáticamente** la clase como manejador SOAP
3. **Analiza** las anotaciones `@PayloadRoot` para saber qué mensajes manejar
4. **Convierte automáticamente** XML ↔ Objetos Java usando JAXB
5. **Enruta** las peticiones al método correcto basándose en el contenido XML

### 🧠 Concepto Clave: "Convention over Configuration"

Las anotaciones siguen el principio de **"Convención sobre Configuración"**:

```java
// ❌ Configuración manual (mucho código):
// - Crear archivo XML de configuración
// - Definir mappings XML-Java
// - Configurar rutas manualmente
// - Registrar servicios explícitamente

// ✅ Con anotaciones (convención):
@Endpoint                    // "Por convención, esta es un endpoint"
@PayloadRoot(/* ... */)     // "Por convención, maneja este tipo de mensaje"
public Confirmation createReservation(@RequestPayload Reservation request) {
    // Spring hace todo lo demás automáticamente
}
```

### 💡 Analogía Simple

**Las anotaciones son como etiquetas en una oficina:**

- `@Endpoint` = Etiqueta "RECEPCIONISTA" → "Esta persona atiende clientes"
- `@PayloadRoot` = Etiqueta "ESPECIALISTA EN RESERVAS" → "Esta persona maneja solo reservas"
- `@Service` = Etiqueta "SERVICIO AL CLIENTE" → "Esta área proporciona servicios"
- `@Configuration` = Etiqueta "ADMINISTRACIÓN" → "Esta oficina configura políticas"

Cuando llega un cliente (petición SOAP), el sistema sabe exactamente a quién dirigirlo basándose en las etiquetas (anotaciones).

### ⚠️ Puntos Importantes para Recordar

1. **Las anotaciones NO ejecutan código** - son solo metadatos
2. **Los frameworks (como Spring) procesan las anotaciones** en tiempo de ejecución
3. **Simplifican enormemente la configuración** comparado con XML
4. **Están fuertemente tipadas** - el compilador detecta errores
5. **Son extensibles** - puedes crear tus propias anotaciones

---

## ☕ ¿Qué son los Beans en Spring?

### 📝 Concepto Básico

Un **Bean** en Spring es simplemente un objeto que es **creado, configurado y gestionado** por el contenedor de Spring (IoC Container). Es como tener un "asistente personal" que se encarga de crear y mantener todos los objetos que tu aplicación necesita.

### 🏭 Analogía Simple: La Fábrica de Objetos

Imagina que Spring es una **fábrica automatizada**:

```
🏭 Fábrica Spring
├── 📋 Lista de "recetas" (clases con @Component, @Service, etc.)
├── 🤖 Robot constructor (IoC Container)
├── 📦 Almacén de objetos listos (Application Context)
└── 🚚 Sistema de entrega automática (@Autowired)
```

**Proceso:**
1. **Spring escanea** tu código buscando clases marcadas con anotaciones especiales
2. **Crea automáticamente** instancias de esas clases (los beans)
3. **Los almacena** en su "almacén" (Application Context)
4. **Los entrega** cuando otra clase los necesita

### 🎯 ¿Para qué se Utilizan los Beans?

#### 1. **Gestión Automática de Objetos**
```java
// ❌ Sin Spring (manual):
public class ReservationController {
    private ReservationService service;
    private DatabaseRepository repository;
    
    public ReservationController() {
        // Tienes que crear todo manualmente
        this.repository = new DatabaseRepository();
        this.service = new ReservationService(repository);
    }
}

// ✅ Con Spring (automático):
@Controller
public class ReservationController {
    @Autowired
    private ReservationService service;  // Spring lo crea e inyecta automáticamente
    
    // ¡No necesitas constructor ni new!
}
```

#### 2. **Singleton por Defecto (Una Sola Instancia)**
```java
@Service
public class EmailService {
    public void sendEmail(String message) {
        System.out.println("Enviando: " + message);
    }
}

// Spring crea UNA SOLA instancia de EmailService
// Todas las clases que lo necesiten comparten la misma instancia
```

#### 3. **Inyección de Dependencias Automática**
```java
@Service
public class GymReservationService {
    
    private EmailService emailService;        // Dependencia 1
    private DatabaseService databaseService;  // Dependencia 2
    private LoggingService loggingService;    // Dependencia 3
    
    // Constructor injection - Spring inyecta automáticamente todo
    public GymReservationService(EmailService emailService, 
                               DatabaseService databaseService,
                               LoggingService loggingService) {
        this.emailService = emailService;
        this.databaseService = databaseService;
        this.loggingService = loggingService;
    }
    
    public void makeReservation(Reservation reservation) {
        databaseService.save(reservation);           // Usa bean 1
        emailService.sendConfirmation(reservation);  // Usa bean 2  
        loggingService.log("Reserva creada");        // Usa bean 3
    }
}
```

### 🏷️ Tipos de Anotaciones para Crear Beans

#### **Anotaciones de Estereotipo (Stereotype Annotations)**

```java
@Component    // Bean genérico - "Esto es un componente de Spring"
public class GenericComponent {
    // Cualquier lógica
}

@Service      // Bean de lógica de negocio - "Esto contiene reglas de negocio"
public class ReservationService {
    // Lógica para manejar reservas
}

@Repository   // Bean de acceso a datos - "Esto accede a la base de datos"
public class ReservationRepository {
    // Operaciones CRUD con la base de datos
}

@Controller   // Bean de control web - "Esto maneja peticiones web"
public class ReservationController {
    // Maneja peticiones HTTP
}

@RestController // Bean de API REST - "Esto es una API REST"
public class ReservationRestController {
    // Endpoints REST que devuelven JSON
}

@Configuration // Bean de configuración - "Esto configura otros beans"
public class AppConfig {
    // Métodos que crean y configuran otros beans
}
```

#### **Jerarquía de Anotaciones:**
```
@Component (padre)
├── @Service
├── @Repository  
├── @Controller
│   └── @RestController
└── @Configuration
```

**💡 Todas heredan de `@Component`**, por lo que todas crean beans.

### 🔧 Métodos para Crear Beans

#### **Método 1: Anotaciones de Clase (Más Común)**
```java
@Service  // ← Spring automáticamente crea un bean de esta clase
public class EmailService {
    public void sendEmail(String message) {
        System.out.println("Email enviado: " + message);
    }
}
```

#### **Método 2: Métodos @Bean en Clases @Configuration**
```java
@Configuration
public class AppConfig {
    
    @Bean  // ← Este método produce un bean
    public EmailService emailService() {
        EmailService service = new EmailService();
        service.setServerConfig("smtp.gmail.com");
        return service;  // Spring toma este objeto y lo gestiona como bean
    }
    
    @Bean
    public DatabaseConnection databaseConnection() {
        return new DatabaseConnection("jdbc:mysql://localhost:3306/gym");
    }
}
```

### 🔄 Ciclo de Vida de un Bean

```java
@Service
public class ReservationService {
    
    @PostConstruct  // ← Se ejecuta DESPUÉS de crear el bean
    public void initialize() {
        System.out.println("ReservationService inicializado");
        // Configuración inicial, conexiones, etc.
    }
    
    @PreDestroy     // ← Se ejecuta ANTES de destruir el bean
    public void cleanup() {
        System.out.println("ReservationService destruyéndose");
        // Limpieza, cerrar conexiones, etc.
    }
}
```

**Flujo completo:**
```
1. Spring escanea clases
2. Encuentra @Service
3. Crea instancia con new ReservationService()
4. Ejecuta @PostConstruct initialize()
5. Bean listo para usar
6. Aplicación se cierra
7. Ejecuta @PreDestroy cleanup()
8. Destruye el bean
```

### 🎯 Scopes (Alcance) de los Beans

```java
@Service
@Scope("singleton")  // DEFAULT - Una sola instancia para toda la app
public class EmailService { }

@Service  
@Scope("prototype")  // Nueva instancia cada vez que se solicite
public class ReportGenerator { }

@Controller
@Scope("request")    // Una instancia por petición HTTP
public class WebController { }

@Controller
@Scope("session")    // Una instancia por sesión de usuario
public class UserController { }
```

### 🔍 Ejemplo Práctico en Nuestro Proyecto

```java
// 1. GymEndpoint es un bean (por @Endpoint que hereda de @Component)
@Endpoint
public class GymEndpoint {
    
    // 2. Spring inyecta automáticamente otros beans que necesite
    @Autowired
    private ReservationService reservationService;  // Bean automático
    
    @PayloadRoot(namespace = NAMESPACE_URI, localPart = "reservation")
    @ResponsePayload
    public Confirmation createReservation(@RequestPayload Reservation request) {
        // 3. Usa el bean inyectado
        return reservationService.processReservation(request);
    }
}

// 4. Servicio como bean independiente
@Service  // ← Crea automáticamente un bean
public class ReservationService {
    
    @Autowired
    private EmailService emailService;      // Bean dependiente
    
    @Autowired  
    private DatabaseService databaseService; // Otro bean dependiente
    
    public Confirmation processReservation(Reservation reservation) {
        // Lógica usando otros beans
        Confirmation conf = databaseService.saveReservation(reservation);
        emailService.sendConfirmation(conf);
        return conf;
    }
}

// 5. Más beans del ecosistema
@Service
public class EmailService {
    public void sendConfirmation(Confirmation conf) {
        System.out.println("Confirmación enviada: " + conf.getIdReservation());
    }
}

@Repository
public class DatabaseService {
    public Confirmation saveReservation(Reservation reservation) {
        // Simula guardado en BD
        Confirmation conf = new Confirmation();
        // ... lógica ...
        return conf;
    }
}
```

### 🎪 ¿Cómo Spring "Une" Todo Automáticamente?

```java
// Spring hace esto automáticamente al arrancar:

// 1. Escanea y encuentra estas clases:
// - GymEndpoint (tiene @Endpoint)
// - ReservationService (tiene @Service)  
// - EmailService (tiene @Service)
// - DatabaseService (tiene @Repository)

// 2. Crea instancias:
EmailService emailBean = new EmailService();
DatabaseService databaseBean = new DatabaseService();  
ReservationService reservationBean = new ReservationService(emailBean, databaseBean);
GymEndpoint endpointBean = new GymEndpoint(reservationBean);

// 3. Los guarda en su "almacén" (Application Context)
// 4. Los inyecta donde se necesiten (@Autowired)
```

### 🚀 Ventajas de Usar Beans

| Ventaja | Sin Beans | Con Beans |
|---------|-----------|-----------|
| **Creación** | `new MiClase()` manual | Automática por Spring |
| **Dependencias** | `new Dependencia()` manual | `@Autowired` automático |
| **Singleton** | Implementar patrón manualmente | Por defecto |
| **Configuración** | Hardcoded en constructor | Externalizada |
| **Testing** | Difícil de mockear | Fácil inyección de mocks |
| **Mantenimiento** | Cambios en muchos lugares | Cambios centralizados |

### 🧪 Ejemplo de Testing con Beans

```java
@SpringBootTest
public class ReservationServiceTest {
    
    @Autowired
    private ReservationService reservationService;  // Bean real
    
    @MockBean  // ← Spring reemplaza el bean real con un mock
    private EmailService emailService;
    
    @Test
    public void testCreateReservation() {
        // emailService es ahora un mock, no el bean real
        when(emailService.sendConfirmation(any())).thenReturn(true);
        
        // El test usa el servicio real, pero con dependencias mockeadas
        Confirmation result = reservationService.processReservation(new Reservation());
        
        assertNotNull(result);
    }
}
```

### 💡 Conceptos Clave para Recordar

#### ✅ **Un Bean es:**
- Un objeto gestionado por Spring
- Creado automáticamente cuando la aplicación arranca
- Inyectado automáticamente donde se necesite
- Por defecto es Singleton (una sola instancia)

#### ✅ **Los Beans se usan para:**
- Eliminar la creación manual de objetos (`new`)
- Gestionar dependencias automáticamente
- Facilitar el testing (mocks)
- Centralizar la configuración
- Implementar patrones como Singleton sin código extra

#### ✅ **Creación de Beans:**
- `@Component`, `@Service`, `@Repository`, `@Controller` (automático)
- `@Bean` en clases `@Configuration` (manual/personalizado)

#### ✅ **Inyección de Beans:**
- `@Autowired` (automático por tipo)
- Constructor injection (recomendado)
- Field injection (más simple, menos testeable)

### 🎯 En Nuestro Proyecto SOAP

```java
// Este flujo ocurre automáticamente:

@SpringBootApplication  // ← Arranca Spring
public class GymReservationServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(...);  // ← Spring crea todos los beans
    }
}

// Beans creados automáticamente:
// 1. GymEndpoint (por @Endpoint)
// 2. GymReservationWebServiceConfig (por @Configuration) 
// 3. MessageDispatcherServlet (por método @Bean)
// 4. Wsdl11Definition (por método @Bean)

// Resultado:
// ✅ Servicio SOAP funcionando en http://localhost:8080/ws/
// ✅ WSDL disponible en http://localhost:8080/ws/gym-reservation.wsdl
// ✅ Todo configurado y conectado automáticamente
```

---

## 🔧 Componentes Clave del Proyecto

### 1. 📄 **Archivo XSD (gym.xsd)** - El Esquema de Datos

```xml
<!-- Define la estructura de una reserva -->
<xs:complexType name="reservationType">
    <xs:sequence>
        <!-- ID Cliente con patrón: BC-001 o PC-238 -->
        <xs:element name="idClient">
            <xs:simpleType>
                <xs:restriction base="xs:string">
                    <xs:pattern value="(BC|PC)-[0-9]{3}"/>
                </xs:restriction>
            </xs:simpleType>
        </xs:element>
        
        <!-- Actividad (5-255 caracteres) -->
        <xs:element name="activity">
            <xs:simpleType>
                <xs:restriction base="xs:string">
                    <xs:minLength value="5"/>
                    <xs:maxLength value="255"/>
                </xs:restriction>
            </xs:simpleType>
        </xs:element>
        
        <!-- Día de la semana (enumeración) -->
        <xs:element name="dayOfWeek">
            <xs:simpleType>
                <xs:restriction base="xs:string">
                    <xs:enumeration value="Lun"/>
                    <xs:enumeration value="Mar"/>
                    <!-- ... más días ... -->
                </xs:restriction>
            </xs:simpleType>
        </xs:element>
    </xs:sequence>
</xs:complexType>
```

**💡 ¿Para qué sirve?**
- Define la estructura exacta de los datos
- Establece validaciones (patrones, longitudes, valores permitidos)
- Es como el "molde" de los objetos que vamos a intercambiar

### 2. 📄 **Archivo WSDL (gymReservation.wsdl)** - El Contrato del Servicio

```xml
<!-- Define las operaciones disponibles -->
<wsdl:portType name="ReservationPortType">
    <wsdl:operation name="createReservationOperation">
        <wsdl:input message="tns:CreateReservationMessageRequest"/>
        <wsdl:output message="tns:CreateReservationMessageResponse"/>
    </wsdl:operation>
    <wsdl:operation name="getReservationOperation">
        <wsdl:input message="tns:GetReservationMessageRequest"/>
        <wsdl:output message="tns:GetReservationMessageResponse"/>
    </wsdl:operation>
    <wsdl:operation name="cancelReservationOperation">
        <wsdl:input message="tns:CancelReservationMessageRequest"/>
        <wsdl:output message="tns:CancelReservationMessageResponse"/>
    </wsdl:operation>
</wsdl:portType>
```

**💡 ¿Para qué sirve?**
- Es el "contrato" del servicio web
- Define qué operaciones están disponibles
- Especifica qué datos de entrada y salida espera cada operación
- Los clientes pueden generar código automáticamente desde este archivo

---

## 🏷️ Clases Java Principales

### 1. 📄 **GymReservationServiceApplication.java** - Punto de Entrada

```java
@SpringBootApplication  // ← Esta anotación hace toda la magia de Spring Boot
public class GymReservationServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(GymReservationServiceApplication.class, args);
    }
}
```

**🔍 Anotaciones clave:**
- `@SpringBootApplication` = `@Configuration` + `@EnableAutoConfiguration` + `@ComponentScan`

### 2. 📄 **GymReservationWebServiceConfig.java** - Configuración del Servicio

```java
@EnableWs        // ← Habilita funcionalidad de Web Services SOAP
@Configuration   // ← Marca esta clase como fuente de configuración de beans
public class GymReservationWebServiceConfig {

    @Bean  // ← Registra este método como proveedor de un bean
    ServletRegistrationBean<MessageDispatcherServlet> messageDispatcherServlet(
            ApplicationContext applicationContext) {
        MessageDispatcherServlet servlet = new MessageDispatcherServlet();
        servlet.setApplicationContext(applicationContext);
        servlet.setTransformWsdlLocations(true);
        return new ServletRegistrationBean<>(servlet, "/ws/*");  // ← Ruta del servicio
    }
    
    @Bean(name = "gym-reservation")  // ← Nombre del bean (importante para la URL)
    Wsdl11Definition defaultWsdl11Definition() {
        SimpleWsdl11Definition wsdl11Definition = new SimpleWsdl11Definition();
        wsdl11Definition.setWsdl(new ClassPathResource("wsdl/gymReservation.wsdl"));
        return wsdl11Definition;
    }
}
```

**💡 ¿Qué hace esta clase?**
- Configura el servlet que maneja las peticiones SOAP
- Expone el archivo WSDL en `/ws/gym-reservation.wsdl`
- Registra el esquema XSD para validación

### 3. 📄 **GymEndpoint.java** - La Lógica del Servicio

```java
@Endpoint  // ← Marca esta clase como endpoint de Web Service
public class GymEndpoint {
    
    private static final Logger logger = LoggerFactory.getLogger(GymEndpoint.class);
    private static final String NAMESPACE_URI = "http://com.gym";
    
    @PayloadRoot(namespace = NAMESPACE_URI, localPart = "reservation")
    @ResponsePayload
    public Confirmation createReservation(@RequestPayload Reservation request) {
        logger.info("Iniciando creación de reserva");
        
        // Lógica de negocio aquí...
        Confirmation response = new Confirmation();
        ConfirmationType confirmationType = new ConfirmationType();
        
        confirmationType.setIdReservation(123);
        confirmationType.setIdRoom(20);
        confirmationType.setInstructor("Paquito");
        
        response.setConfirmation(confirmationType);
        
        logger.info("Reserva creada exitosamente con ID: {}", 
                   confirmationType.getIdReservation());
        
        return response;
    }
}
```

**🔍 Anotaciones clave del proyecto:**

#### `@Endpoint`
- **Propósito**: Marca la clase como manejador de mensajes SOAP
- **Equivale a**: `@Component` + funcionalidad específica de Web Services
- **Procesada por**: Spring Web Services framework
- **Resultado**: Spring registra automáticamente la clase para procesar peticiones SOAP

#### `@PayloadRoot(namespace = "...", localPart = "...")`
- **Propósito**: Define qué mensaje XML específico maneja cada método
- **namespace**: Identifica el namespace XML del mensaje (como "http://com.gym")
- **localPart**: Nombre del elemento raíz del mensaje XML (como "reservation")
- **Procesada por**: MessageDispatcherServlet de Spring WS
- **Resultado**: Enruta automáticamente peticiones XML al método correcto

#### `@RequestPayload`
- **Propósito**: Convierte automáticamente el XML de entrada en objeto Java
- **Procesada por**: JAXB (Java Architecture for XML Binding)
- **Resultado**: El contenido del `<soap:Body>` se convierte al tipo del parámetro

#### `@ResponsePayload`
- **Propósito**: Convierte automáticamente el objeto Java de retorno en XML
- **Procesada por**: JAXB + Spring WS
- **Resultado**: El objeto retornado se serializa como contenido del `<soap:Body>` de respuesta

**💡 Ejemplo del flujo completo:**

```xml
<!-- Petición SOAP entrante -->
<soap:Body>
    <gym:reservation>  <!-- ← localPart="reservation" -->
        <gym:reservation>
            <gym:idClient>BC-001</gym:idClient>
            <!-- ... más campos ... -->
        </gym:reservation>
    </gym:reservation>
</soap:Body>
```

↓ **Spring procesa las anotaciones** ↓

```java
@PayloadRoot(namespace = "http://com.gym", localPart = "reservation") // ← Coincide!
public Confirmation createReservation(@RequestPayload Reservation request) {
    //     ↑                                    ↑
    // @ResponsePayload (implícito)      @RequestPayload convierte XML → Objeto
    
    // request ya es un objeto Java con los datos del XML
    
    return confirmation; // ← Se convierte automáticamente a XML
}
```

```xml
<!-- Respuesta SOAP generada -->
<soap:Body>
    <gym:confirmation>
        <gym:confirmation>
            <gym:idReservation>123</gym:idReservation>
            <!-- ... más campos ... -->
        </gym:confirmation>
    </gym:confirmation>
</soap:Body>
```

### 4. 📁 **Clases DTO (Data Transfer Objects)**

Estas clases se **generan automáticamente** desde el XSD:

```java
// Ejemplo: ReservationType.java (generada automáticamente)
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "reservationType", propOrder = {
    "idClient",
    "activity", 
    "dayOfWeek",
    "time"
})
public class ReservationType {
    
    @XmlElement(required = true)
    protected String idClient;
    
    @XmlElement(required = true)
    protected String activity;
    
    // ... getters y setters ...
}
```

**💡 ¿Por qué se generan automáticamente?**
- Garantiza que las clases Java coincidan exactamente con el esquema XSD
- Cualquier cambio en el XSD se refleja automáticamente en el código
- Evita errores manuales de codificación

---

## ⚙️ Dependencias Clave (pom.xml)

```xml
<dependencies>
    <!-- Spring Boot Web Services -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web-services</artifactId>
    </dependency>
    
    <!-- WSDL4J para procesar archivos WSDL -->
    <dependency>
        <groupId>wsdl4j</groupId>
        <artifactId>wsdl4j</artifactId>
    </dependency>
    
    <!-- JAXB para binding XML-Java -->
    <dependency>
        <groupId>jakarta.xml.bind</groupId>
        <artifactId>jakarta.xml.bind-api</artifactId>
    </dependency>
    
    <dependency>
        <groupId>org.glassfish.jaxb</groupId>
        <artifactId>jaxb-runtime</artifactId>
    </dependency>
</dependencies>
```

---

## 🚀 Flujo de Ejecución

### 1. **Arranque de la aplicación:**
```
GymReservationServiceApplication.main()
    ↓
Spring Boot escanea las clases con anotaciones
    ↓
@EnableWs activa el soporte para Web Services
    ↓
MessageDispatcherServlet se registra en "/ws/*"
    ↓
WSDL se expone en "/ws/gym-reservation.wsdl"
```

### 2. **Procesamiento de una petición SOAP:**
```
Cliente envía petición SOAP a /ws/
    ↓
MessageDispatcherServlet recibe la petición
    ↓
Spring analiza el XML y busca el @PayloadRoot correspondiente
    ↓
Se ejecuta el método en GymEndpoint
    ↓
Se genera la respuesta y se convierte a XML
    ↓
Cliente recibe la respuesta SOAP
```

---

## 🧪 Probando el Servicio

### 1. **Iniciar la aplicación:**
```bash
mvn spring-boot:run
```

### 2. **Ver el WSDL:**
```
http://localhost:8080/ws/gym-reservation.wsdl
```

### 3. **Ejemplo de petición SOAP:**
```xml
POST /ws/
Content-Type: text/xml; charset=utf-8
SOAPAction: "createReservation"

<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:gym="http://com.gym">
    <soap:Header/>
    <soap:Body>
        <gym:reservation>
            <gym:reservation>
                <gym:idClient>BC-001</gym:idClient>
                <gym:activity>Yoga matutino</gym:activity>
                <gym:dayOfWeek>Lun</gym:dayOfWeek>
                <gym:time>08:00</gym:time>
            </gym:reservation>
        </gym:reservation>
    </soap:Body>
</soap:Envelope>
```

---

## 🎓 Conceptos Clave para Recordar

### ✅ **SOAP es:**
- Un protocolo estándar y robusto
- Basado completamente en XML  
- Ideal para sistemas empresariales
- Requiere contratos bien definidos (WSDL)

### ✅ **Spring Boot facilita SOAP porque:**
- Maneja automáticamente la configuración
- Genera las clases Java desde XSD
- Proporciona anotaciones simples (@Endpoint, @PayloadRoot)
- Incluye servidor web embebido

### ✅ **Cuándo usar SOAP:**
- Sistemas empresariales que requieren contratos estrictos
- Integración con sistemas legacy
- Cuando se necesita soporte robusto para transacciones
- Servicios que requieren alta confiabilidad

### ✅ **Cuándo NO usar SOAP:**
- APIs públicas para aplicaciones web/móviles modernas
- Microservicios ligeros
- Cuando se necesita simplicidad y velocidad de desarrollo

---

## 🔗 URLs Importantes del Proyecto

Una vez que ejecutes `mvn spring-boot:run`:

- **WSDL del servicio:** `http://localhost:8080/ws/gym-reservation.wsdl`
- **Endpoint SOAP:** `http://localhost:8080/ws/`
- **Logs de la aplicación:** `logs/gym-reservation-service.log`

---

## 📚 Para Profundizar (Opcional)

Si en el futuro necesitas trabajar más con SOAP:

1. **Herramientas útiles:**
   - SoapUI (testing de servicios SOAP)
   - Postman (también soporta SOAP)
   - wsimport (generación de clientes Java)

2. **Conceptos avanzados:**
   - WS-Security (seguridad en SOAP)
   - WS-ReliableMessaging (mensajería confiable)
   - MTOM (attachments optimizados)

3. **Alternativas modernas:**
   - GraphQL para APIs flexibles
   - gRPC para comunicación de alto rendimiento
   - REST con OpenAPI para APIs web estándar

---

## 🎯 Conclusión

Este proyecto muestra cómo Spring Boot simplifica enormemente la creación de servicios web SOAP. Aunque REST domina las APIs modernas, SOAP sigue siendo relevante en entornos empresariales donde se requieren contratos estrictos y alta confiabilidad.

**¡Lo importante es entender cuándo usar cada tecnología según el contexto del proyecto!**