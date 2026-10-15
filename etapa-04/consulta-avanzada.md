## Consultas y Casos de Uso

**Punto 3: Consulta de Negocio Avanzada — Clientes VIP por Provincia**

## 1. Caso de uso de negocio

El gerente comercial necesita identificar a los **clientes VIP o frecuentes que residan en la provincia de Corrientes** para ofrecerles una promoción exclusiva.

Para ello, se considerarán clientes VIP aquellos cuyo monto acumulado de compras registradas supere los $50.000. La consulta permite identificar a estos clientes, conocer la cantidad de registros de venta asociados a cada uno y ordenar los resultados según el monto acumulado, de mayor a menor.

Esta información le permitirá al gerente comercial reconocer a los clientes que representan un mayor volumen de compras y orientar las acciones promocionales hacia ellos, con el objetivo de fortalecer la relación con los clientes, incentivar nuevas compras y fomentar su fidelización.

La consulta utiliza las tablas `Persona`, `Cliente`, `Registro_Venta` y `Producto` para relacionar los datos personales, la provincia de residencia y los montos de las ventas registradas. Mediante las cláusulas `WHERE`, `GROUP BY` y `HAVING`, se seleccionan los clientes de Corrientes, se agrupan sus registros de venta y se filtran aquellos cuyo monto acumulado supera el límite establecido de $50.000.

**Resultado esperado:** obtener un listado de clientes de Corrientes que superen el monto acumulado definido, junto con sus datos identificatorios y el total registrado de sus compras, para facilitar la selección de destinatarios de una promoción comercial exclusiva.

## 2. Consulta SQL

```sql

SELECT
    p.persona_id,
    c.DNI_Cliente,
    p.Provincia,
    COUNT(rv.Id_Registro_Ventas) AS total_registros_venta,
    SUM(rv.Monto_Total) AS monto_total_acumulado
FROM Persona p
INNER JOIN Cliente c
    ON p.persona_id = c.persona_id
INNER JOIN Registro_Venta rv
    ON c.Id_Cliente = rv.Id_Cliente
INNER JOIN Producto prod
    ON rv.Id_Producto = prod.Id_Producto
WHERE p.Provincia = 'Corrientes'
GROUP BY
    p.persona_id,
    c.DNI_Cliente,
    p.Provincia
HAVING SUM(rv.Monto_Total) > 50000.00
ORDER BY monto_total_acumulado DESC;
```
