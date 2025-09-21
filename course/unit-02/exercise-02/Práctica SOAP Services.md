
## Actualización del Servicio

- En la carpeta `wsdl` dentro del proyecto: `/src/main/resources/wsdl` copia la nueva versión del WSDL:
	- [gymReservation.wsdl](artifacts/gymReservation.wsdl.md)

- En la carpeta `xsd` dentro del proyecto: `/src/main/resources/xsd`, copia la nueva versión del XSD:
	- [gym.xsd](artifacts/gym.xsd.md)

- Dentro del pom.xml, en la sección de plugins, activa el plugin:

```xml
			<!--Plugin para java 21-->
			<plugin>
               <groupId>org.codehaus.mojo</groupId>
               <artifactId>jaxb2-maven-plugin</artifactId>
               <version>3.1.0</version>
               <executions>
                   <execution>
                       <goals>
                           <goal>xjc</goal>
                       </goals>
                       <configuration>
                           <sources>
                               <source>${project.basedir}/src/main/resources/xsd</source>
                           </sources>
                           <outputDirectory>${project.build.directory}/generated-sources/jaxb</outputDirectory>
                           <packageName>com.gym.reservation.dto</packageName>
                           <clearOutputDir>true</clearOutputDir>
                       </configuration>
                   </execution>
               </executions>
           </plugin>
```
  
- Genera las clases asociadas a los nuevos esquemas mediante:
	- Menú contextual del proyecto -> `Run As` -> `Maven Install`

- Verifica que se crearon los objetos dentro de la ruta indicada en el pom (`/target/generated-sources/jaxb`) y dentro del paquete indicado (`com.gym.reservation.dto`).

- Explora el contenido del paquete.

- Comenta el plugin dentro del pom.

- Arrastra las clases `com.gym.reservation.dto` hacia el paquete raíz del proyecto.

- Crea el paquete `com.gym.reservation.service`.

- Crea la clase `GymEndpoint`.

- Agrega la anotación `@Endpoint` antes de la sentencia declaratoria de la clase.

```java
@Endpoint
public class GymEndpoint {
```

- Dentro de la clase GymEndpoint, crear la constante de clase (este valor es el mismo que el namespace de los artefactos xml):

```java
	private static final String NAMESPACE_URI = "http://com.gym";
```

	- Extracto de `gymReservation.wsdl`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<wsdl:definitions xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:http="http://schemas.xmlsoap.org/wsdl/http/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:mime="http://schemas.xmlsoap.org/wsdl/mime/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://com.gym" targetNamespace="http://com.gym">
	<wsdl:types>
		<xs:schema targetNamespace="http://com.gym" elementFormDefault="qualified">
```

	- Extracto de `gym.xsd`.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified" xmlns:tns="http://com.gym" targetNamespace="http://com.gym">
```

- Crear el método público createReservation:

```java
	@PayloadRoot(namespace = NAMESPACE_URI, localPart = "reservation")
	@ResponsePayload
	public Confirmation createReservation(@RequestPayload Reservation request) {
		Confirmation response = new Confirmation ();
		
		response.setIdReservation(123);
		response.setIdRoom(20);
		response.setInstructor("Paquito");
		
		return response;		
	}
```

> **NOTA:** `localPart` contiene el nombre del elemento raíz que se indica como `part` en el mensaje request del método de creación de reservación en el WSDL.

- Corrige los errores que se presentan en la clase realizando la importación de las dependencias.

```java
import org.springframework.ws.server.endpoint.annotation.Endpoint;
import org.springframework.ws.server.endpoint.annotation.PayloadRoot;
import org.springframework.ws.server.endpoint.annotation.RequestPayload;
import org.springframework.ws.server.endpoint.annotation.ResponsePayload;

import com.gym.reservation.dto.Confirmation;
import com.gym.reservation.dto.Reservation;
```

- Dentro del paquete `com.gym.reservation.service`, crear la clase `GymReservationWebServiceConfig`.

- Etiqueta la clase con `@EnableWs` y `@Configuration`:

```java
@EnableWs //Habilita a la clase con la funcionalidad para crear un WS SOAP
@Configuration //Habilita a la clase con la funcionalidad para procesar Beans
public class GymReservationWebServiceConfig {
```

- Agrega los siguientes `beans`.

