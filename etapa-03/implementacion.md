## Implementacion de la base de datos:

# Nombre del motor usado 
Microsoft SQL Server

# Descripción de las tablas creadas 
* Persona
* Cliente
* Proveedor
* Producto
* Registro_venta
* Registro_compra

# Qué script DDL se utilizó para crearlas 
Se utlilizo para crear la base de datos (crear_bd.sql)

Persona guarda teléfono, calle, localidad y provincia. Cliente y Proveedor conservan sus IDs y se vinculan con Persona mediante persona_id, obligatorio y único en cada tabla.
