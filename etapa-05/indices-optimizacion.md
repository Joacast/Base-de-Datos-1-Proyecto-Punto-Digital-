Tema técnico: Índices y Optimización de Consultas en SQL Server

Descripción breve del tema técnico y fundamentos de aplicación:
Los índices en un motor de base de datos relacional como SQL Server son estructuras que mejoran la velocidad de recuperación de datos sin alterar el orden físico de las tablas. Al crear índices non-clustered (no agrupados) sobre las columnas que con mayor frecuencia se utilizan en las cláusulas WHERE, JOIN, GROUP BY o ORDER BY, el motor evita realizar escaneos completos de tablas (Table Scan), reduciendo drásticamente el uso de recursos de entrada/salida (I/O) y el tiempo de respuesta en las consultas.

Fundamento de aplicación en Punto Digital:

En nuestro caso de estudio, la base de datos registra operaciones continuas de venta y consultas analíticas del negocio. A medida que el volumen de transacciones en registro_venta crece, ciertas consultas de negocio clave (como la identificación de Clientes VIP por Provincia o el Reporte Agregado de Ventas Mensuales por Categoría) requieren procesar un gran número de filas.

Para optimizar el rendimiento en Punto Digital, se aplicaron dos índices no agrupados estratégicos:

IX_cliente_provincia: Optimiza la consulta del segmento de clientes filtrados por provincia (como Corrientes), evitando escanear toda la tabla cliente. Además, mediante la cláusula INCLUDE, se incorporan los campos dni_cliente y numero_telefono, logrando una consulta de cobertura (Covering Index) que satisface la búsqueda sin necesidad de lecturas adicionales a la tabla base.

IX_registro_venta_fecha_compra: Optimiza las búsquedas y filtrados por rangos de fecha sobre las transacciones en registro_venta, permitiendo acelerar la generación de reportes mensuales e informes de ventas por categoría sin impactar el tiempo de ejecución.
