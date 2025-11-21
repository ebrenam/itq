# CRUD

**CRUD** es un acrónimo que representa las cuatro operaciones fundamentales en el manejo de datos:

### **C - Create (Crear)**

- **Función**: Insertar nuevos registros
- **SQL**: `INSERT INTO`
- **HTTP**: `POST`
- **Ejemplo**: Crear un nuevo usuario

### **R - Read (Leer)**

- **Función**: Consultar/recuperar datos
- **SQL**: `SELECT`
- **HTTP**: `GET`
- **Ejemplo**: Mostrar lista de usuarios

### **U - Update (Actualizar)**

- **Función**: Modificar registros existentes
- **SQL**: `UPDATE`
- **HTTP**: `PUT` / `PATCH`
- **Ejemplo**: Cambiar email de usuario

### **D - Delete (Eliminar)**

- **Función**: Borrar registros
- **SQL**: `DELETE`
- **HTTP**: `DELETE`
- **Ejemplo**: Eliminar cuenta de usuario

## Ejemplos por tecnología:

### **SQL:**

```bash
 -- Create
INSERT INTO usuarios (nombre, email) VALUES ('Juan', 'juan@email.com');

-- Read
SELECT * FROM usuarios WHERE id = 1;

-- Update
UPDATE usuarios SET email = 'nuevo@email.com' WHERE id = 1;

-- Delete
DELETE FROM usuarios WHERE id = 1;
```

### **REST API:**

```text
POST   /api/usuarios     - Crear usuario
GET    /api/usuarios/1   - Obtener usuario
PUT    /api/usuarios/1   - Actualizar usuario
DELETE /api/usuarios/1   - Eliminar usuario
```

### **Java/Spring:**

```JavaScript
@RestController
public class UsuarioController {
    
    @PostMapping("/usuarios")          // Create
    public Usuario crear(@RequestBody Usuario usuario) { }
    
    @GetMapping("/usuarios/{id}")      // Read
    public Usuario obtener(@PathVariable Long id) { }
    
    @PutMapping("/usuarios/{id}")      // Update
    public Usuario actualizar(@PathVariable Long id, @RequestBody Usuario usuario) { }
    
    @DeleteMapping("/usuarios/{id}")   // Delete
    public void eliminar(@PathVariable Long id) { }
}
```

## Aplicaciones comunes:

### **Sistemas de gestión:**

- Gestión de usuarios
- Inventarios
- Catálogos de productos
- Sistemas CRM

### **APIs REST:**

- Servicios web
- Microservicios
- Aplicaciones móviles
- SPAs (Single Page Applications)
