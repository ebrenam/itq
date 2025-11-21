# Convención de Nombres de Dominio

La principal razón es que la sintaxis com.empresa.proyecto es una forma de invertir el nombre de un dominio web (empresa.com).

Esto se hace por dos motivos principales:

1. **Garantizar la Unicidad:** Al basar el namespace en un dominio de Internet que posees, reduces enormemente la posibilidad de que dos organizaciones diferentes usen el mismo nombre. Por ejemplo, si una empresa llamada "Acme" y otra llamada "XYZ" crean un servicio web llamado "Facturacion", sus namespaces serían únicos:

   - http://www.acme.com/servicios/facturacion
   - http://www.xyz.com/servicios/facturacion

2. **Organización y Estructura:** Esta convención crea una estructura jerárquica que ayuda a organizar los servicios. Si una empresa tiene varios proyectos, puede extender el namespace de forma lógica:

   - com.empresa.compras
   - com.empresa.ventas
   - com.empresa.logistica

## Analogía con Java

Esta práctica se originó y popularizó en el ecosistema de Java, donde los nombres de los paquetes de clases siguen la misma convención de dominio invertido para evitar colisiones de nombres. Al estar estrechamente relacionados con los servicios web basados en Java (como los que se crean con JAX-WS), esta convención se adoptó ampliamente para los target namespaces en WSDL.

Aunque no es una regla estricta (puedes usar cualquier cadena única), el uso de com (o org, edu, etc.) seguido de un dominio invertido es una práctica recomendada y un estándar de facto para garantizar la interoperabilidad y la unicidad en el vasto y descentralizado mundo de los servicios web.

