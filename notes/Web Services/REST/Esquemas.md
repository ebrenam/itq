# 📊 Tablas de Esquemas - Datos de Entrada para OpenAPI Specification

## 🎯 Objetivo

Entender la estructura de datos que define cada esquema del contrato OpenAPI, facilitando la comprensión de qué información maneja la API.

---

## 📝 Esquema: Reservation

**Propósito:** Datos necesarios para crear o actualizar completamente una reserva

|Campo|Tipo|Obligatorio|Validaciones|Descripción|Ejemplo|
|---|---|---|---|---|---|
|`idClient`|string|✅ Sí|Pattern: `^[BP]C-[0-9]{3}$`|Identificador único del cliente|`"BC-123"`|
|`activity`|string|✅ Sí|Min: 5 chars, Max: 255 chars|Nombre de la actividad del gimnasio|`"Yoga"`|
|`dayOfWeek`|string|✅ Sí|Enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]|Día de la semana para la reserva|`"Lun"`|
|`time`|string|✅ Sí|Format: time (HH:MM)|Hora de inicio de la actividad|`"09:00"`|

**Ejemplo JSON:**

```json
{
  "idClient": "BC-123",
  "activity": "Yoga",
  "dayOfWeek": "Lun",
  "time": "09:00"
}
```

---

## 🔧 Esquema: ReservationPatch

**Propósito:** Datos para actualización parcial - solo los campos que se quieren modificar

|Campo|Tipo|Obligatorio|Validaciones|Descripción|Ejemplo|
|---|---|---|---|---|---|
|`idClient`|string|❌ No|Pattern: `^[BP]C-[0-9]{3}$`|Nuevo identificador del cliente|`"PC-456"`|
|`activity`|string|❌ No|Min: 5 chars, Max: 255 chars|Nueva actividad|`"Pilates"`|
|`dayOfWeek`|string|❌ No|Enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]|Nuevo día|`"Mar"`|
|`time`|string|❌ No|Format: time (HH:MM)|Nueva hora|`"10:30"`|

**Características especiales:**

- ✅ `additionalProperties: false` - No acepta campos adicionales
- ❌ Todos los campos son opcionales
- 📝 Solo se actualizan los campos enviados

**Ejemplo JSON:**

```json
{
  "activity": "Zumba",
  "time": "11:00"
}
```

---

## ✅ Esquema: Confirmation

**Propósito:** Respuesta del servidor al crear/actualizar una reserva exitosamente

|Campo|Tipo|Obligatorio|Validaciones|Descripción|Ejemplo|
|---|---|---|---|---|---|
|`idReservation`|integer|✅ Sí|Format: int32|ID único generado por el sistema|`12345`|
|`idRoom`|integer|✅ Sí|Min: 1, Max: 20, Format: int32|Sala asignada para la actividad|`5`|
|`instructor`|string|❌ No|Max: 255 chars, nullable|Instructor asignado (puede ser null)|`"María García"`|
|`discount`|number|❌ No|Min: 0, Max: 999.99, multipleOf: 0.01, nullable|Descuento aplicado en porcentaje|`10.50`|

**Características especiales:**

- 🆔 `idReservation` es generado automáticamente por el servidor
- 🏠 `idRoom` representa las salas disponibles (1-20)
- 💰 `discount` usa incrementos de centavos (0.01)

**Ejemplo JSON:**

```json
{
  "idReservation": 12345,
  "idRoom": 5,
  "instructor": "María García",
  "discount": 10.50
}
```

---

## 📋 Esquema: ConfirmationList

**Propósito:** Lista de confirmaciones devuelta en búsquedas

|Campo|Tipo|Obligatorio|Validaciones|Descripción|Ejemplo|
|---|---|---|---|---|---|
|`confirmations`|array|❌ No|Items: Confirmation|Lista de reservas encontradas|`[{...}, {...}]`|
|`total`|integer|❌ No|-|Número total de reservas|`2`|

**Estructura del array:**

- 📦 Cada elemento es un objeto `Confirmation`
- 🔢 `total` indica cuántas reservas se encontraron

**Ejemplo JSON:**

- 
- 
- 
- 

---

## 🚫 Esquema: CancelConfirmation

**Propósito:** Confirmación de cancelación de una reserva

|Campo|Tipo|Obligatorio|Validaciones|Descripción|Ejemplo|
|---|---|---|---|---|---|
|`idReservation`|integer|✅ Sí|Format: int32|ID de la reserva cancelada|`12345`|
|`status`|string|✅ Sí|Enum: [cancelled, failed]|Estado del proceso de cancelación|`"cancelled"`|
|`message`|string|❌ No|-|Mensaje descriptivo del resultado|`"Reserva cancelada exitosamente"`|
|`cancelledAt`|string|❌ No|Format: date-time (ISO 8601)|Timestamp de cuando se canceló|`"2024-01-15T10:30:00Z"`|

**Estados posibles:**

- ✅ `cancelled`: Cancelación exitosa
- ❌ `failed`: Error en la cancelación

**Ejemplo JSON:**

- 
- 
- 
- 

---

## ⚠️ Esquema: Error

**Propósito:** Respuesta estándar para errores de la API

|Campo|Tipo|Obligatorio|Validaciones|Descripción|Ejemplo|
|---|---|---|---|---|---|
|`code`|string|✅ Sí|-|Código de error para identificación programática|`"INVALID_CLIENT_ID"`|
|`message`|string|✅ Sí|-|Mensaje legible para humanos|`"El ID del cliente debe seguir el formato BC-XXX o PC-XXX"`|
|`details`|object|❌ No|additionalProperties: true|Información adicional sobre el error|`{"field": "idClient"}`|

**Características especiales:**

- 🔍 `code`: Para manejo programático de errores
- 📝 `message`: Para mostrar al usuario
- 📋 `details`: Información técnica adicional

**Ejemplo JSON:**

- 
- 
- 
- 

---

## 📊 Resumen de Relaciones Entre Esquemas

- 
- 
- 
- 

---

## 🎯 Patrones de Validación Importantes

### 1. **Patrón de ID de Cliente:**

- 
- 
- 
- 

- **B** o **P** al inicio (Business/Personal)
- **C** fijo en segunda posición
- **Guión** separador
- **3 dígitos** al final
- ✅ Válidos: `BC-123`, `PC-456`
- ❌ Inválidos: `BC123`, `AC-123`, `BC-12`

### 2. **Formato de Tiempo:**

- 
- 
- 
- 

- Formato **HH:MM** (24 horas)
- ✅ Válidos: `09:00`, `14:30`, `23:59`
- ❌ Inválidos: `9:00`, `25:00`, `14:30:00`

### 3. **Formato de Fecha-Hora:**

- 
- 
- 
- 

- ISO 8601: `YYYY-MM-DDTHH:MM:SSZ`
- ✅ Válido: `2024-01-15T10:30:00Z`

---

## 💡 Uso en las Operaciones

|Operación|Input Schema|Output Schema|Error Schema|
|---|---|---|---|
|`POST /reservations`|Reservation|Confirmation|Error|
|`GET /reservations`|Query Parameters|ConfirmationList|Error|
|`PUT /reservations/{id}`|Reservation|Confirmation|Error|
|`PATCH /reservations/{id}`|ReservationPatch|Confirmation|Error|
|`DELETE /reservations/{id}`|Path Parameter|CancelConfirmation|Error|

Esta estructura permite a los estudiantes entender claramente qué datos necesita cada operación y qué respuestas pueden esperar.