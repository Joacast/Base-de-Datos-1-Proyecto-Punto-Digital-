# Consultas y Casos de Uso

**Punto 1: Factura / Comprobante de Venta**

## 1. Caso de uso de negocio

El área de atención al cliente y facturación de Punto Digital requiere generar un comprobante a partir de un registro de venta seleccionado.

El objetivo es obtener los datos de la venta y del cliente junto con el producto vendido, su cantidad, precio unitario e importe. Cada registro de venta corresponde a un solo producto.

Esta consulta facilita la emisión de comprobantes impresos o digitales, garantizando transparencia en el desglose de precios y cantidades para el cliente y optimizando el control administrativo de las operaciones comerciales.

Para consolidar la información, se relacionan la tabla principal `registro_venta` con las tablas `cliente`, `persona` y `producto` mediante sus respectivos identificadores (`cliente_id` y `producto_id`).

**Resultado esperado:** Obtener el detalle completo de la venta indicada (por ejemplo, `registro_venta_id = 1`), mostrando datos del comprobante, información del cliente, especificación del producto, cantidad e importe del registro.

## 2. Consulta SQL

```sql
USE punto_digital;
GO

-- ============================================================================
-- ETAPA IV - CONSULTA 1: FACTURA / COMPROBANTE DE VENTA
-- ============================================================================

SELECT 
    -- ENCABEZADO
    v.registro_venta_id                                       AS nro_comprobante,
    v.fecha_compra                                            AS fecha_emision,
    c.dni_cliente                                             AS dni_cliente,
    pe.numero_telefono                                         AS telefono,
    CONCAT_WS(', ', pe.calle, pe.localidad, pe.provincia)        AS domicilio,
    v.metodo_pago                                             AS forma_pago,
    
    -- DETALLE / RENGLÓN
    p.nombre                                                  AS descripcion_producto,
    p.marca                                                   AS marca,
    p.categoria                                               AS categoria,
    v.cantidad                                                AS cantidad,
    v.precio_unitario                                         AS precio_unitario,
    
    -- CÁLCULOS
    (v.cantidad * v.precio_unitario)                          AS subtotal_renglon,
    
    -- El ID es único: esta partición contiene un solo registro.
    SUM(v.cantidad * v.precio_unitario) OVER(
        PARTITION BY v.registro_venta_id
    )                                                         AS total_comprobante

FROM registro_venta v
INNER JOIN cliente c  ON v.cliente_id  = c.cliente_id
INNER JOIN persona pe ON c.persona_id = pe.persona_id
INNER JOIN producto p ON v.producto_id = p.producto_id
WHERE v.registro_venta_id = 1; -- Cambiar por el ID de comprobante deseado
```

## 3. Explicación de la consulta

### 3.1. SELECT

Se seleccionan y estructuran los campos que componen la factura o comprobante de venta:

#### Encabezado de la venta y cliente
- `v.registro_venta_id`: identificador único de la transacción que actúa como número de comprobante.
- `v.fecha_compra`: fecha en la que se realizó la operación.
- `c.dni_cliente`: documento de identidad del comprador.
- `pe.numero_telefono`: teléfono de contacto del cliente.
- `CONCAT_WS(', ', pe.calle, pe.localidad, pe.provincia)`: concatena los campos de dirección de la tabla persona en una sola cadena formateada, omitiendo valores nulos automáticamente para evitar resultados no deseados.
- `v.metodo_pago`: forma de pago utilizada en la transacción (efectivo, tarjeta, transferencia, etc.).

#### Detalle de producto
- `p.nombre`: denominación comercial del producto.
- `p.marca`: marca asociada al producto.
- `p.categoria`: clasificación o categoría a la que pertenece el producto.
- `v.cantidad`: cantidad de unidades compradas de dicho producto.
- `v.precio_unitario`: precio individual pactado al momento de la venta.

### 3.2. FROM e INNER JOIN

```sql
FROM registro_venta v
INNER JOIN cliente c  ON v.cliente_id  = c.cliente_id
INNER JOIN persona pe ON c.persona_id = pe.persona_id
INNER JOIN producto p ON v.producto_id = p.producto_id
```

Se vinculan cuatro tablas esenciales del modelo de datos:

- `registro_venta`: actúa como tabla central de la consulta, conteniendo los datos de la transacción, las cantidades y los precios aplicados.
- `cliente`: se une mediante `cliente_id` para obtener el DNI del comprador.
- `persona`: se une mediante persona_id para obtener domicilio y teléfono.
- `producto`: se une mediante `producto_id` para recuperar las características descriptivas del artículo vendido.

### 3.3. Cálculos y Funciones de Ventana

```sql
(v.cantidad * v.precio_unitario) AS subtotal_renglon,

SUM(v.cantidad * v.precio_unitario) OVER(
    PARTITION BY v.registro_venta_id
) AS total_comprobante
```

Se realizan dos cálculos aritméticos clave:

- **Subtotal por renglón:** multiplica la cantidad de unidades por su precio unitario (`v.cantidad * v.precio_unitario`) para determinar el importe del ítem específico.
- **Total comprobante:** utiliza `SUM(...) OVER(PARTITION BY v.registro_venta_id)`. Como `registro_venta_id` es una clave primaria única, cada partición contiene una sola fila y el resultado coincide con `cantidad * precio_unitario`. En este esquema la función de ventana es redundante; no agrupa varios productos.

### 3.4. WHERE

```sql
WHERE v.registro_venta_id = 1;
```

Filtra el resultado para obtener exclusivamente el registro de venta N° 1 y sus datos relacionados.

## 4. Interpretación de los resultados

La consulta devuelve una fila si existe la venta seleccionada. Esa fila corresponde a un producto e incluye:

- **nro_comprobante:** número de factura o transacción.
- **fecha_emision:** fecha de realización de la venta.
- **dni_cliente / telefono / domicilio:** datos de contacto e identificación del cliente.
- **forma_pago:** método utilizado para cancelar el importe.
- **descripcion_producto / marca / categoria:** detalle del artículo.
- **cantidad / precio_unitario:** volumen e importe por unidad.
- **subtotal_renglon:** importe parcial correspondiente a ese producto.
- **total_comprobante:** importe calculado para ese registro de venta.

El modelo actual no tiene un identificador común que agrupe distintos registros en un comprobante de varios productos. Si el registro indicado no existe, la consulta no devuelve filas.