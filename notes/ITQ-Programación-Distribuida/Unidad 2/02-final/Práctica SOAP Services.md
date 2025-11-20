# Práctica SOAP Services

## Actualización del Servicio

- En la carpeta `wsdl` dentro del proyecto: `/src/main/resources/wsdl` copia la nueva versión del WSDL:
  - [gymReservation.wsdl](artefactos/gymReservation.wsdl)

- En la carpeta `xsd` dentro del proyecto: `/src/main/resources/xsd`, copia la nueva versión del XSD:
  - [gym.xsd](artefactos/gym.xsd)

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

- Genera las clases asociadas a los esquemas mediante:
  - Menú contextual del proyecto -> `Run As` -> `Maven Install`

- Verifica que se crearon los objetos dentro de la ruta indicada en el pom (`/target/generated-sources/jaxb`) y dentro del paquete indicado (`com.gym.reservation.dto`).

- Explora el contenido del paquete.

- Comenta el plugin dentro del pom.

- Arrastra las clases `com.gym.reservation.dto` hacia el paquete raíz del proyecto.

- Dentro del paquete `com.gym.reservation.service`, abre la clase GymEndpoint.

- Actualiza el método público createReservation:

```java
    @PayloadRoot(namespace = NAMESPACE_URI, localPart = "reservation")
    @ResponsePayload
    public Confirmation createReservation(@RequestPayload Reservation request) {
        Confirmation response = new Confirmation ();
        ConfirmationType confirmationType = new ConfirmationType ();
        
        confirmationType.setIdReservation(123);
        confirmationType.setIdRoom(20);
        confirmationType.setInstructor("Paquito");

        response.setConfirmation(confirmationType);
        
        return response;
    }
```

- Corrige los errores que se presentan en la clase realizando la importación de las dependencias.

```java
import org.springframework.ws.server.endpoint.annotation.Endpoint;
import org.springframework.ws.server.endpoint.annotation.PayloadRoot;
import org.springframework.ws.server.endpoint.annotation.RequestPayload;
import org.springframework.ws.server.endpoint.annotation.ResponsePayload;

import com.gym.reservation.dto.Confirmation;
import com.gym.reservation.dto.ConfirmationType;
import com.gym.reservation.dto.Reservation;
```

- Dentro del paquete `com.gym.reservation.service`, abre la clase `GymReservationWebServiceConfig`.

- Actualizar los siguientes `beans`.

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
    XsdSchema gymSchema() {
        return new SimpleXsdSchema(new ClassPathResource("xsd/gym.xsd"));
    }