```java
	@Bean
	ServletRegistrationBean<MessageDispatcherServlet> messageDispatcherServlet(ApplicationContext applicationContext) {
		MessageDispatcherServlet servlet = new MessageDispatcherServlet();
		servlet.setApplicationContext(applicationContext);
		servlet.setTransformWsdlLocations(true);
		return new ServletRegistrationBean<>(servlet, "/ws/*");
	}
	
	@Bean(name = "gym-reservation")
	Wsdl11Definition defaultWsdl11Definition() {
		SimpleWsdl11Definition wsdl11Definition = new SimpleWsdl11Definition();
		wsdl11Definition.setWsdl(new ClassPathResource("wsdl/gymReservation.wsdl"));
		return wsdl11Definition;
	}
	
	@Bean (name = "gym")
	XsdSchema tallerSchema() {
		return new SimpleXsdSchema(new ClassPathResource("xsd/gym.xsd"));
	}
```

- Corrige los errores que se presentan en la clase realizando la importación de las dependencias.
	- **Importante**: La referencia para clase `ApplicationContext` debe ser `import org.springframework.context.ApplicationContext;`.

```java
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.ws.config.annotation.EnableWs;
import org.springframework.ws.transport.http.MessageDispatcherServlet;
import org.springframework.ws.wsdl.wsdl11.SimpleWsdl11Definition;
import org.springframework.ws.wsdl.wsdl11.Wsdl11Definition;
import org.springframework.xml.xsd.SimpleXsdSchema;
import org.springframework.xml.xsd.XsdSchema;
```

- Ejecuta: Menú contextual del proyecto -> `Run As` -> `Maven Install`.

- Ejecuta: Menú contextual del proyecto -> `Run As` -> `Spring Boot App`.

- Para verificar que el servicio está expuesto, ingresar la url en un navegador:

> <http://localhost:8080/ws/gym-reservation.wsdl>

- La URL del servicio estará formada por:

    - El protocolo -> **http://**
    - El par IP/PTO o dominio -> **localhost:8080**
    - El path indicado en el bean ServletRegistrationBean -> **/ws/**
    - El nombre del bean asignado al Wsdl11Definition -> **gym-reservation**

> **NOTA OPCIONAL:** Si en el equipo está ocupado el puerto `8080` debido a la ejecución de otro software, se debe indicar el puerto a utilizar agregando la siguiente línea en el archivo `application.properties`, ubicado en la carpeta `/src/main/resources`:

```properties
server.port=8081
```


- Deberá visualizarse el contrato es decir, el contenido de `gymReservation.wsdl`.

- Dentro del file system, crea la carpeta `/opt/soapUI/`.

- Copiar los siguientes archivos en la carpeta recién creada:

    - `gymReservation.wsdl`
    - `gym.xsd`

## Prueba del Servicio

Dentro de SoapUI:

- Crea un nuevo proyecto SOAP: `File` -> `New SOAP Project`

- Asigna los valores siguientes:
   - Project Name: `gymService`
   - Initial WSDL: Navegar hacia la ruta de `gymReservation.wsdl` y seleccionarlo.

- Al expandir el árbol del proyecto, se deberá ver el binding `ReservationBinding` y dentro de él, las operaciones `createReservationOperation` y `getReservationOperation`.

- Dentro de cada operación, se encuentra un request nombrado `Request 1`. Este valor puede ser cambiado, pero no es necesario para fines prácticos.

- Hacer doble clic en `Request 1` de la operación `createReservationOperation`.
  
- En la caja de URL debe mostrarse el valor correspondiente a la etiqueta _soap:address location_ del contrato (`gymReservation.wsdl`):

```xml
<wsdl:service name="GymReservationService">
	<wsdl:port name="ReservationPort" binding="tns:ReservationBinding">
		<soap:address location="http://localhost:8080/ws/gym-reservation"/>
	</wsdl:port>
</wsdl:service>
```

> http://localhost:8080/ws/gym-reservation

- Insertar valores para cada elemento del request.

- Ejecutar la solicitud haciendo clic en el botón `submit` de la ventana de request.

- Verificar la respuesta recibida.

## Referencias

- <https://docs.spring.io/spring-ws/site/reference/html/server.html#server-automatic-wsdl-exposure>

- <https://docs.spring.io/spring-ws/site/reference/html/why-contract-first.html>

- <https://docs.spring.io/spring-ws/site/reference/html/tutorial.html>
