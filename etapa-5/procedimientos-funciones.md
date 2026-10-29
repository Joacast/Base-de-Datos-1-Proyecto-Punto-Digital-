** Descripción breve del tema técnico y fundamentos de aplicación**

* **Tema técnico:** Procedimientos Almacenados (*Stored Procedures*).

* **Descripción breve:** Un procedimiento almacenado es un bloque de instrucciones SQL que se compila y queda guardado directamente en el motor de la base de datos. Puede recibir parámetros de entrada, ejecutar validaciones lógicas, realizar operaciones sobre las tablas y devolver mensajes o resultados sin necesidad de ejecutar sentencias sueltas desde el exterior.

* **Fundamento de aplicación en Punto Digital:** En nuestro caso de estudio, registrar una venta en `registro_venta` requiere varias acciones encadenadas: validar que el cliente exista, comprobar que el producto esté registrado, recuperar su precio unitario actual, calcular el importe total (`cantidad * precio_unitario`), asignar la fecha actual y guardar el método de pago. Si estas operaciones se hicieran manualmente o con consultas independientes, se correría el riesgo de calcular mal los subtotales, ingresar clientes inexistentes o perder coherencia en los datos. Al implementar el procedimiento `sp_registrar_venta`, centralizamos toda esta lógica en el motor: el sistema solo necesita invocar el procedimiento enviando los datos clave y la base de datos se encarga de aplicar las reglas de negocio de forma uniforme, segura y eficiente.
