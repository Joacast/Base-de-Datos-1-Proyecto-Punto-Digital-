/* PLANTILLA OPCIONAL, NO EJECUTAR SIN EDITAR.
   La guia muestra CREATE LOGIN y CREATE USER FOR LOGIN. La demostracion
   reproducible usa WITHOUT LOGIN + EXECUTE AS USER. Para conexion real:
   1. Reemplazar EQUIPO\CuentaWindows por una cuenta existente.
   2. Ejecutar CREATE LOGIN con permisos de administrador del servidor.
   3. En la base de Punto Digital crear el usuario y asignarle los roles.
   No otorgar db_owner al vendedor. No incluye contrasenas de ejemplo.

USE master;
CREATE LOGIN [EQUIPO\CuentaWindows] FROM WINDOWS;
-- Seleccionar ahora la base de Punto Digital en SSMS.
CREATE USER seg14_vendedor_real FOR LOGIN [EQUIPO\CuentaWindows];
ALTER ROLE seg14_rol_consulta ADD MEMBER seg14_vendedor_real;
ALTER ROLE seg14_rol_ventas ADD MEMBER seg14_vendedor_real;

   Abrir una conexion con esa identidad de Windows para probar autenticacion.
   WITHOUT LOGIN no permite iniciar una conexion independiente.
   La plantilla completa esta comentada para evitar crear cuentas ficticias.
*/
