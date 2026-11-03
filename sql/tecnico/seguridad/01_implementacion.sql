/* Punto Digital - Equipo 14 - Etapa V: Seguridad.
   SQL Server Express 2012 o posterior. Ejecutar como dbo en una COPIA
   de la base, con las cinco tablas del DDL original bajo el esquema dbo.
   Instalacion unica: si hay nombres existentes, se detiene sin sobrescribir.
   Un solo lote, sin GO: la instalacion completa es transaccional. */
SET NOCOUNT ON;
SET XACT_ABORT ON;
IF DB_NAME() IN ('master','model','msdb','tempdb')
    THROW 51000, 'Seleccione la base de prueba de Punto Digital.', 1;
IF @@TRANCOUNT <> 0 THROW 51000, 'Ejecute sin transacciones abiertas.', 1;
IF OBJECT_ID('dbo.cliente','U') IS NULL OR OBJECT_ID('dbo.proveedor','U') IS NULL
 OR OBJECT_ID('dbo.producto','U') IS NULL OR OBJECT_ID('dbo.registro_venta','U') IS NULL
 OR OBJECT_ID('dbo.registro_compra','U') IS NULL
    THROW 51000, 'Faltan tablas del DDL en dbo.', 1;
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name IN
 ('seg14_admin','seg14_lector','seg14_con_rol','seg14_sin_rol',
  'seg14_rol_consulta','seg14_rol_ventas'))
 OR OBJECT_ID('dbo.usp_seg14_registrar_venta') IS NOT NULL
    THROW 51000, 'Ya existen objetos seg14. Revise la instalacion previa.', 1;
-- La cadena de propiedad requiere el mismo propietario efectivo: dbo.
IF EXISTS (SELECT 1 FROM sys.objects o JOIN sys.schemas s ON s.schema_id=o.schema_id
 WHERE o.object_id IN (OBJECT_ID('dbo.cliente'),OBJECT_ID('dbo.producto'),OBJECT_ID('dbo.registro_venta'))
 AND COALESCE(o.principal_id,s.principal_id) <> DATABASE_PRINCIPAL_ID('dbo'))
    THROW 51000, 'Las tablas utilizadas deben tener propietario efectivo dbo.', 1;
BEGIN TRY
 BEGIN TRANSACTION;
 CREATE USER seg14_admin WITHOUT LOGIN;
 CREATE USER seg14_lector WITHOUT LOGIN;
 CREATE USER seg14_con_rol WITHOUT LOGIN;
 CREATE USER seg14_sin_rol WITHOUT LOGIN;
 CREATE ROLE seg14_rol_consulta AUTHORIZATION dbo;
 CREATE ROLE seg14_rol_ventas AUTHORIZATION dbo;
 ALTER ROLE db_owner ADD MEMBER seg14_admin;
 GRANT SELECT ON OBJECT::dbo.producto TO seg14_lector;
 GRANT SELECT ON OBJECT::dbo.producto TO seg14_rol_consulta;
 ALTER ROLE seg14_rol_consulta ADD MEMBER seg14_con_rol;
 -- DENY explicito para ilustrar la prohibicion de escritura directa.
 DENY INSERT, UPDATE, DELETE ON OBJECT::dbo.registro_venta TO seg14_lector;
 DENY INSERT, UPDATE, DELETE ON OBJECT::dbo.producto TO seg14_lector;
 DENY INSERT, UPDATE, DELETE ON OBJECT::dbo.registro_venta TO seg14_rol_ventas;
 DENY INSERT, UPDATE, DELETE ON OBJECT::dbo.producto TO seg14_rol_ventas;
 EXEC(N'CREATE PROCEDURE dbo.usp_seg14_registrar_venta
 @cliente_id INT,
 @producto_id INT,
 @cantidad INT,
 @metodo_pago VARCHAR(8000)
 AS
 BEGIN
 SET NOCOUNT ON;
 SET XACT_ABORT ON;
 -- Este procedimiento controla su propia transaccion.
 IF @@TRANCOUNT <> 0 THROW 51001, ''Ejecutar fuera de otra transaccion.'', 1;
 IF @cantidad IS NULL OR @cantidad <= 0
     THROW 51002, ''La cantidad debe ser positiva.'', 1;
 IF @metodo_pago IS NULL OR DATALENGTH(@metodo_pago)>30 OR
    @metodo_pago NOT IN (''Efectivo'',''Tarjeta_Debito'',''Tarjeta_Credito'',''Transferencia'')
     THROW 51003, ''Metodo de pago no admitido.'', 1;
 DECLARE @precio DECIMAL(10,2), @stock INT, @total DECIMAL(21,2), @venta INT;
 BEGIN TRY
  BEGIN TRANSACTION;
  IF NOT EXISTS (SELECT 1 FROM dbo.cliente WITH (HOLDLOCK) WHERE cliente_id=@cliente_id)
      THROW 51004, ''Cliente inexistente.'', 1;
  SELECT @precio=precio_venta, @stock=stock
  FROM dbo.producto WITH (UPDLOCK,HOLDLOCK) WHERE producto_id=@producto_id;
  IF @precio IS NULL THROW 51005, ''Producto inexistente.'', 1;
  IF @stock < @cantidad THROW 51006, ''Stock insuficiente.'', 1;
  SET @total=CAST(@precio AS DECIMAL(10,2))*CAST(@cantidad AS DECIMAL(10,0));
  IF @total>99999999.99 THROW 51007, ''El total excede DECIMAL(10,2).'', 1;
  UPDATE dbo.producto SET stock=stock-@cantidad WHERE producto_id=@producto_id;
  INSERT dbo.registro_venta
   (cliente_id,producto_id,cantidad,precio_unitario,monto_total,metodo_pago)
  VALUES (@cliente_id,@producto_id,@cantidad,@precio,CAST(@total AS DECIMAL(10,2)),@metodo_pago);
  SET @venta=CONVERT(INT,SCOPE_IDENTITY());
  COMMIT TRANSACTION;
  SELECT @venta AS registro_venta_id, @total AS monto_total;
 END TRY
 BEGIN CATCH
  IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
  THROW;
 END CATCH;
 END;');
 GRANT EXECUTE ON OBJECT::dbo.usp_seg14_registrar_venta TO seg14_lector;
 GRANT EXECUTE ON OBJECT::dbo.usp_seg14_registrar_venta TO seg14_rol_ventas;
 COMMIT TRANSACTION;
 PRINT 'Instalacion terminada. Ejecute 02_pruebas.sql.';
END TRY
BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
 THROW;
END CATCH;
