-- PROYECTO PUNTO DIGITAL - EQUIPO 14
-- ETAPA IV: CONSULTAS Y CASOS DE USO
-- PUNTO 2: REPORTE AGREGADO DE VENTAS POR CATEGORIA

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