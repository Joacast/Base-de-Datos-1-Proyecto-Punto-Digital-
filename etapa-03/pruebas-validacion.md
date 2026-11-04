# Pruebas de Validación e Integridad - Etapa III

## 1. Pruebas de Carga Exitosa (Script DML)

Este documento usa una carga reducida para probar las restricciones. Ejecutar primero `sql/ddl/crear_bd.sql` en una base de prueba nueva y vacía, y luego los INSERT de este documento, una sola vez. Los identificadores deben comenzar en 1. Esta carga se usa en lugar de `sql/dml/datos_prueba.sql`, no junto con ella.

### 1.1 Ejecución del Script DML (Poblado de Datos)

**Comandos SQL para ejecutar:**

```sql
INSERT INTO persona (numero_telefono, calle, localidad, provincia) VALUES
('3794112233', 'Av. Libertad 123', 'Capital', 'Corrientes'),
('3794445566', 'Calle Junín 456', 'Capital', 'Corrientes'),
('3794778899', 'Bolívar 789', 'Resistencia', 'Chaco'),
(NULL, 'Av. Italia 500', 'Resistencia', 'Chaco'),
(NULL, 'Ruta 12 Km 10', 'Capital', 'Corrientes');

INSERT INTO cliente (persona_id, dni_cliente) VALUES
(1, '35123456'),
(2, '38987654'),
(3, '40111222');

INSERT INTO proveedor (persona_id, cuit, razon_social) VALUES
(4, '20-12345678-9', 'Distribuidora Central S.R.L.'),
(5, '30-98765432-1', 'Mayorista NEA S.A.');

INSERT INTO producto (nombre, marca, categoria, color, stock, precio_venta) VALUES
('Mouse Óptico USB', 'Logitech', 'Periféricos', 'Negro', 15, 12500.00),
('Teclado Mecánico RGB', 'Redragon', 'Periféricos', 'Negro', 8, 45000.00),
('Monitor 24 IPS', 'Samsung', 'Monitores', 'Negro', 5, 185000.00);
```

**Salida esperada en consola:**

```text
(5 filas afectadas)
(3 filas afectadas)
(2 filas afectadas)
(3 filas afectadas)

```

### 1.2 Verificación de Datos Almacenados (SELECT)

Ejecutar las siguientes consultas para comprobar los datos de la carga reducida.

**Consulta 1: Listado de productos**

```sql
SELECT producto_id, nombre, marca, stock, precio_venta
FROM producto;
```

**Resultados esperados:**

```text
producto_id | nombre               | marca    | stock | precio_venta
------------+----------------------+----------+-------+--------------
1           | Mouse Óptico USB     | Logitech | 15    | 12500.00
2           | Teclado Mecánico RGB | Redragon | 8     | 45000.00
3           | Monitor 24 IPS       | Samsung  | 5     | 185000.00

(3 filas afectadas)
```

**Consulta 2: Listado de clientes registrados**

```sql
SELECT c.cliente_id, c.dni_cliente, p.numero_telefono, p.localidad, p.provincia
FROM cliente c
INNER JOIN persona p ON c.persona_id = p.persona_id
ORDER BY c.cliente_id;
```

**Resultados esperados:**

```text
cliente_id | dni_cliente | numero_telefono | localidad   | provincia
-----------+-------------+-----------------+-------------+-----------
1          | 35123456    | 3794112233      | Capital     | Corrientes
2          | 38987654    | 3794445566      | Capital     | Corrientes
3          | 40111222    | 3794778899      | Resistencia | Chaco

(3 filas afectadas)
```

---

## 2. Pruebas de Restricciones (Validación de Reglas de Negocio)

Para demostrar que el esquema físico ataja posibles datos inconsistentes, se ejecutan por separado las siguientes sentencias inválidas. Deben rechazarse sin insertar filas. El nombre de la base y el texto exacto del error pueden variar según el entorno.

### Prueba 1: Violación de restricción CHECK (stock negativo)

**Objetivo:** Garantizar que no se permitan productos con unidades de stock inferiores a cero (`CHECK (stock >= 0)`).

**Sentencia SQL para ejecutar:**

```sql
INSERT INTO producto (nombre, marca, categoria, color, stock, precio_venta)
VALUES ('Auriculares Gamer', 'HyperX', 'Audio', 'Rojo', -5, 32000.00);
```

**Respuesta esperada de SQL Server:**

```text
Mens. 547, Nivel 16, Estado 0, Línea 1
Instrucción INSERT en conflicto con la restricción CHECK "ck_producto_stock".
El conflicto ha aparecido en la base de datos "PuntoDigital", tabla "dbo.producto", column 'stock'.
Se terminó la instrucción.
```

### Prueba 2: Violación de restricción UNIQUE (DNI duplicado)

**Objetivo:** Verificar que el sistema impida el registro de clientes con un DNI ya existente en la base de datos (`UNIQUE (dni_cliente)`). Se usa Persona 4, que existe y aún no tiene un registro de cliente, para que el rechazo corresponda al DNI duplicado.

**Sentencia SQL para ejecutar:**

```sql
INSERT INTO cliente (persona_id, dni_cliente)
VALUES (4, '35123456');
```

**Respuesta esperada de SQL Server:**

```text
Mens. 2627, Nivel 14, Estado 1, Línea 1
Infracción de la restricción UNIQUE KEY "uq_cliente_dni".
No se puede insertar una clave duplicada en el objeto "dbo.cliente". El valor de la clave duplicada es (35123456).
Se terminó la instrucción.
```

### Prueba 3: Violación de integridad referencial (FOREIGN KEY inexistente)

**Objetivo:** Comprobar que no se puedan registrar ventas asociadas a identificadores de cliente que no existan en la tabla padre (`FOREIGN KEY`).

**Sentencia SQL para comprobar la restricción:**

Se incluye un método de pago válido para que el rechazo corresponda al cliente inexistente. Para repetir la prueba, el producto 1 debe existir y el cliente 999 no debe existir.

```sql
INSERT INTO registro_venta (cliente_id, producto_id, fecha_compra, cantidad, precio_unitario, monto_total, metodo_pago)
VALUES (999, 1, GETDATE(), 1, 12500.00, 12500.00, 'Efectivo');
```

**Respuesta esperada de SQL Server (el nombre de la base y la línea pueden variar):**

```text
Mens. 547, Nivel 16, Estado 0, Línea 1
Instrucción INSERT en conflicto con la restricción FOREIGN KEY "fk_venta_cliente".
El conflicto ha aparecido en la base de datos "PuntoDigital", tabla "dbo.cliente", column 'cliente_id'.
Se terminó la instrucción.
```

### Prueba 4: Violación de restricción CHECK (método de pago no soportado)

**Objetivo:** Validar que los métodos de pago registrados en las transacciones de compra se restrinjan únicamente a las opciones autorizadas.

**Sentencia SQL para ejecutar:**

```sql
INSERT INTO registro_compra (proveedor_id, producto_id, fecha, cantidad, metodo_pago, monto_total)
VALUES (1, 1, GETDATE(), 10, 'Criptomonedas', 125000.00);
```

**Respuesta esperada de SQL Server:**

```text
Mens. 547, Nivel 16, Estado 0, Línea 1
Instrucción INSERT en conflicto con la restricción CHECK "ck_compra_metodo".
El conflicto ha aparecido en la base de datos "PuntoDigital", tabla "dbo.registro_compra", column 'metodo_pago'.
Se terminó la instrucción.
```
