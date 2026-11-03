---------------------------------------------------------
-- Manejo de Transacciones - ETAPA V
---------------------------------------------------------

Definición y objetivo:
Una transacción es un bloque de operaciones SQL que se ejecuta como una única unidad lógica de trabajo. Su objetivo es garantizar las propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad), asegurando que si una sola instrucción falla dentro de un proceso complejo, todas las modificaciones previas se deshagan automáticamente para no corromper la base de datos.

Ventajas y aplicaciones en Punto Digital:
La aplicación de transacciones resuelve directamente la problemática identificada de "Inconsistencia en el inventario" y garantiza el cumplimiento de la regla de "Integridad de transacciones y detalle". Su principal ventaja es asegurar que una venta registre su encabezado, desglose sus productos en la línea de detalle (fijando el precio histórico) y descuente el stock en un solo movimiento. Si el sistema falla a la mitad, evita que queden cobros sin detalle de productos o stock descontado sin una venta asociada.

Aplicamos las transacciones al proceso central de comercialización de productos tecnológicos, respetando la regla "Gestión y control de stock".
Escenario: Un cliente compra un celular. El sistema inicia la transacción e intenta: 1) Registrar la venta asociada al cliente, 2) Registrar el detalle conservando el precio inmutable actual, y 3) Descontar el stock. Si al intentar descontar el stock se detecta que este quedaría en un valor negativo (lo cual está estrictamente prohibido por regla de negocio), la transacción ejecuta un ROLLBACK y cancela toda la operación comercial.