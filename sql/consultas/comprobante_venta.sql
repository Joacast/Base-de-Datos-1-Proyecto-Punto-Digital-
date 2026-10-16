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