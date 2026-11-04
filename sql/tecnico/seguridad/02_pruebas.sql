/* Ejecutar completo como dbo, en la MISMA base de prueba, despues de 01.
   Los datos ficticios se crean y eliminan. Los valores IDENTITY consumidos
   no se recuperan. Si se interrumpe la conexion, revisar datos SEG14_PRUEBA.
   No ejecutar sobre una base con otros procedimientos/triggers de stock
   sin revisar antes su interaccion con esta demostracion. */
SET NOCOUNT ON;
SET XACT_ABORT OFF;
IF DB_NAME() IN ('master','model','msdb','tempdb')
 THROW 51000, 'Seleccione la base de prueba.', 1;
IF @@TRANCOUNT<>0 THROW 51000, 'Ejecute sin transacciones abiertas.', 1;
IF OBJECT_ID('dbo.usp_seg14_registrar_venta','P') IS NULL
 THROW 51000, 'Ejecute primero 01_implementacion.sql.', 1;
DECLARE @cliente INT, @producto INT, @suplantado BIT=0;
DECLARE @dni VARCHAR(15)='S'+LEFT(REPLACE(CONVERT(VARCHAR(36),NEWID()),'-',''),14);
DECLARE @resultados TABLE
 (prueba INT, descripcion NVARCHAR(180), usuario SYSNAME,
  esperado INT, obtenido INT, evaluacion VARCHAR(12), detalle NVARCHAR(2048));
DECLARE @casos TABLE
 (id INT, descripcion NVARCHAR(180), usuario SYSNAME, error_esperado INT, sentencia NVARCHAR(MAX));
INSERT @casos VALUES
 (1,N'Consulta mediante rol','seg14_con_rol',0,N'SELECT producto_id,nombre,stock,precio_venta FROM dbo.producto WHERE producto_id=@p;'),
 (2,N'Consulta sin rol','seg14_sin_rol',229,N'SELECT producto_id FROM dbo.producto WHERE producto_id=@p;'),
 (3,N'INSERT directo administrador (se revierte)','seg14_admin',0,N'BEGIN TRANSACTION; INSERT dbo.registro_venta(cliente_id,producto_id,cantidad,precio_unitario,monto_total,metodo_pago) VALUES(@c,@p,1,100,100,''Efectivo''); ROLLBACK TRANSACTION;'),
 (4,N'INSERT directo usuario limitado','seg14_lector',229,N'INSERT dbo.registro_venta(cliente_id,producto_id,cantidad,precio_unitario,monto_total,metodo_pago) VALUES(@c,@p,1,100,100,''Efectivo'');'),
 (5,N'Venta autorizada mediante procedimiento','seg14_lector',0,N'EXEC dbo.usp_seg14_registrar_venta @c,@p,2,''Efectivo'';'),
 (6,N'Cantidad invalida','seg14_lector',51002,N'EXEC dbo.usp_seg14_registrar_venta @c,@p,0,''Efectivo'';'),
 (7,N'Stock insuficiente','seg14_lector',51006,N'EXEC dbo.usp_seg14_registrar_venta @c,@p,999,''Efectivo'';'),
 (8,N'Metodo de pago invalido','seg14_lector',51003,N'EXEC dbo.usp_seg14_registrar_venta @c,@p,1,''Cheque'';'),
 (9,N'Cliente inexistente','seg14_lector',51004,N'EXEC dbo.usp_seg14_registrar_venta NULL,@p,1,''Efectivo'';'),
 (10,N'Producto inexistente','seg14_lector',51005,N'EXEC dbo.usp_seg14_registrar_venta @c,NULL,1,''Efectivo'';'),
 (11,N'Consulta de clientes no autorizada','seg14_lector',229,N'SELECT cliente_id,dni_cliente FROM dbo.cliente WHERE cliente_id=@c;'),
 (12,N'Ejecucion sin permiso','seg14_sin_rol',229,N'EXEC dbo.usp_seg14_registrar_venta @c,@p,1,''Efectivo'';');
BEGIN TRY
 INSERT dbo.cliente(dni_cliente,numero_telefono,calle,localidad,provincia)
 VALUES(@dni,NULL,'SEG14_PRUEBA','Prueba','Prueba');
 SET @cliente=CONVERT(INT,SCOPE_IDENTITY());
 INSERT dbo.producto(nombre,marca,categoria,color,stock,precio_venta)
 VALUES('SEG14_PRUEBA','Prueba','Prueba','Prueba',10,100);
 SET @producto=CONVERT(INT,SCOPE_IDENTITY());
 DECLARE @i INT=1, @usuario SYSNAME, @sql NVARCHAR(MAX), @esperado INT,
         @descripcion NVARCHAR(180), @error INT, @detalle NVARCHAR(2048);
 WHILE @i<=12
 BEGIN
  SELECT @usuario=usuario,@sql=sentencia,@esperado=error_esperado,@descripcion=descripcion
  FROM @casos WHERE id=@i;
  SELECT @error=0,@detalle=N'Operacion completada';
  BEGIN TRY
   EXECUTE AS USER=@usuario;
   SET @suplantado=1;
   EXEC sys.sp_executesql @sql,N'@c INT,@p INT',@c=@cliente,@p=@producto;
   REVERT;
   SET @suplantado=0;
  END TRY
  BEGIN CATCH
   SELECT @error=ERROR_NUMBER(),@detalle=ERROR_MESSAGE();
   IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
   IF @suplantado=1 BEGIN REVERT; SET @suplantado=0; END;
  END CATCH;
  INSERT @resultados VALUES(@i,@descripcion,@usuario,@esperado,@error,
   CASE WHEN @error=@esperado THEN 'COINCIDE' ELSE 'REVISAR' END,@detalle);
  SET @i+=1;
 END;
 -- Verificacion real de efectos, como administrador, antes de limpiar.
 DECLARE @stock INT,@ventas INT,@precio DECIMAL(10,2),@total DECIMAL(10,2),@cantidad INT;
 SELECT @stock=stock FROM dbo.producto WHERE producto_id=@producto;
 SELECT @ventas=COUNT(*),@precio=MAX(precio_unitario),@total=MAX(monto_total),@cantidad=MAX(cantidad)
 FROM dbo.registro_venta WHERE producto_id=@producto;
 SELECT @stock AS stock_obtenido,8 AS stock_esperado,
        @ventas AS ventas_obtenidas,1 AS ventas_esperadas,
        @precio AS precio_obtenido,100 AS precio_esperado,
        @total AS total_obtenido,200 AS total_esperado,
        @cantidad AS cantidad_obtenida,2 AS cantidad_esperada,
        CASE WHEN @stock=8 AND @ventas=1 AND @precio=100 AND @total=200 AND @cantidad=2
             THEN 'COINCIDE' ELSE 'REVISAR' END AS verificacion;
 -- Limpieza limitada a los IDs creados por esta ejecucion.
 DELETE dbo.registro_venta WHERE producto_id=@producto;
 DELETE dbo.producto WHERE producto_id=@producto;
 DELETE dbo.cliente WHERE cliente_id=@cliente;
 SELECT * FROM @resultados ORDER BY prueba;
END TRY
BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
 IF @suplantado=1 REVERT;
 DELETE dbo.registro_venta WHERE producto_id=@producto;
 DELETE dbo.producto WHERE producto_id=@producto;
 DELETE dbo.cliente WHERE cliente_id=@cliente;
 THROW;
END CATCH;

