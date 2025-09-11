[[Spring Starter Project]]

El estándar de codificación de Oracle para Java se enfoca en convenciones de nomenclatura (como camelCase para métodos y PascalCase para clases), formato (sangría de 4 espacios, 120 caracteres por línea) y seguridad (a través del estándar SEI CERT para Java), buscando un código eficiente, legible y mantenible. Es un documento oficial y de larga data que establece pautas para el desarrollo de aplicaciones Java.

## Convenciones de nomenclatura

- Clases e Interfaces:  
    Deben usar PascalCase (primera letra mayúscula, como MiClase) y ser sustantivos. 

- Métodos:  
    Deben usar camelCase (primera letra minúscula, como miMetodo()) y ser verbos en forma imperativa. 

- Variables:  
    Deben usar camelCase, ser breves, significativas y evitar nombres de una sola letra (excepto en bucles cortos). 

- Constantes:  
    Deben estar en mayúsculas y separadas por guiones bajos (SCREAMING_SNAKE_CASE), como MAX_WIDTH. 

## Formato del código

- Sangría: Se recomienda una sangría básica de 4 espacios.

- Longitud de línea: Se sugiere no superar los 120 caracteres, intentando mantenerla por debajo de 110.

- Ajuste de línea: Cuando una línea es muy larga, se debe ajustar en puntos lógicos, con una sangría de 8 espacios para las líneas continuadas.

- Estilo de llaves: Se debe usar el estilo K&R (estilo egipcio).

    ```c
    if (x < 0) {
        printf("El número es negativo.\n");
        x = 0;
    }
    ```

- Comentarios: Es importante añadir el comentario // Fallthrough cuando una cláusula case no contiene una declaración break para indicar que es intencional.
	
    ```c
    // Ejemplo de código que agrupa casos de vocales
    char caracter = 'e';

    switch (caracter) {
        case 'a':
        case 'e':
        case 'i':
        case 'o':
        case 'u':
            // No hay 'break' en los primeros 4 casos.
            // La ejecución continuará hasta encontrar un 'break'.
            // Añadir el comentario aquí no es estrictamente necesario,
            // ya que los casos están vacíos y el agrupamiento es evidente.
            printf("El caracter es una vocal minúscula.\n");
            break; // Se detiene aquí para los 5 casos de vocales.
        
        case 'k':
            printf("Se encontró el caso 'k'.\n");
            // ¡OJO! Aquí omitimos 'break' intencionadamente.
            // Fallthrough
        
        case 'l':
            printf("Este código se ejecuta para 'k' y 'l'.\n");
            break;
            
        default:
            printf("El caracter no es una vocal ni 'k' ni 'l'.\n");
            break;
    }
    ```

## Seguridad y Mantenibilidad

- Estándar SEI CERT para Java: Oracle colabora con el Software Engineering Institute (SEI) para publicar guías de codificación segura que abordan la creación de código confiable, robusto, eficiente y seguro.

## Por qué seguir estas convenciones

- Facilitan la lectura y el análisis:  
    Un código bien escrito es más fácil de entender para otros desarrolladores y para el propio equipo.

- Mejoran la mantenibilidad:  
    Las convenciones reducen la probabilidad de errores y facilitan la corrección y modificación del código.

- Promueven la consistencia:  
    Establecen un estilo uniforme en todo el código, lo que contribuye a un entorno de desarrollo más organizado.

## Referencias

[[Referencias de estándar de codificación de Java]]

[[Spring Starter Project]]
