# Consultas y Casos de Uso

**Punto 2: Reporte Agregado — Ventas por Categoría de Producto**

## 1. Caso de uso de negocio

El encargado de ventas de Punto Digital necesita conocer el total de ventas realizadas por cada categoría de producto durante un período determinado.

El objetivo es identificar qué categorías generan mayores ingresos, cuántos registros de venta corresponden a cada una y cuántas unidades fueron vendidas.

Esta información permite analizar el rendimiento comercial de las diferentes categorías, facilitar el control de ventas y contribuir a la toma de decisiones relacionadas con el stock y la comercialización de productos.

Para obtener estos resultados, se utilizan las tablas `registro_venta` y `producto`, relacionadas mediante el campo `producto_id`.

La consulta emplea las funciones de agregación `COUNT` y `SUM`, junto con `GROUP BY`, para agrupar y calcular los resultados por categoría.

**Resultado esperado:** obtener un listado de las categorías de productos que registraron ventas durante agosto de 2026, indicando la cantidad de registros, las unidades vendidas y el importe total recaudado.

## 2. Consulta SQL

```sql
SELECT
    p.categoria AS Categoria,
    COUNT(rv.registro_venta_id) AS Cantidad_Operaciones,
    SUM(rv.cantidad) AS Unidades_Vendidas,
    SUM(rv.monto_total) AS Total_Recaudado
FROM registro_venta rv
INNER JOIN producto p
    ON rv.producto_id = p.producto_id
WHERE
    rv.fecha_compra >= '2026-08-01'
    AND rv.fecha_compra < '2026-09-01'
GROUP BY
    p.categoria
ORDER BY
    Total_Recaudado DESC;
```

## 3. Explicación de la consulta

### 3.1. SELECT

Se seleccionan los datos que aparecerán en el resultado de la consulta:

- `p.categoria`: indica la categoría del producto vendido.
- `COUNT(rv.registro_venta_id)`: cuenta los registros de venta correspondientes a cada categoría.
- `SUM(rv.cantidad)`: calcula el total de unidades vendidas.
- `SUM(rv.monto_total)`: calcula el importe total recaudado por categoría.

La instrucción `AS` permite asignar nombres a las columnas para facilitar la lectura de los resultados.

### 3.2. FROM e INNER JOIN

```sql
FROM registro_venta rv
INNER JOIN producto p
    ON rv.producto_id = p.producto_id
```

Se utilizan dos tablas:

- `registro_venta`: contiene las ventas realizadas, sus cantidades, fechas y montos.
- `producto`: contiene la información de los productos, incluyendo su categoría.

`INNER JOIN` permite relacionar los registros de ambas tablas mediante el campo `producto_id`.

De esta manera, cada registro de venta se relaciona con el producto correspondiente y se identifica su categoría.

### 3.3. WHERE

```sql
WHERE
    rv.fecha_compra >= '2026-08-01'
    AND rv.fecha_compra < '2026-09-01'
```

La condición permite seleccionar únicamente las ventas realizadas durante agosto de 2026.

Se establece una fecha inicial y una fecha límite, evitando incluir ventas realizadas fuera del período indicado.

### 3.4. GROUP BY

```sql
GROUP BY p.categoria
```

Agrupa los registros de venta que pertenecen a una misma categoría de producto.

Esto permite calcular los totales de cada categoría por separado.

### 3.5. Funciones de agregación: COUNT y SUM

```sql
COUNT(rv.registro_venta_id) AS Cantidad_Operaciones,
SUM(rv.cantidad) AS Unidades_Vendidas,
SUM(rv.monto_total) AS Total_Recaudado
```

Se utilizan dos funciones de agregación:

- `COUNT()`: cuenta los registros de venta de cada categoría.
- `SUM()`: suma las cantidades de productos vendidos y los montos correspondientes a cada categoría.

Es importante distinguir que la cantidad de registros no representa necesariamente la cantidad de facturas o compras completas, ya que cada fila de `registro_venta` corresponde a un producto registrado en una venta.

### 3.6. ORDER BY

```sql
ORDER BY Total_Recaudado DESC;
```

Ordena los resultados de mayor a menor según el importe total recaudado.

De esta forma, las categorías que generan mayores ingresos aparecen primero en el listado.

## 4. Interpretación de los resultados

La consulta devuelve un listado de las categorías que registraron ventas durante agosto de 2026.

Cada fila contiene:

- **Categoría:** nombre de la categoría del producto.
- **Cantidad_Operaciones:** cantidad de registros de venta correspondientes a esa categoría.
- **Unidades_Vendidas:** suma de las unidades vendidas.
- **Total_Recaudado:** suma de los importes registrados.

Los resultados se presentan ordenados desde la categoría con mayor recaudación hasta la de menor recaudación.

Esta información permite identificar las categorías con mayor actividad comercial y analizar su participación en las ventas de Punto Digital.

Si una categoría no registra ventas durante el período seleccionado, no aparecerá en el resultado.