```

- Ejecuta: Menú contextual del proyecto -> `Run As` -> `Maven Install`.

- Ejecuta: Menú contextual del proyecto -> `Run As` -> `Spring Boot App`.

- Para verificar que el servicio está expuesto, ingresar la url en un navegador:

> <http://localhost:8080/ws/gym-reservation.wsdl>

- Deberá visualizarse el contrato es decir, el contenido de `gymReservation.wsdl`.

- Dentro del file system, ubica la carpeta `/opt/soapUI/`.

- Actualiza los siguientes archivos:

  - `gymReservation.wsdl`
  - `gym.xsd`

## Prueba del Servicio

- Dentro de SoapUI:
  - Crea un nuevo proyecto SOAP: `File` -> `New SOAP Project`
  - Asigna los valores siguientes:
    - Project Name: `gymService`
    - Initial WSDL: Navegar hacia la ruta de `gymReservation.wsdl` y seleccionarlo.
  - Al expandir el árbol del proyecto, se deberá ver el binding `ReservationBinding` y dentro de él, las operaciones `cancelReservationOperation`, `createReservationOperation` y `getReservationOperation`.
  - Dentro de cada operación, se encuentra un request nombrado `Request 1`. Este valor puede ser cambiado, pero no es necesario para fines prácticos.

- Probar la operación `createReservatioOperation`:
  - Hacer doble clic en `Request 1` de la operación `createReservationOperation`.
  - En la caja de URL debe mostrarse el valor correspondiente a la etiqueta _soap:address location_ del contrato (`gymReservation.wsdl`):
    > http://localhost:8080/ws/gym-reservation

    - Extracto gymReservation.wsdl.

    ```xml
    <wsdl:service name="GymReservationService">
        <wsdl:port name="ReservationPort" binding="tns:ReservationBinding">
            <soap:address location="http://localhost:8080/ws/gym-reservation"/>
        </wsdl:port>
    </wsdl:service>
    ```

  - Inserta valores para cada elemento del request.
  - Ejecuta la solicitud haciendo clic en el botón `submit` de la ventana de request.
  - Verifica la respuesta recibida. Se deberá mostrar una estructura de tipo confirmation con los datos dummy que se indicaron en el método createReservation de la clase GymEndpoint.

    ```soap
    <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ns2:confirmation xmlns:ns2="http://com.gym">
            <ns2:confirmation>
                <ns2:idReservation>123</ns2:idReservation>
                <ns2:idRoom>20</ns2:idRoom>
                <ns2:instructor>Paquito</ns2:instructor>
            </ns2:confirmation>
        </ns2:confirmation>
    </SOAP-ENV:Body>
    </SOAP-ENV:Envelope>
    ```

## Prueba del Servicio (operación cancelReservation)

- Probar la operación `cancelConfirmation`:
  - Hacer doble clic en `Request 1` de la operación `cancelReservationOperation`.
  - En la caja de URL debe mostrarse el valor correspondiente a la etiqueta _soap:address location_ del contrato (`gymReservation.wsdl`):
    > localhost:8080/ws/gym-reservation.wsdl

  - Inserta valores para cada elemento del request.
  - Ejecuta la solicitud haciendo clic en el botón `submit` de la ventana de request.
  - Verifica la respuesta recibida. No se muestra ningún valor en SoapUI, sin embargo, en la bitácora del servicio (consola de STS), se puede ver el siguiente mensaje de error que se debe a que no existe un método en la clase GymEndpoint que soporte la funcionalidad de consulta de reservaciones:

    ```bash
    No endpoint mapping found for [SaajSoapMessage {http://com.gym}cancelReservation]
    ```

  - Para corregir el error, debe implementarse el método correspondiente a la solicitud de cancelación de una reservación:

    ```java
        @PayloadRoot(namespace = NAMESPACE_URI, localPart = "cancelReservation")
        @ResponsePayload
        public CancelConfirmation cancelReservation(@RequestPayload CancelReservation request) {
            CancelConfirmation response = new CancelConfirmation ();
            response.setIdReservation(request.getIdReservation());
            return response;
        }
    ```

  - Ejecuta nuevamente la prueba de la operación cancelConfirmation. Se puede verificar que retorna los datos esperados.

## Prueba del Servicio (operación getReservationOperation)

- Probar la operación `getReservationOperation`:
  - Hacer doble clic en `Request 1` de la operación `getReservationOperation`.
  - En la caja de URL debe mostrarse el valor correspondiente a la etiqueta _soap:address location_ del contrato (`gymReservation.wsdl`):
    > localhost:8080/ws/gym-reservation.wsdl

  - Inserta valores para cada elemento del request.
  - Ejecuta la solicitud haciendo clic en el botón  de la ventana de request.
  - Verifica la respuesta recibida. No se muestra ningún valor en SoapUI, sin embargo, en la bitácora del servicio (consola de STS), se puede ver el siguiente mensaje de error que se debe a que no existe un método en la clase GymEndpoint que soporte la funcionalidad de consulta de reservaciones:

    ```bash
    No endpoint mapping found for [SaajSoapMessage {http://com.gym}searchCriteria]
    ```

    - Para corregir el error, debe implementarse el método correspondiente a la solicitud de consulta de reservaciones. Realizar esta adecuación y volver a probar la operación.

## Referencias

- <https://docs.spring.io/spring-ws/site/reference/html/server.html#server-automatic-wsdl-exposure>

- <https://docs.spring.io/spring-ws/site/reference/html/why-contract-first.html>

- <https://docs.spring.io/spring-ws/site/reference/html/tutorial.html>
