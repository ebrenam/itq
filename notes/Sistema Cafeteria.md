
## Definición
**** Sistema Cafeteria

Pedidos (R)
id
cantidad
idMenu
costoTotal

Menu (R)
bebidas
producto
idProductos


Pagos (R)
idPedido
tipoPago



Proceso de alta de Pedidos

Tipo bebida:
Tamaño:
Topings:
Cantidad:
Nombre:

/orders
-> POST
    - beverageType: [coffee, tea, juice]
    - size: [small, medium, large]
    - topings: [milk, sugar, lemon]
    - amount: 2
    - clientName: "John Doe"

## 🛣️ REST API - Sistema Cafetería

### **POST /api/v1/orders**

**Crear nuevo pedido**

#### Request Body:

```json
{
"beverageType": "coffee",
"size": "medium",
"toppings": ["milk", "sugar"],
"amount": 2,
"clientName": "John Doe"
}
```

#### Responses:

**201 Created:**

```json
{
  "orderId": 12345,
  "beverageType": "coffee",
  "size": "medium",
  "toppings": ["milk", "sugar"],
  "amount": 2,
  "clientName": "John Doe",
  "totalCost": 15.50,
  "status": "pending",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

**400 Bad Request:**

```json
{
  "error": "INVALID_INPUT",
  "message": "Tipo de bebida no válido",
  "details": {
    "field": "beverageType",
    "allowedValues": ["coffee", "tea", "juice"]
  }
}
```

#### Validaciones:

- **beverageType**: Enum [`coffee`, `tea`, `juice`]
- **size**: Enum [`small`, `medium`, `large`]
- **toppings**: Array con valores [`milk`, `sugar`, `lemon`]
- **amount**: Integer, mínimo 1, máximo 10
- **clientName**: String, longitud 2-100 caracteres

#### Ejemplo cURL:

```bash
curl -X POST http://localhost:8080/api/v1/orders \
  -H "Content-Type: application/json" \
  -d '{
    "beverageType": "coffee",
    "size": "medium",
    "toppings": ["milk", "sugar"],
    "amount": 2,
    "clientName": "John Doe"
  }'
```

#### URLs adicionales sugeridas:

- `GET /api/v1/orders` - Listar pedidos
- `GET /api/v1/orders/{id}` - Obtener pedido específico
- `PUT /api/v1/orders/{id}` - Actualizar pedido
- `DELETE /api/v1/orders/{id}` - Cancelar pedido



http://dom.com/futbol/equipo?val=gallos




{
  "beverageType": "",
  "size": "",
  "clientName": "John"
}


{
  "beverageType": "coffee",
  "size": "small",
  "clientName": ""
}



{
  "beverageType": "coffee",
  "size": "small",
  "clientName": "ba"
}
