-- ETAPA IV: CONSULTAS Y CASOS DE USO
-- Punto 2: Reporte Agregado
-- Total de ventas realizadas por categoria de producto en un rango de fechas

SELECT 
    p.categoria AS Categoria,
    COUNT(rv.registro_venta_id) AS Cantidad_Operaciones,
    SUM(rv.cantidad) AS Unidades_Vendidas,
    SUM(rv.monto_total) AS Total_Recaudado
FROM 
    registro_venta rv
INNER JOIN 
    producto p ON rv.producto_id = p.producto_id
WHERE 
    rv.fecha_compra BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59'
GROUP BY 
    p.categoria
ORDER BY 
    Total_Recaudado DESC;