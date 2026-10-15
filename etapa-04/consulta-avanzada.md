## Consultas y Casos de Uso

**Punto 3: Consulta de Negocio Avanzada — Clientes VIP por Provincia**

## 1. Caso de uso de negocio

El gerente comercial necesita identificar a los **clientes VIP o frecuentes que residan en la provincia de Corrientes** para ofrecerles una promoción exclusiva.

Para ello, se considerarán clientes VIP aquellos cuyo monto acumulado de compras registradas supere los $50.000. La consulta permite identificar a estos clientes, conocer la cantidad de registros de venta asociados a cada uno y ordenar los resultados según el monto acumulado, de mayor a menor.

Esta información le permitirá al gerente comercial reconocer a los clientes que representan un mayor volumen de compras y orientar las acciones promocionales hacia ellos, con el objetivo de fortalecer la relación con los clientes, incentivar nuevas compras y fomentar su fidelización.

La consulta utiliza las tablas `cliente` y `registro_venta` para relacionar los datos identificatorios de los clientes, su provincia de residencia y los montos de las ventas registradas. Mediante las cláusulas `WHERE`, `GROUP BY` y `HAVING`, se seleccionan los clientes de Corrientes, se agrupan sus registros de venta y se filtran aquellos cuyo monto acumulado supera el límite establecido de $50.000.

**Resultado esperado:** obtener un listado de clientes de Corrientes que superen el monto acumulado definido, junto con sus datos identificatorios y el total registrado de sus compras, para facilitar la selección de destinatarios de una promoción comercial exclusiva.

## 2. Consulta SQL

```sql

SELECT
    c.cliente_id,
    c.dni_cliente,
    c.provincia,
    COUNT(rv.registro_venta_id) AS total_registros_venta,
    SUM(rv.monto_total) AS monto_total_acumulado

## 3. Explicación de la consulta

### 3.1. SELECT

```sql
SELECT
    c.cliente_id,
    c.dni_cliente,
    c.provincia,
    COUNT(rv.registro_venta_id) AS total_registros_venta,
    SUM(rv.monto_total) AS monto_total_acumulado
```

Se seleccionan los datos que se desean mostrar en el resultado:

- `cliente_id`: identifica de manera única a cada cliente.
- `dni_cliente`: permite identificar al cliente mediante su DNI.
- `provincia`: indica la provincia de residencia registrada.
- `COUNT(rv.registro_venta_id)`: cuenta los registros de venta asociados a cada cliente.
- `SUM(rv.monto_total)`: calcula la suma de los montos registrados para cada cliente.

Los alias `total_registros_venta` y `monto_total_acumulado` permiten identificar más fácilmente los resultados de las funciones de agregación.

### 3.2. FROM e INNER JOIN

```sql
FROM cliente c
INNER JOIN registro_venta rv
    ON c.cliente_id = rv.cliente_id
```

Se utilizan las tablas necesarias para relacionar la información de los clientes con sus registros de venta.

- `cliente` aporta el identificador del cliente, el DNI y la provincia.
- `registro_venta` aporta los registros de venta y sus montos totales.

La cláusula `INNER JOIN` combina las filas de ambas tablas que cumplen la condición establecida mediante `ON`.

En este caso, la relación se realiza mediante el campo `cliente_id`, que es la clave primaria de la tabla `cliente` y una clave foránea en la tabla `registro_venta`.

De esta manera, cada registro de venta queda asociado al cliente correspondiente.

### 3.3. WHERE

```sql
WHERE c.provincia = 'Corrientes'
```

Esta condición filtra los registros para considerar únicamente a los clientes cuya provincia registrada es Corrientes.

El filtro se aplica antes de agrupar los registros y calcular los resultados agregados.

### 3.4. GROUP BY

```sql
GROUP BY
    c.cliente_id,
    c.dni_cliente,
    c.provincia
```

Agrupa los registros correspondientes a cada cliente según su identificador, DNI y provincia.

Esto permite calcular, para cada cliente, la cantidad de registros de venta y la suma de sus montos acumulados.

### 3.5. Funciones de agregación: COUNT y SUM

```sql
COUNT(rv.registro_venta_id) AS total_registros_venta,
SUM(rv.monto_total) AS monto_total_acumulado
```

Se utilizan dos funciones de agregación:

- `COUNT()`: cuenta los registros de venta asociados a cada cliente.
- `SUM()`: suma los valores de `monto_total` correspondientes a esos registros.

Es importante distinguir que `COUNT()` cuenta registros de la tabla `registro_venta`, no necesariamente ventas completas o facturas. Esto depende de cómo se registren las operaciones en el sistema.

En el modelo implementado, cada fila de `registro_venta` está asociada a un cliente y a un producto. Por lo tanto, si una misma operación comercial se registra en varias filas, `COUNT()` contará cada una de ellas por separado.

### 3.6. HAVING

```sql
HAVING SUM(rv.monto_total) > 50000.00
```

Filtra los grupos obtenidos mediante `GROUP BY` para mostrar únicamente a los clientes cuyo monto acumulado supera los $50.000.

Se utiliza `HAVING` porque la condición depende del resultado de una función de agregación (`SUM`).

A diferencia de `WHERE`, que filtra filas antes de la agrupación, `HAVING` permite filtrar los grupos después de realizar los cálculos.

### 3.7. ORDER BY

```sql
ORDER BY monto_total_acumulado DESC;
```

Ordena los resultados por monto acumulado de manera descendente (`DESC`), mostrando primero a los clientes con los mayores importes registrados.

## 4. Interpretación de los resultados

El resultado de la consulta muestra los clientes de Corrientes que superan el umbral de $50.000 en montos acumulados registrados.

Cada fila contiene el identificador del cliente, su DNI, la provincia, la cantidad de registros de venta y el monto total acumulado.

Los clientes aparecen ordenados desde el mayor monto acumulado hasta el menor. Si ningún cliente supera el importe establecido, la consulta no devuelve filas.

Esta información permite al gerente comercial identificar a los clientes con mayor volumen de compras registradas en la provincia de Corrientes y utilizar esos datos como criterio para orientar las promociones comerciales y las acciones de fidelización.
FROM cliente c
INNER JOIN registro_venta rv
    ON c.cliente_id = rv.cliente_id
WHERE c.provincia = 'Corrientes'
GROUP BY
    c.cliente_id,
    c.dni_cliente,
    c.provincia
HAVING SUM(rv.monto_total) > 50000.00
ORDER BY monto_total_acumulado DESC;
```
