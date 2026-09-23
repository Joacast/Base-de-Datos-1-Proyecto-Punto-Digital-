## Reglas de Negocio

* **RN.01. Gestión de stock:**  
  Cada producto debe mantener registrado su stock disponible. El stock se actualiza cuando se realiza una venta y no puede ser negativo.

* **RN.02. Registro de clientes:**  
  Cada cliente debe estar registrado con sus datos identificatorios y puede realizar una o varias compras. Una compra debe estar asociada a un único cliente.

* **RN.03. Productos y categorías:**  
  Cada producto pertenece a una única categoría, mientras que una categoría puede contener múltiples productos.

* **RN.04. Precio histórico de las compras:**  
  El precio unitario registrado en el detalle de una compra debe conservarse independientemente de los cambios posteriores en el precio actual del producto. De esta manera, modificar el precio de un producto no debe alterar compras realizadas anteriormente.

* **RN.05. Métodos de pago:**  
  Cada compra debe registrarse con un método de pago. Un método de pago puede utilizarse en múltiples compras.  
  *Ejemplos:*
  * Efectivo
  * Tarjeta de débito
  * Tarjeta de crédito
  * Transferencia

* **RN.06. Registro de compras:**  
  Cada compra debe poseer un identificador único, una fecha, un cliente asociado y un total. Además, debe contener al menos un producto.

* **RN.07. Proveedores:**  
  Un proveedor puede suministrar múltiples productos y un producto puede ser suministrado por uno o varios proveedores.
