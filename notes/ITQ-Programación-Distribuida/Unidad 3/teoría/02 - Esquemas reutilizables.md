# Esquemas reutilizables

### 🎯 Enfoque Progresivo: De Campos Simples a Esquemas Reutilizables

**Es importante entender que OpenAPI permite dos enfoques para definir datos:**

#### **Enfoque 1: Definición Directa (Para empezar)**

```yaml
paths:
  /reservations:
    post:
      # ... elementos anteriores ...
      requestBody:
        required: true                  # Es obligatorio enviar datos
        content:
          application/json:             # Formato de los datos
            schema:                     # Schema definido DIRECTAMENTE aquí
              type: object
              required:
                - idClient
                - activity
                - dayOfWeek
                - time
              properties:
                idClient:
                  type: string
                  pattern: '^[BP]C-[0-9]{3}$'
                  example: "BC-123"
                activity:
                  type: string
                  minLength: 3
                  maxLength: 255
                  example: "Yoga"
                dayOfWeek:
                  type: string
                  enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]
                  example: "Lun"
                time:
                  type: string
                  format: time
                  example: "09:00"
```

#### **Enfoque 2: Referencia a Schema Reutilizable (Recomendado)**

```yaml
paths:
  /reservations:
    post:
      # ... elementos anteriores ...
      requestBody:
        required: true                  # Es obligatorio enviar datos
        content:
          application/json:             # Formato de los datos
            schema:
              $ref: '#/components/schemas/Reservation'  # Referencia al esquema
```

### 🔄 **¿Cuándo usar cada enfoque?**

#### **Usa definición directa cuando:**

- ✅ Estés aprendiendo OpenAPI
- ✅ Tengas campos únicos que no se repiten
- ✅ Prototipes rápidamente

#### **Usa referencias ($ref) cuando:**

- ✅ Los mismos campos se usan en múltiples operaciones
- ✅ Quieras mantener el código organizado
- ✅ Desarrolles APIs en producción

### 📚 **Ejemplo Práctico: Evolución de Campos**

Imagina que empiezas con esto:

```yaml
# ❌ PROBLEMA: Repetición en múltiples lugares
paths:
  /reservations:
    post:
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                idClient:
                  type: string
                  pattern: '^[BP]C-[0-9]{3}$'
                activity:
                  type: string
                  minLength: 5
                # ... más campos ...
    
  /reservations/{id}:
    put:
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                idClient:
                  type: string
                  pattern: '^[BP]C-[0-9]{3}$'    # ¡REPETIDO!
                activity:
                  type: string
                  minLength: 5                    # ¡REPETIDO!
                # ... mismos campos repetidos ...
```

**Entonces lo refactorizas a:**

```yaml
# ✅ SOLUCIÓN: Schema reutilizable
paths:
  /reservations:
    post:
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Reservation'  # Referencia
    
  /reservations/{id}:
    put:
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Reservation'  # Misma referencia

components:
  schemas:
    Reservation:                        # Definido UNA sola vez
      type: object
      required:
        - idClient
        - activity
        - dayOfWeek
        - time
      properties:
        idClient:
          type: string
          pattern: '^[BP]C-[0-9]{3}$'
        activity:
          type: string
          minLength: 5
          maxLength: 255
        # ... resto de campos ...
```

---

## 📊 **Ventajas de Usar Referencias ($ref)**

| Aspecto                | Definición Directa              | Referencia ($ref)          |
| ---------------------- | ------------------------------- | -------------------------- |
| **Mantenimiento**      | ❌ Cambios en múltiples lugares | ✅ Cambio en un solo lugar |
| **Legibilidad**        | ❌ Código repetitivo            | ✅ Código limpio           |
| **Reutilización**      | ❌ Copy/paste manual            | ✅ Automática              |
| **Consistencia**       | ❌ Fácil de desincronizar       | ✅ Siempre consistente     |
| **Tamaño del archivo** | ❌ Más grande                   | ✅ Más compacto            |

---

## 🔍 **Cuándo Convertir Campos a Schemas**

### **Señales de que necesitas crear un schema:**

1. **Repetición**: Usas los mismos campos en 2+ operaciones
2. **Complejidad**: Tienes más de 3-4 campos
3. **Validaciones complejas**: Patrones, rangos, formatos específicos
4. **Evolución**: Planeas agregar más campos en el futuro

### **Proceso de conversión:**

#### **Paso 1: Identifica la repetición**

```yaml
# ¿Usas estos campos en múltiples lugares?
properties:
  idClient:
    type: string
    pattern: '^[BP]C-[0-9]{3}$'
  activity:
    type: string
    minLength: 5
    maxLength: 255
```

#### **Paso 2: Extrae a components/schemas**

```yaml
components:
  schemas:
    Reservation:
      type: object
      required: [idClient, activity, dayOfWeek, time]
      properties:
        idClient:
          type: string
          pattern: '^[BP]C-[0-9]{3}$'
        activity:
          type: string
          minLength: 5
          maxLength: 255
        # ... más campos ...
```

#### **Paso 3: Reemplaza con referencias**

```yaml
# Antes:
schema:
  type: object
  properties:
    idClient: ...
    activity: ...

# Después:
schema:
  $ref: '#/components/schemas/Reservation'
```

### ¿Por qué usar `$ref`?

- **Reutilización**: El mismo esquema se usa en varias operaciones
- **Mantenimiento**: Cambios en un solo lugar
- **Legibilidad**: Evita repetir código
- **Escalabilidad**: Facilita el crecimiento de la API

### ¿Por qué `$ref`?

- **Reutilización**: El mismo esquema se usa en varias operaciones
- **Mantenimiento**: Cambios en un solo lugar
- **Legibilidad**: Evita repetir código
