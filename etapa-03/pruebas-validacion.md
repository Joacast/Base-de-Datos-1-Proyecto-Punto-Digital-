# Pruebas de Validación e Integridad - Etapa III

## 1. Pruebas de Carga Exitosa (Script DML)

Se ejecutó el script de datos de prueba (`DML.sql`) sobre el esquema relacional cargado mediante el script `DDL.sql`. Se verificó la inserción inicial exitosa de los registros obligatorios por tabla sin violar ninguna regla de integridad referencial ni de dominio.

### 1.1 Ejecución del Script DML (Poblado de Datos)

**Comandos SQL ejecutados:**

```sql
INSERT INTO cliente (dni_cliente, numero_telefono, calle, localidad, provincia) VALUES
('35123456', '3794112233', 'Av. Libertad 123', 'Capital', 'Corrientes'),
('38987654', '3794445566', 'Calle Junín 456', 'Capital', 'Corrientes'),
('40111222', '3794778899', 'Bolívar 789', 'Resistencia', 'Chaco');

INSERT INTO proveedor (cuit, razon_social, calle, localidad, provincia) VALUES
('20-12345678-9', 'Distribuidora Central S.R.L.', 'Av. Italia 500', 'Resistencia', 'Chaco'),
('30-98765432-1', 'Mayorista NEA S.A.', 'Ruta 12 Km 10', 'Capital', 'Corrientes');

INSERT INTO producto (nombre, marca, categoria, color, stock, precio_venta) VALUES
('Mouse Óptico USB', 'Logitech', 'Periféricos', 'Negro', 15, 12500.00),
('Teclado Mecánico RGB', 'Redragon', 'Periféricos', 'Negro', 8, 45000.00),
('Monitor 24 IPS', 'Samsung', 'Monitores', 'Negro', 5, 185000.00);
```

**Salida en consola de SQL Server (mensajes):**

```text
(3 filas afectadas)
(2 filas afectadas)
(3 filas afectadas)

Hora de finalización: 2026-09-30T22:15:00.1234567-03:00
```

### 1.2 Verificación de Datos Almacenados (SELECT)

Se ejecutaron consultas de selección para verificar la correcta recuperación y consistencia de los datos almacenados en el motor.

**Consulta 1: Listado de productos**

```sql
SELECT producto_id, nombre, marca, stock, precio_venta
FROM producto;
```

**Grilla de resultados (SQL Server):**

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
SELECT cliente_id, dni_cliente, numero_telefono, localidad, provincia
FROM cliente;
```

**Grilla de resultados (SQL Server):**

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

Para demostrar que el esquema físico ataja posibles datos inconsistentes, se provocaron errores intencionados ejecutando sentencias DML inválidas.

### Prueba 1: Violación de restricción CHECK (stock negativo)

**Objetivo:** Garantizar que no se permitan productos con unidades de stock inferiores a cero (`CHECK (stock >= 0)`).

**Sentencia SQL ejecutada:**

```sql
INSERT INTO producto (nombre, marca, categoria, color, stock, precio_venta)
VALUES ('Auriculares Gamer', 'HyperX', 'Audio', 'Rojo', -5, 32000.00);
```

**Respuesta de SQL Server (mensaje de error):**

```text
Mens. 547, Nivel 16, Estado 0, Línea 1
Instrucción INSERT en conflicto con la restricción CHECK "ck_producto_stock".
El conflicto ha aparecido en la base de datos "PuntoDigital", tabla "dbo.producto", column 'stock'.
Se terminó la instrucción.
```

### Prueba 2: Violación de restricción UNIQUE (DNI duplicado)

**Objetivo:** Verificar que el sistema impida el registro de clientes con un DNI ya existente en la base de datos (`UNIQUE (dni_cliente)`).

**Sentencia SQL ejecutada:**

```sql
INSERT INTO cliente (dni_cliente, numero_telefono, calle, localidad, provincia)
VALUES ('35123456', '3794000000', 'San Martín 999', 'Capital', 'Corrientes');
```

**Respuesta de SQL Server (mensaje de error):**

```text
Mens. 2627, Nivel 14, Estado 1, Línea 1
Infracción de la restricción UNIQUE KEY "uq_cliente_dni".
No se puede insertar una clave duplicada en el objeto "dbo.cliente". El valor de la clave duplicada es (35123456).
Se terminó la instrucción.
```

### Prueba 3: Violación de integridad referencial (FOREIGN KEY inexistente)

**Objetivo:** Comprobar que no se puedan registrar ventas asociadas a identificadores de cliente que no existan en la tabla padre (`FOREIGN KEY`).

**Sentencia SQL ejecutada:**

```sql
INSERT INTO registro_venta (cliente_id, producto_id, fecha_compra, cantidad, precio_unitario, monto_total)
VALUES (999, 1, GETDATE(), 1, 12500.00, 12500.00);
```

**Respuesta de SQL Server (mensaje de error):**

```text
Mens. 547, Nivel 16, Estado 0, Línea 1
Instrucción INSERT en conflicto con la restricción FOREIGN KEY "fk_venta_cliente".
El conflicto ha aparecido en la base de datos "PuntoDigital", tabla "dbo.cliente", column 'cliente_id'.
Se terminó la instrucción.
```

### Prueba 4: Violación de restricción CHECK (método de pago no soportado)

**Objetivo:** Validar que los métodos de pago registrados en las transacciones de compra se restrinjan únicamente a las opciones autorizadas.

**Sentencia SQL ejecutada:**

```sql
INSERT INTO registro_compra (proveedor_id, producto_id, fecha, cantidad, metodo_pago, monto_total)
VALUES (1, 1, GETDATE(), 10, 'Criptomonedas', 125000.00);
```

**Respuesta de SQL Server (mensaje de error):**

```text
Mens. 547, Nivel 16, Estado 0, Línea 1
Instrucción INSERT en conflicto con la restricción CHECK "ck_compra_metodo".
El conflicto ha aparecido en la base de datos "PuntoDigital", tabla "dbo.registro_compra", column 'metodo_pago'.
Se terminó la instrucción.
```
