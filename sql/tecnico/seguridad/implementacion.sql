-- Ejecutar una sola vez en la base de prueba, como administrador.
-- Instalar antes Transacciones y Procedimientos.

CREATE USER seg14_admin WITHOUT LOGIN;
CREATE USER seg14_lector WITHOUT LOGIN;
CREATE USER seg14_con_rol WITHOUT LOGIN;
CREATE USER seg14_sin_rol WITHOUT LOGIN;

CREATE ROLE seg14_rol_consulta;
CREATE ROLE seg14_rol_ventas;

ALTER ROLE db_owner ADD MEMBER seg14_admin;
ALTER ROLE seg14_rol_consulta ADD MEMBER seg14_con_rol;

GRANT SELECT ON dbo.producto TO seg14_lector;
GRANT SELECT ON dbo.producto TO seg14_rol_consulta;
GRANT EXECUTE ON dbo.sp_registrar_venta TO seg14_lector;
GRANT EXECUTE ON dbo.sp_registrar_venta TO seg14_rol_ventas;
