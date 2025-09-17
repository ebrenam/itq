
## Construcción de un servicio Web SOAP a partir de un contrato dado

El ejercicio supone la creación de un servicio para la gestión de reserva de `clases/actividades` dentro de un gimnasio. El ejemplo puede ser utilizado para construir otro negocio, para lo cual, los nombres (**proyecto**, **clases**, **paquetes**, **métodos**), los **esquemas**, **contratos** y **datos derivados** deberán ajustarse a los requerimientos del proyecto que se desarrolle.

## Creación del Servicio

1. Crear un proyecto `Spring Boot` con las siguientes características:

> Se puede utilizar Spring Tool Suite o <https://start.spring.io/>

| Campo        | Valor                                                                                                                            |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| Project      | Maven                                                                                                                            |
| Language     | Java                                                                                                                             |
| Spring Boot  | 3.5.5                                                                                                                            |
| Group        | com.gym.reservation                                                                                                              |
| Artifact     | gym-reservation-service                                                                                                          |
| Version      | 1.0                                                                                                                              |
| Name         | gym-reservation-service                                                                                                          |
| Description  | Contiene la funcionalidad de gestión de reservaciones de clases y/o actividades dentro de un gimnasio por parte de los clientes. |
| Package      | com.gym.reservation                                                                                                              |
| Packing      | Jar                                                                                                                              |
| Java         | 21                                                                                                                               |
| Dependencies | Spring Web, Spring Web Services                                                                                                  |

2. Crear la carpeta `wsdl` dentro del proyecto: _/src/main/resources/wsdl_

3. Copiar el WSDL correspondiente al proyecto dentro de la carpeta recién creada:
	- [[gymReservation.wsdl]] ![wsdl](../SOAP/clases/gymReservation.wsdl)

4. Crear la carpeta `xsd` dentro del proyecto: _/src/main/resources/xsd_ y copia el XSD correspondiente:
	- [[gym.xsd]] ![xsd](../SOAP/clases/gym.xsd)

5. Agregar las siguientes dependencias de forma manual en el `pom.xml` (En el caso de la dependencia de jaxb podría ser necesario cambiar la versión de manera que sea compatible con la versión de Springboot):

```xml
		<dependency>
			<groupId>wsdl4j</groupId>
			<artifactId>wsdl4j</artifactId>
		</dependency>

		<dependency>
		    <groupId>jakarta.xml.bind</groupId>
		    <artifactId>jakarta.xml.bind-api</artifactId>
		    <version>3.0.1</version>
		</dependency>

		<dependency>
		    <groupId>org.glassfish.jaxb</groupId>
		    <artifactId>jaxb-runtime</artifactId>
		    <version>3.0.1</version>
		</dependency>
```  

6. Actualizar el proyecto con las dependencias agregadas:

   - Guardar el pom.xml. 
   - Actualizar el proyecto Maven: En el menú contextual del proyecto, seleccionar _Maven_ -> _Update Project._

7. Dentro del pom.xml, en la sección de plugins, agregar el plugin que corresponda, según la versión de java:

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
  
8. Genera las clases asociadas a los esquemas mediante:

   - Menú contextual del proyecto -> Run As -> Maven Install

8. Verificar que se crearon los objetos dentro de la ruta indicada en el pom (/target/generated-sources/jaxb) y dentro del paquete indicado (_com.gym.reservation.dto_)

9. Explora el contenido del paquete.

10. Comenta el plugin dentro del pom.

11. Arrastrar las clases _com.gym.reservation.dto_ hacia el paquete raíz del proyecto.

12. Crear el paquete _com.gym.reservation.service_

13. Crear la clase _GymEndpoint_

14. Agrega la anotación _@Endpoint_ antes de la sentencia declaratoria de la clase.

```java
@Endpoint
```

15. Dentro de la clase GymEndpoint, crear la constante de clase (este valor es el mismo que el namespace de los artefactos xml):

```java
	private static final String NAMESPACE_URI = "http://com.gym";
```


17. Crear el método público createReservation:

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

> **NOTA:** localPart contiene el nombre del elemento raíz que se indica como part en el mensaje request del método de creación de reservación en el WSDL.

18. Dentro del paquete _com.gym.reservation.service_, crear la clase _GymReservationWebServiceConfig_

19. Etiqueta la clase con:

```java
@EnableWs //Habilita a la clase con la funcionalidad para crear un WS SOAP
@Configuration //Habilita a la clase con la funcionalidad para procesar Beans
```

20. Agregar los siguientes beans

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

22. Ejecuta: Menú contextual del proyecto -> Run As -> Maven Install

23. Ejecuta: Menú contextual del proyecto -> Run As -> Spring Boot App

24. Para verificar que el servicio está expuesto, ingresar la url en un navegador:

> http://localhost:8080/ws/gym-reservation.wsdl

21. La URL del servicio estará formada por:

    - El protocolo -> **http://**
    - El par IP/PTO o dominio -> **localhost:8080**
    - El path indicado en el bean ServletRegistrationBean -> **/ws/**
    - El nombre del bean asignado al Wsdl11Definition -> **gym-reservation**

> **NOTA OPCIONAL:** Si en el equipo está ocupado el puerto 8080 debido a la ejecución de otro software, cambiar el puerto agregando la siguiente  línea en el archivo _application.properties_, ubicado en la carpeta _/src/main/resources_:

server.port=8081 🡨 Indicar el Puerto disponible que será usado


25. Deberá visualizarse el contrato es decir, el contenido de _gymReservation.wsdl_

26. Dentro del file system, crear la carpeta /opt/soapUI/

27. Copiar los siguientes archivos en la carpeta recién creada:

    - _gymReservation.wsdl_
    - _gym.xsd_

## Prueba del Servicio

Dentro de SoapUI:

1. Crear un nuevo proyecto SOAP: _File_ -> _New SOAP Project_

2. Asignar los valores siguientes:
   - Project Name: _gymService_
   - Initial WSDL: Navegar hacia la ruta de _gymReservation.wsdl_ y seleccionarlo.

3. Al expandir el árbol del proyecto, se deberá ver el binding _ReservationBinding_ y dentro de él, las operaciones c_reateReservationOperation_ y g_etReservationOperation_.

4. Dentro de cada operación, se encuentra un request nombrado _Request 1_. Este valor puede ser cambiado, pero no es necesario para fines prácticos.

5. Hacer doble clic en _Request 1_ de la operación c_reateReservationOperation_
  
6. En la caja de URL debe mostrarse el valor correspondiente a la etiqueta _soap:address location_ del contrato (_gymReservation.wsdl)_:

	> http://localhost:8080/ws/autos.wsdl

7. Insertar valores para cada elemento del request.

8. Ejecutar la solicitud haciendo clic en el botón   de la ventana de request.

9. Verificar la respuesta recibida.

## Referencias

- <https://docs.spring.io/spring-ws/site/reference/html/server.html#server-automatic-wsdl-exposure>

- <https://docs.spring.io/spring-ws/site/reference/html/why-contract-first.html>

- <https://docs.spring.io/spring-ws/site/reference/html/tutorial.html>