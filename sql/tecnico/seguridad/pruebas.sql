-- Ejecutar como administrador, después de cargar los datos e instalar Seguridad.
-- La última prueba registra una venta y descuenta una unidad del producto 1.

-- 1. Con rol de consulta: debe mostrar el catálogo.
BEGIN TRY
    EXECUTE AS USER = 'seg14_con_rol';
    SELECT producto_id, nombre, stock FROM dbo.producto;
    REVERT;
END TRY
BEGIN CATCH
    REVERT;
    SELECT ERROR_NUMBER() AS error, ERROR_MESSAGE() AS mensaje;
END CATCH;

-- 2. Sin rol: debe rechazar la consulta con error 229.
BEGIN TRY
    EXECUTE AS USER = 'seg14_sin_rol';
    SELECT producto_id, nombre FROM dbo.producto;
    REVERT;
END TRY
BEGIN CATCH
    REVERT;
    SELECT ERROR_NUMBER() AS error, ERROR_MESSAGE() AS mensaje;
END CATCH;

-- 3. Administrador: puede insertar. Se revierte para no guardar esta prueba.
BEGIN TRY
    EXECUTE AS USER = 'seg14_admin';
    BEGIN TRANSACTION;
    INSERT INTO dbo.registro_venta
        (cliente_id, producto_id, cantidad, precio_unitario, monto_total, metodo_pago)
    SELECT 1, producto_id, 1, precio_venta, precio_venta, 'Efectivo'
    FROM dbo.producto WHERE producto_id = 1;
    ROLLBACK TRANSACTION;
    REVERT;
    PRINT 'El administrador pudo insertar. La prueba se revirtio.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    REVERT;
    SELECT ERROR_NUMBER() AS error, ERROR_MESSAGE() AS mensaje;
END CATCH;

-- 4. Lector: no puede insertar directamente (error 229).
BEGIN TRY
    EXECUTE AS USER = 'seg14_lector';
    BEGIN TRANSACTION;
    INSERT INTO dbo.registro_venta
        (cliente_id, producto_id, cantidad, precio_unitario, monto_total, metodo_pago)
    SELECT 1, producto_id, 1, precio_venta, precio_venta, 'Efectivo'
    FROM dbo.producto WHERE producto_id = 1;
    ROLLBACK TRANSACTION;
    REVERT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    REVERT;
    SELECT ERROR_NUMBER() AS error, ERROR_MESSAGE() AS mensaje;
END CATCH;

-- 5. Lector: no puede consultar los datos de Persona (error 229).
BEGIN TRY
    EXECUTE AS USER = 'seg14_lector';
    SELECT persona_id, numero_telefono FROM dbo.persona;
    REVERT;
END TRY
BEGIN CATCH
    REVERT;
    SELECT ERROR_NUMBER() AS error, ERROR_MESSAGE() AS mensaje;
END CATCH;

-- 6. Lector: puede registrar una venta mediante el procedimiento.
SELECT producto_id, stock FROM dbo.producto WHERE producto_id = 1;
BEGIN TRY
    EXECUTE AS USER = 'seg14_lector';
    EXEC dbo.sp_registrar_venta 1, 1, 1, 'Efectivo';
    REVERT;
END TRY
BEGIN CATCH
    REVERT;
    SELECT ERROR_NUMBER() AS error, ERROR_MESSAGE() AS mensaje;
END CATCH;
SELECT producto_id, stock FROM dbo.producto WHERE producto_id = 1;
SELECT TOP 1 * FROM dbo.registro_venta ORDER BY registro_venta_id DESC;

-- Usuarios y roles.
SELECT u.name AS usuario, r.name AS rol
FROM sys.database_role_members m
INNER JOIN sys.database_principals u ON u.principal_id = m.member_principal_id
INNER JOIN sys.database_principals r ON r.principal_id = m.role_principal_id
WHERE u.name LIKE 'seg14%';
