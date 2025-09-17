
[[Web Services]]

# ¿Qué son los servicios SOAP?

**SOAP** (Simple Object Access Protocol) es un protocolo estándar para el intercambio de información estructurada entre aplicaciones a través de una red, normalmente usando HTTP o SMTP.

## Características principales

- **Basado en XML:** Los mensajes SOAP se escriben en XML, lo que permite la interoperabilidad entre diferentes plataformas y lenguajes.
- **Estrictamente estructurado:** Define reglas claras para el formato de los mensajes.
- **Transporte independiente:** Aunque comúnmente usa HTTP, puede funcionar sobre otros protocolos como SMTP.
- **Contratos (WSDL):** Los servicios SOAP suelen describirse mediante archivos WSDL (Web Services Description Language), que especifican cómo interactuar con el servicio.
- **Soporta extensiones:** Como seguridad (WS-Security), transacciones, y manejo de errores.

## Ejemplo de mensaje SOAP

```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:gs="http://spring.io/guides/gs-producing-web-service">
   <soapenv:Header/>
   <soapenv:Body>
      <gs:getCountryRequest>
         <gs:name>Spain</gs:name>
      </gs:getCountryRequest>
   </soapenv:Body>
</soapenv:Envelope>
```

## ¿Para qué se usan?

- Integración entre sistemas empresariales (ERP, CRM, bancos, etc.).
- Comunicación entre aplicaciones heterogéneas.
- Servicios web que requieren contratos estrictos y seguridad avanzada.

**Resumen:**  
Un servicio SOAP es un servicio web que usa el protocolo SOAP para enviar y recibir mensajes XML estructurados, facilitando la interoperabilidad y la integración entre sistemas.

[[Web Services]]