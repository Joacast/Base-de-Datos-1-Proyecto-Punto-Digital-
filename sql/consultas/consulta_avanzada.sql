## 2. Consulta SQL

sql
-- ETAPA IV: CONSULTAS Y CASOS DE USO
-- Punto 3: Consulta de Negocio Avanzada
-- Clientes VIP por Provincia

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
