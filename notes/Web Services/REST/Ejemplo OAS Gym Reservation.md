- Existen dos versiones del contrato, esto se debe a los ajustes realizados por la revisión del mismo durante el proceso de generación de código.

- Considera utilizar la última versión disponible.
## Versión inicial del contrato

```yaml
openapi: 3.0.4
info:
  title: Gym Reservation API
  description: API REST para gestión de reservas de gimnasio
  version: 1.0.0
  contact:
    name: ITQ distributed and cloud systems
    email: ivonne.al@queretaro.tecnm.mx
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html

servers:
  - url: http://localhost:8080/api/v1
    description: Servidor de desarrollo
  - url: https://api.gym.com/api/v1
    description: Servidor de producción

tags:
  - name: Reservations
    description: Operaciones relacionadas con reservas del gimnasio

paths:
  /reservations:
    post:
      summary: Crear nueva reserva
      description: Crea una nueva reserva en el gimnasio
      operationId: createReservation
      tags:
        - Reservations
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Reservation'
            example:
              idClient: "BC-123"
              activity: "Yoga"
              dayOfWeek: "Lun"
              time: "09:00"
      responses:
        '201':
          description: Reserva creada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Confirmation'
              example:
                idReservation: 12345
                idRoom: 5
                instructor: "María García"
                discount: 10.50
        '400':
          description: Datos de entrada inválidos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: Conflicto - horario no disponible
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '500':
          description: Error interno del servidor
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

    get:
      summary: Buscar reservas
      description: Busca reservas existentes basado en criterios
      operationId: getReservations
      tags:
        - Reservations
      parameters:
        - name: idClient
          in: query
          description: ID del cliente (formato BC-XXX o PC-XXX)
          required: false
          schema:
            type: string
            pattern: '^[BP]C-[0-9]{3}$'
          example: "BC-123"
        - name: activity
          in: query
          description: Nombre de la actividad
          required: false
          schema:
            type: string
            minLength: 3
            maxLength: 255
          example: "Yoga"
        - name: dayOfWeek
          in: query
          description: Día de la semana
          required: false
          schema:
            type: string
            enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]
          example: "Lun"
        - name: time
          in: query
          description: Hora de la actividad
          required: false
          schema:
            type: string
            format: time
          example: "09:00"
      responses:
        '200':
          description: Lista de reservas encontradas
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ConfirmationList'
              example:
                confirmations:
                  - idReservation: 12345
                    idRoom: 5
                    instructor: "María García"
                    discount: 10.50
                  - idReservation: 12346
                    idRoom: 3
                    instructor: "Juan Pérez"
                    discount: 0
        '400':
          description: Parámetros de búsqueda inválidos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '404':
          description: No se encontraron reservas
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /reservations/{reservationId}:
    put:
      summary: Actualizar reserva completa
      description: Actualiza todos los datos de una reserva existente
      operationId: updateReservation
      tags:
        - Reservations
      parameters:
        - name: reservationId
          in: path
          description: ID de la reserva a actualizar
          required: true
          schema:
            type: integer
            format: int32
          example: 12345
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Reservation'
            example:
              idClient: "BC-123"
              activity: "Pilates"
              dayOfWeek: "Mar"
              time: "10:30"
      responses:
        '200':
          description: Reserva actualizada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Confirmation'
              example:
                idReservation: 12345
                idRoom: 8
                instructor: "Ana López"
                discount: 15.00
        '400':
          description: Datos de entrada inválidos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '404':
          description: Reserva no encontrada
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: Conflicto - nuevo horario no disponible
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '500':
          description: Error interno del servidor
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

    patch:
      summary: Actualizar reserva parcialmente
      description: Actualiza solo los campos especificados de una reserva existente
      operationId: patchReservation
      tags:
        - Reservations
      parameters:
        - name: reservationId
          in: path
          description: ID de la reserva a actualizar
          required: true
          schema:
            type: integer
            format: int32
          example: 12345
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ReservationPatch'
            example:
              activity: "Zumba"
              time: "11:00"
      responses:
        '200':
          description: Reserva actualizada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Confirmation'
              example:
                idReservation: 12345
                idRoom: 5
                instructor: "María García"
                discount: 10.50
        '400':
          description: Datos de entrada inválidos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '404':
          description: Reserva no encontrada
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: Conflicto - nuevo horario no disponible
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

    delete:
      summary: Cancelar reserva
      description: Cancela una reserva existente
      operationId: cancelReservation
      tags:
        - Reservations
      parameters:
        - name: reservationId
          in: path
          description: ID de la reserva a cancelar
          required: true
          schema:
            type: integer
            format: int32
          example: 12345
      responses:
        '200':
          description: Reserva cancelada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CancelConfirmation'
              example:
                idReservation: 12345
                status: "cancelled"
                message: "Reserva cancelada exitosamente"
        '404':
          description: Reserva no encontrada
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: No se puede cancelar la reserva
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  schemas:
    Reservation:
      type: object
      description: Datos para crear una nueva reserva
      required:
        - idClient
        - activity
        - dayOfWeek
        - time
      properties:
        idClient:
          type: string
          description: Identificador del cliente
          pattern: '^[BP]C-[0-9]{3}$'
          example: "BC-123"
        activity:
          type: string
          description: Nombre de la actividad
          minLength: 3
          maxLength: 255
          example: "Yoga"
        dayOfWeek:
          type: string
          description: Día de la semana
          enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]
          example: "Lun"
        time:
          type: string
          description: Hora de la actividad
          format: time
          example: "09:00"

    ReservationPatch:
      type: object
      description: Datos para actualización parcial de una reserva (todos los campos opcionales)
      properties:
        idClient:
          type: string
          description: Identificador del cliente
          pattern: '^[BP]C-[0-9]{3}$'
          example: "BC-123"
        activity:
          type: string
          description: Nombre de la actividad
          minLength: 3
          maxLength: 255
          example: "Yoga"
        dayOfWeek:
          type: string
          description: Día de la semana
          enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]
          example: "Lun"
        time:
          type: string
          description: Hora de la actividad
          format: time
          example: "09:00"
      additionalProperties: false

    Confirmation:
      type: object
      description: Confirmación de reserva
      required:
        - idReservation
        - idRoom
      properties:
        idReservation:
          type: integer
          format: int32
          description: ID único de la reserva
          example: 12345
        idRoom:
          type: integer
          format: int32
          description: ID de la sala asignada
          minimum: 1
          maximum: 20
          example: 5
        instructor:
          type: string
          description: Nombre del instructor asignado
          maxLength: 255
          example: "María García"
        discount:
          type: number
          format: decimal
          description: Descuento aplicado
          multipleOf: 0.01
          minimum: 0
          maximum: 999.99
          example: 10.50

    ConfirmationList:
      type: object
      description: Lista de confirmaciones de reservas
      properties:
        confirmations:
          type: array
          items:
            $ref: '#/components/schemas/Confirmation'
          description: Array de confirmaciones
        total:
          type: integer
          description: Total de reservas encontradas
          example: 2

    CancelConfirmation:
      type: object
      description: Confirmación de cancelación
      required:
        - idReservation
        - status
      properties:
        idReservation:
          type: integer
          format: int32
          description: ID de la reserva cancelada
          example: 12345
        status:
          type: string
          description: Estado de la cancelación
          enum: [cancelled, failed]
          example: "cancelled"
        message:
          type: string
          description: Mensaje descriptivo
          example: "Reserva cancelada exitosamente"
        cancelledAt:
          type: string
          format: date-time
          description: Fecha y hora de cancelación
          example: "2024-01-15T10:30:00Z"

    Error:
      type: object
      description: Respuesta de error estándar
      required:
        - code
        - message
      properties:
        code:
          type: string
          description: Código de error
          example: "INVALID_CLIENT_ID"
        message:
          type: string
          description: Mensaje de error legible
          example: "El ID del cliente debe seguir el formato BC-XXX o PC-XXX"
        details:
          type: object
          description: Detalles adicionales del error
          additionalProperties: true
```

