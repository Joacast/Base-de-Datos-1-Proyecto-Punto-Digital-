# Consultas y Casos de Uso

**Punto 1: Factura / Comprobante de Venta**

## 1. Caso de uso de negocio

El área de atención al cliente y facturación de Punto Digital requiere generar un comprobante o factura de venta consolidado a partir de un registro de compra seleccionado.

El objetivo es obtener una vista unificada que contenga la información del encabezado (datos de la venta y del cliente) junto con el detalle de los productos adquiridos, calculando automáticamente el subtotal correspondiente a cada renglón y el total acumulado general de la operación.

Esta consulta facilita la emisión de comprobantes impresos o digitales, garantizando transparencia en el desglose de precios y cantidades para el cliente y optimizando el control administrativo de las operaciones comerciales.

Para consolidar la información, se relacionan la tabla principal `registro_venta` con las tablas `cliente` y `producto` mediante sus respectivos identificadores (`cliente_id` y `producto_id`).

**Resultado esperado:** Obtener el detalle completo de la venta indicada (por ejemplo, `registro_venta_id = 1`), mostrando datos del comprobante, información del cliente, especificación de productos, subtotal por renglón y total general acumulado.

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
    c.numero_telefono                                         AS telefono,
    CONCAT_WS(', ', c.calle, c.localidad, c.provincia)        AS domicilio,
    v.metodo_pago                                             AS forma_pago,
    
    -- DETALLE / RENGLÓN
    p.nombre                                                  AS descripcion_producto,
    p.marca                                                   AS marca,
    p.categoria                                               AS categoria,
    v.cantidad                                                AS cantidad,
    v.precio_unitario                                         AS precio_unitario,
    
    -- CÁLCULOS
    (v.cantidad * v.precio_unitario)                          AS subtotal_renglon,
    
    -- Calcula el total acumulado de toda la venta por si tiene varios ítems
    SUM(v.cantidad * v.precio_unitario) OVER(
        PARTITION BY v.registro_venta_id
    )                                                         AS total_comprobante

FROM registro_venta v
INNER JOIN cliente c  ON v.cliente_id  = c.cliente_id
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
- `c.numero_telefono`: teléfono de contacto del cliente.
- `CONCAT_WS(', ', c.calle, c.localidad, c.provincia)`: concatena los campos de dirección de la tabla cliente en una sola cadena formateada, omitiendo valores nulos automáticamente para evitar resultados no deseados.
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
INNER JOIN producto p ON v.producto_id = p.producto_id
```

Se vinculan tres tablas esenciales del modelo de datos:

- `registro_venta`: actúa como tabla central de la consulta, conteniendo los datos de la transacción, las cantidades y los precios aplicados.
- `cliente`: se une mediante `cliente_id` para incorporar la información personal y de localización del comprador.
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
- **Total comprobante:** utiliza la función de ventana `SUM(...) OVER(PARTITION BY v.registro_venta_id)` para sumar los subtotales de todos los renglones asociados a la misma venta sin necesidad de colapsar o agrupar las filas con `GROUP BY`. De este modo, en cada línea del comprobante se mantiene visibilidad tanto del valor individual del ítem como del total general acumulado de la compra.

### 3.4. WHERE

```sql
WHERE v.registro_venta_id = 1;
```

Filtra el resultado para obtener exclusivamente los renglones y la información perteneciente a un comprobante específico (en este ejemplo, el registro N° 1).

## 4. Interpretación de los resultados

La consulta devuelve el desglose de la venta seleccionada. Cada fila devuelta representa un renglón/producto del comprobante e incluye:

- **nro_comprobante:** número de factura o transacción.
- **fecha_emision:** fecha de realización de la venta.
- **dni_cliente / telefono / domicilio:** datos de contacto e identificación del cliente.
- **forma_pago:** método utilizado para cancelar el importe.
- **descripcion_producto / marca / categoria:** detalle del artículo.
- **cantidad / precio_unitario:** volumen e importe por unidad.
- **subtotal_renglon:** importe parcial correspondiente a ese producto.
- **total_comprobante:** importe total acumulado de toda la venta.

En caso de que el comprobante contenga múltiples productos, se mostrará una fila por cada ítem conservando el mismo encabezado y el mismo `total_comprobante`, permitiendo una lectura clara tanto para la vista de impresión como para auditorías internas.