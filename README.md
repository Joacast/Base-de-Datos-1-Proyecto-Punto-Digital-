# Base de Datos 1 - Proyecto Punto Digital

Integrantes:

-Rodriguez Agustina Ailén DNI: 44294409

-Sarli Ochat, Melina DNI: 44683566

-Castañeda Joaquina Aymara DNI: 46842335

-Ramirez Camila Julieta DNI: 46843127

-Quintana Javier Armando DNI: 44683558


Nombre del Proyecto: “Punto Digital”

Tema del Proyecto: Tienda de electrónica (venta de celulares y accesorios)

Descripción:
1. Descripción del caso
   
El presente proyecto tiene como objetivo diseñar e implementar una base de datos para una tienda de productos electrónicos. La tienda comercializa productos como celulares, computadoras, accesorios, periféricos y otros dispositivos electrónicos de distintas marcas y categorías.
El sistema permitirá gestionar la información relacionada con los productos, categorías, marcas, proveedores y clientes, además de registrar las compras realizadas. También permitirá llevar un control del stock disponible, registrar los métodos de pago utilizados y conservar el precio unitario de los productos al momento de cada compra.
El alcance del sistema comprende la gestión de los productos y su disponibilidad, el registro de clientes, proveedores y compras, así como el detalle de cada compra. La base de datos estará diseñada para garantizar la integridad y consistencia de la información, evitando redundancias y permitiendo consultar correctamente el historial de las operaciones realizadas.

Reglas de Negocio:

RN.01. Gestión de stock: Cada producto debe mantener registrado su stock disponible. El stock se actualiza cuando se realiza una venta y no puede ser negativo.

RN.02. Registro de clientes: Cada cliente debe estar registrado con sus datos identificatorios y puede realizar una o varias compras. Una compra debe estar asociada a un único cliente.

RN.03. Productos y categorías: Cada producto pertenece a una única categoría, mientras que una categoría puede contener múltiples productos.

RN.04. Precio histórico de las compras: El precio unitario registrado en el detalle de una compra debe conservarse independientemente de los cambios posteriores en el precio actual del producto. De esta manera, modificar el precio de un producto no debe alterar compras realizadas anteriormente. 

RN.05. Métodos de pago: Cada compra debe registrarse con un método de pago. Un método de pago puede utilizarse en múltiples compras. Por ejemplo:
Efectivo
Tarjeta de débito
Tarjeta de crédito
Transferencia

RN.06. Registro de compras: Cada compra debe poseer un identificador único, una fecha, un cliente asociado y un total. Además, debe contener al menos un producto.

RN.07. Proveedores: Un proveedor puede suministrar múltiples productos y un producto puede ser suministrado por uno o varios proveedores.