## Versión actualizada del contrato

```yaml
openapi: 3.0.4
info:
  title: Gym Reservation API
  description: API REST para gestión de reservas de gimnasio
  version: 1.0.0
  contact:
    name: ITQ distributed and cloud systems
    email: ivonne.al@queretaro.tecnm.mx
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0.html

servers:
  - url: http://localhost:8080/api/v1
    description: Servidor de desarrollo
  - url: https://api.gym.com/api/v1
    description: Servidor de producción

tags:
  - name: reservations
    description: Operaciones relacionadas con reservas del gimnasio

paths:
  /reservations:
    post:
      summary: Crear nueva reserva
      description: Crea una nueva reserva en el gimnasio
      operationId: createReservation
      tags:
        - reservations
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Reservation'
            example:
              idClient: "BC-123"
              activity: "Yoga"
              dayOfWeek: "Lun"
              time: "09:00"
      responses:
        '201':
          description: Reserva creada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Confirmation'
              example:
                idReservation: 12345
                idRoom: 5
                instructor: "María García"
                discount: 10.50
        '400':
          description: Datos de entrada inválidos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: Conflicto - horario no disponible
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '500':
          description: Error interno del servidor
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

    get:
      summary: Buscar reservas
      description: Busca reservas existentes basado en criterios
      operationId: searchReservations
      tags:
        - reservations
      parameters:
        - name: idClient
          in: query
          description: ID del cliente (formato BC-XXX o PC-XXX)
          required: false
          schema:
            type: string
            pattern: '^[BP]C-[0-9]{3}$'
          example: "BC-123"
        - name: activity
          in: query
          description: Nombre de la actividad
          required: false
          schema:
            type: string
            minLength: 3
            maxLength: 255
          example: "Yoga"
        - name: dayOfWeek
          in: query
          description: Día de la semana
          required: false
          schema:
            type: string
            enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]
          example: "Lun"
        - name: time
          in: query
          description: Hora de la actividad
          required: false
          schema:
            type: string
            format: time
          example: "09:00"
      responses:
        '200':
          description: Lista de reservas encontradas (puede estar vacía)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ConfirmationList'
              example:
                confirmations:
                  - idReservation: 12345
                    idRoom: 5
                    instructor: "María García"
                    discount: 10.50
                  - idReservation: 12346
                    idRoom: 3
                    instructor: "Juan Pérez"
                    discount: 0
        '400':
          description: Parámetros de búsqueda inválidos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '404':
          description: No se encontraron reservas
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /reservations/{reservationId}:
    get:
      summary: Obtener reserva específica
      description: Recupera los detalles de una reserva específica por ID
      operationId: getReservationById
      tags:
        - reservations
      parameters:
        - name: reservationId
          in: path
          description: ID único de la reserva
          required: true
          schema:
            type: integer                    # ← CORREGIDO: Sin format
            minimum: 1
            maximum: 999999
          example: 12345
      responses:
        '200':
          description: Reserva encontrada
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Confirmation'
              example:
                idReservation: 12345
                idRoom: 8
                instructor: "Ana López"
                discount: 15.00
        '404':
          description: Reserva no encontrada
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

    put:
      summary: Actualizar reserva completa
      description: Actualiza todos los datos de una reserva existente
      operationId: updateReservation
      tags:
        - reservations
      parameters:
        - name: reservationId
          in: path
          description: ID de la reserva a actualizar
          required: true
          schema:
            type: integer
            minimum: 1
            maximum: 999999
          example: 12345
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Reservation'
            example:
              idClient: "BC-123"
              activity: "Pilates"
              dayOfWeek: "Mar"
              time: "10:30"
      responses:
        '200':
          description: Reserva actualizada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Confirmation'
              example:
                idReservation: 12345
                idRoom: 8
                instructor: "Ana López"
                discount: 15.00
        '400':
          description: Datos de entrada inválidos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '404':
          description: Reserva no encontrada
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: Conflicto - nuevo horario no disponible
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '500':
          description: Error interno del servidor
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

    patch:
      summary: Actualizar reserva parcialmente
      description: Actualiza solo los campos especificados de una reserva existente
      operationId: patchReservation
      tags:
        - reservations
      parameters:
        - name: reservationId
          in: path
          description: ID de la reserva a actualizar
          required: true
          schema:
            type: integer
            minimum: 1
            maximum: 999999
          example: 12345
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ReservationPatch'
            example:
              activity: "Zumba"
              time: "11:00"
      responses:
        '200':
          description: Reserva actualizada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Confirmation'
              example:
                idReservation: 12345
                idRoom: 5
                instructor: "María García"
                discount: 10.50
        '400':
          description: Datos de entrada inválidos
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '404':
          description: Reserva no encontrada
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: Conflicto - nuevo horario no disponible
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

    delete:
      summary: Cancelar reserva
      description: Cancela una reserva existente
      operationId: cancelReservation
      tags:
        - reservations
      parameters:
        - name: reservationId
          in: path
          description: ID de la reserva a cancelar
          required: true
          schema:
            type: integer
            minimum: 1
            maximum: 999999
          example: 12345
      responses:
        '200':
          description: Reserva cancelada exitosamente
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CancelConfirmation'
              example:
                idReservation: 12345
                status: "cancelled"
                message: "Reserva cancelada exitosamente"
        '404':
          description: Reserva no encontrada
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
        '409':
          description: No se puede cancelar la reserva
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  schemas:
    Reservation:
      type: object
      description: Datos para crear una nueva reserva
      required:
        - idClient
        - activity
        - dayOfWeek
        - time
      properties:
        idClient:
          type: string
          description: Identificador del cliente
          pattern: '^[BP]C-[0-9]{3}$'
          example: "BC-123"
        activity:
          type: string
          description: Nombre de la actividad
          minLength: 3
          maxLength: 255
          example: "Yoga"
        dayOfWeek:
          type: string
          description: Día de la semana
          enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]
          example: "Lun"
        time:
          type: string
          description: Hora de la actividad (formato HH:MM)
          format: time
          example: "09:00"

    ReservationPatch:
      type: object
      description: Datos para actualización parcial de una reserva (todos los campos opcionales)
      properties:
        idClient:
          type: string
          description: Identificador del cliente
          pattern: '^[BP]C-[0-9]{3}$'
          example: "BC-123"
        activity:
          type: string
          description: Nombre de la actividad
          minLength: 3
          maxLength: 255
          example: "Yoga"
        dayOfWeek:
          type: string
          description: Día de la semana
          enum: [Lun, Mar, Mie, Jue, Vie, Sab, Dom]
          example: "Lun"
        time:
          type: string
          description: Hora de la actividad (formato HH:MM)
          format: time
          example: "09:00"
      additionalProperties: false

    Confirmation:
      type: object
      description: Confirmación de reserva
      required:
        - idReservation
        - idRoom
      properties:
        idReservation:
          type: integer                    # ← Cambiado: sin format
          description: ID único de la reserva
          minimum: 1
          maximum: 999999                  # ← Agregado: límite realista
          example: 12345
        idRoom:
          type: integer                    # ← Cambiado: sin format
          description: ID de la sala asignada
          minimum: 1
          maximum: 20
          example: 5
        instructor:
          type: string
          description: Nombre del instructor asignado
          maxLength: 255
          example: "María García"
        discount:
          type: number
          format: double
          description: Descuento aplicado a la reserva
          minimum: 0.0
          maximum: 999.99
          example: 127.50

    ConfirmationList:
      type: object
      description: Lista de confirmaciones de reservas
      properties:
        confirmations:
          type: array
          items:
            $ref: '#/components/schemas/Confirmation'
          description: Array de confirmaciones
        total:
          type: integer
          description: Total de reservas encontradas
          example: 2

    CancelConfirmation:
      type: object
      description: Confirmación de cancelación
      required:
        - idReservation
        - status
      properties:
        idReservation:
          type: integer                    # ← Sin format
          description: ID de la reserva cancelada
          minimum: 1                       # ← Agregado
          maximum: 999999                  # ← Agregado
          example: 12345
        status:
          type: string
          description: Estado de la cancelación
          enum: [cancelled, failed]
          example: "cancelled"
        message:
          type: string
          description: Mensaje descriptivo
          maxLength: 500                   # ← Agregado límite
          example: "Reserva cancelada exitosamente"
        cancelledAt:
          type: string
          format: date-time
          description: Fecha y hora de cancelación
          example: "2024-01-15T10:30:00Z"

    Error:
      type: object
      description: Respuesta de error estándar
      required:
        - code
        - message
      properties:
        code:
          type: string
          description: Código de error
          example: "INVALID_CLIENT_ID"
        message:
          type: string
          description: Mensaje de error legible
          example: "El ID del cliente debe seguir el formato BC-XXX o PC-XXX"
        details:
          type: object
          description: Detalles adicionales del error
          additionalProperties: true
```
