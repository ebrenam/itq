# README

Construcción de Servicios Web tipo SOAP.

## wsdl

Explicación del diagrama:

- Servicio: `GymReservationService` expuesto en <http://localhost:8080/ws/gym-reservation>
- Puerto: `ReservationPort` que usa el binding SOAP
- Binding: `ReservationBinding` con estilo documento, transporte HTTP y uso literal
- Tres operaciones:
  1. `createReservationOperation`: Crear una nueva reserva
  2. `getReservationOperation`: Buscar reservas existentes
  3. `cancelReservationOperation`: Cancelar una reserva
- Mensajes: Cada operación tiene un mensaje de entrada (request) y uno de salida (response)
- Tipos: Todos los elementos están definidos en el XSD `gym.xsd` incluido en la sección `<wsdl:types>`

```mermaid
flowchart LR
    subgraph Service["GymReservationService"]
        Port["ReservationPort<br/>Location: http://localhost:8080/ws/gym-reservation"]
    end
    
    subgraph Binding["ReservationBinding (SOAP)"]
        B1["Style: document<br/>Transport: HTTP<br/>Body use: literal"]
    end
    
    subgraph PortType["ReservationPortType"]
        Op1["createReservationOperation<br/>soapAction: createReservation"]
        Op2["getReservationOperation<br/>soapAction: getReservation"]
        Op3["cancelReservationOperation<br/>soapAction: cancelReservation"]
    end
    
    subgraph Messages["Messages"]
        subgraph CreateReservation["Create Reservation"]
            CreateReq["CreateReservationMessageRequest<br/>Part: tns:reservation"]
            CreateRes["CreateReservationMessageResponse<br/>Part: tns:confirmation"]
        end
        
        subgraph GetReservation["Get Reservation"]
            GetReq["GetReservationMessageRequest<br/>Part: tns:searchCriteria"]
            GetRes["GetReservationMessageResponse<br/>Part: tns:confirmations"]
        end
        
        subgraph CancelReservation["Cancel Reservation"]
            CancelReq["CancelReservationMessageRequest<br/>Part: tns:cancelReservation"]
            CancelRes["CancelReservationMessageResponse<br/>Part: tns:cancelConfirmation"]
        end
    end
    
    subgraph Types["XSD Elements (gym.xsd)"]
        T1["tns:reservation<br/>(reservationType)"]
        T2["tns:confirmation<br/>(confirmationType)"]
        T3["tns:searchCriteria<br/>(reservationType)"]
        T4["tns:confirmations<br/>(confirmationType[])"]
        T5["tns:cancelReservation<br/>(idReservation: int)"]
        T6["tns:cancelConfirmation<br/>(idReservation: int)"]
    end
    
    Service --> Port
    Port --> Binding
    Binding --> PortType
    
    PortType --> Op1
    PortType --> Op2
    PortType --> Op3
    
    Op1 --> CreateReq
    Op1 --> CreateRes
    Op2 --> GetReq
    Op2 --> GetRes
    Op3 --> CancelReq
    Op3 --> CancelRes
    
    CreateReq --> T1
    CreateRes --> T2
    GetReq --> T3
    GetRes --> T4
    CancelReq --> T5
    CancelRes --> T6
    
    style Service fill:#e1f5fe
    style PortType fill:#f3e5f5
    style Messages fill:#e8f5e8
    style Types fill:#fff3e0
    style Binding fill:#f1f8e9
```

## gym.xsd

Explicación del diagrama:

- Tipos complejos reutilizables:
  - `reservationType`: Estructura para reservas con validaciones específicas
  - `confirmationType`: Estructura para confirmaciones con campos opcionales

- Elementos raíz:
  - `reservation` y `searchCriteria` usan `reservationType`
  - `confirmation` usa `confirmationType`
  - `confirmations` contiene múltiples `confirmationType`
  - `cancelReservation` y `cancelConfirmation` tienen estructura simple

- Validaciones destacadas:
  - ID cliente sigue patrón BC-XXX o PC-XXX
  - Actividad entre 5-255 caracteres
  - Día de semana limitado a 7 valores
  - Sala entre 1-20
  - Descuento opcional con precisión decimal

### reservationType

```mermaid
erDiagram
    reservationType {
        string idClient "Pattern: (BC|PC)-[0-9]{3}"
        string activity "5-255 chars"
        string dayOfWeek "Enum: Lun|Mar|Mie|Jue|Vie|Sab|Dom"
        string time
    }
    
    reservation {
        reservationType reservationData
    }
    
    searchCriteria {
        reservationType searchData
    }

    %% Relationships
    reservation ||--|| reservationType : contains
    searchCriteria ||--|| reservationType : contains
```

### confirmationType

```mermaid
erDiagram
    confirmationType {
        int idReservation
        int idRoom "Range: 1-20"
        string instructor "Optional, max 255 chars"
        decimal discount "Optional, 4 digits, 2 decimals"
    }
    
    confirmation {
        confirmationType confirmationData
    }
    
    confirmations {
        confirmationType[] confirmationList "0 to many"
    }
    
    %% Relationships
 
    confirmation ||--|| confirmationType : contains
    confirmations ||--o{ confirmationType : contains
```

### cancelReservation

```mermaid
erDiagram
    cancelReservation {
        int idReservation
    }
```

### cancelConfirmation

```mermaid
erDiagram
    cancelConfirmation {
        int idReservation
    }
```
