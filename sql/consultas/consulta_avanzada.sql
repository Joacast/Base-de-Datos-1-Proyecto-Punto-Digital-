## 2. Consulta SQL

sql
-- ============================================================================
-- ETAPA IV: CONSULTAS Y CASOS DE USO
-- Punto 3: Consulta de Negocio Avanzada
-- Clientes VIP por Provincia
-- ============================================================================

SELECT
    c.cliente_id,
    c.dni_cliente,
    c.provincia,
    COUNT(rv.registro_venta_id) AS total_registros_venta,
    SUM(rv.monto_total) AS monto_total_acumulado
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

