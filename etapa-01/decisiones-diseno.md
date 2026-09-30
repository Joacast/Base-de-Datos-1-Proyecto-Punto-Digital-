# Decisiones de Diseño - Punto Digital
**Equipo:** 14  
**Proyecto:** "Punto Digital" - Tienda de electrónica  
**Etapa:** I – Definición del Caso, Alcance y Reglas de Negocio  

---
# Etapa 1

## Tratamiento de Atributos Específicos

### Separación entre Precio_Actual y Precio_Historico
* **Decisión:** Se define el atributo `Precio_Actual` (o precio de lista) en la entidad `PRODUCTO`, y de forma separada se almacena el atributo `Precio_Unitario_Historico` dentro del detalle de la transacción (`DETALLE_COMPRA` / `DETALLE_VENTA`).
* **Justificación basada en RN.04:** Mantiene la integridad histórica del negocio. Modificar el precio de venta actual de un celular o accesorio no debe alterar retroactivamente el monto facturado en operaciones registradas en el pasado.

### Descomposición del Atributo Compuesto Dirección
* **Decisión:** Para las entidades `CLIENTE` y `PROVEEDOR`, el atributo general `Dirección` se descompone en atributos atómicos: `Calle`, `Altura`, `Localidad` y `Provincia`.
* **Justificación técnica:** Garantiza la atomicidad de los datos desde la concepción del modelo conceptual, facilitando futuros filtros por zona geográfica, logística de entregas y asegurando una transición directa a la Primera Forma Normal (1FN).

---

## Decisiones Estructurales y de Modelado

### Desacoplamiento entre Registro General y Detalle de la Operación
* **Decisión:** La operación comercial se modela separando la cabecera (`COMPRA` / `VENTA`) de su contenido (`DETALLE_COMPRA` / `DETALLE_VENTA`). La cabecera almacena los datos globales (identificador único, fecha, cliente asociado y monto total), mientras que el detalle registra cada producto individual, la cantidad adquirida y su precio histórico.
* **Justificación basada en RN.06:** Cumple con la regla que exige que cada transacción pueda contener uno o múltiples productos sin redundar los datos del cliente ni la fecha por cada ítem adquirido.

### Normalización de Métodos de Pago
* **Decisión:** Se modela `METODO_PAGO` como una entidad independiente (catálogo tipificado con valores como *Efectivo, Tarjeta de Débito, Tarjeta de Crédito, Transferencia*) relacionada con la operación comercial.
* **Justificación basada en RN.05:** Evita anomalías de escritura y redundancia por ingreso manual de texto plano, permitiendo a su vez que el negocio incorpore nuevos medios de cobro en el futuro sin modificar la estructura principal.

### Relación Muchos a Muchos (N:M) entre Proveedores y Productos
* **Decisión:** Se establece una relación N:M entre `PROVEEDOR` y `PRODUCTO`, que en el modelo lógico se resuelve mediante una tabla intermedia (`PROVEEDOR_PRODUCTO` o `SUMINISTRA`).
* **Justificación basada en RN.07:** Modela fielmente la realidad del negocio donde un mismo proveedor abastece varios artículos y, a su vez, un mismo periférico o celular puede ser provisto por diferentes distribuidores.

### Jerarquía entre Categorías y Productos (Relación 1:N)
* **Decisión:** Se define la entidad `CATEGORIA` de forma independiente a `PRODUCTO`, estableciendo una cardinalidad de 1 a N (un producto pertenece a una sola categoría, pero una categoría agrupa varios productos).
* **Justificación basada en RN.03:** Centraliza la clasificación del catálogo (celulares, computadoras, accesorios) asegurando consistencia y facilitando la gestión y consulta del stock disponible (RN.01).

---

## Puntos Complementarios de Diseño (Alineación Conceptual y Lógica)

### Especialización / Jerarquía de Personas (CLIENTE y PROVEEDOR):
Decisión: Se definió la estructura PERSONA para centralizar los datos de contacto compartidos (domicilio, provincia, telefono). 

Justificación: Normaliza el almacenamiento de personas en el sistema y evita duplicar campos de ubicación y contacto entre clientes y proveedores.

### Atributos de Categoría, Marca y Método de Pago:
Normalización de Catálogos (Categoría, Marca y Método de Pago):

Decisión: Se decidió modelar CATEGORIA, MARCA y METODO_PAGO como entidades/catálogos independientes en lugar de atributos simples en texto plano.

Justificación: Evita errores de tipeo y redundancia de datos (por ejemplo, escribir "Samsung", "samsung" o "Samsumg"), facilitando las búsquedas y el filtrado en el sistema.

### Atributo Multivaluado para Canales de Contacto:
Decisión: El atributo numero_telefono se contempló de forma flexible.

Justificación: Permite capturar las vías de contacto necesarias para la gestión comercial con clientes y proveedores.

### Control Dinámico del Stock (RN.01):
Decisión: El atributo stock se aloja de forma directa en la entidad PRODUCTO.

Justificación: Permite la actualización inmediata de existencias ante cada transacción registrada de compra o venta, asegurando el cumplimiento directo de la regla de negocio RN.01.

# Etapa 2

### Decisiones de Mapeo Relacional y Estructura de Tablas
Mapeo de la Jerarquía/Especialización de PERSONA
Decisión de Mapeo: Se resolvió implementar la herencia utilizando una tabla base PERSONA relacionada de 1 a 1 ($1:1$) mediante Claves Primarias/Foráneas compartidas (id_persona) con las tablas CLIENTE y PROVEEDOR.

Justificación: Mantiene los datos compartidos (nombre, apellido, DNI/CUIT, dirección, teléfono) sin redundancia en una sola tabla, garantizando que un cliente o proveedor mantengan integridad referencial sin duplicar campos de contacto ni tablas innecesarias.

### Resolución de Relaciones Muchos a Muchos (N:M)
Decisión:Proveedores y Productos: La relación N:M entre PROVEEDOR y PRODUCTO se convierte en la tabla intermedia PROVEEDOR_PRODUCTO (o SUMINISTRA).
Operaciones e Ítems: Las relaciones $N:M$ entre COMPRA/VENTA y PRODUCTO se resuelven mediante las tablas asociativas DETALLE_COMPRA y DETALLE_VENTA.

Justificación: Permite la representación correcta en un SGBD relacional, alojando atributos propios del vínculo como el precio_compra_historico, precio_venta_historico y la cantidad.

### Selección de Claves Primarias (PK) Surrogadas vs. Naturales
Decisión: Se optó por utilizar Claves Primarias Surrogadas (claves autoincrementales numéricas como id_producto, id_venta, id_cliente) para todas las entidades principales.

Justificación: Optimiza el rendimiento del motor de base de datos en las operaciones de JOIN, reduce el tamaño de los índices en memoria y evita problemas derivados del cambio de claves naturales (como el DNI o CUIT en personas o el código de barras en productos).

### Claves Compuestas en Tablas de Detalle
Decisión: En DETALLE_VENTA y DETALLE_COMPRA, la Clave Primaria (PK) es una clave compuesta formada por (id_venta, id_producto) y (id_compra, id_producto) respectivamente.

Justificación: Garantiza la entidad débil/dependiente: un renglón de detalle no puede existir sin su cabecera y evita que un mismo producto se repita dos veces en el mismo comprobante (las cantidades se acumulan en un único registro).

# Justificación de Normalización (1FN, 2FN, 3FN)
## Primera Forma Normal (1FN) - Atomicidad de Atributos
Decisión: Todos los atributos son atómicos. La dirección se descompuso físicamente en las columnas calle, altura, localidad y provincia.

Justificación: Elimina atributos compuestos y multivaluados dentro de las filas, asegurando que no existan listas de valores en una sola celda.

## Segunda Forma Normal (2FN) - Dependencia Funcional Completa
Decisión: Todos los atributos que no forman parte de una clave compuesta dependen funcionalmente de la totalidad de la clave.

Justificación: En DETALLE_VENTA, atributos como cantidad y precio_unitario_historico dependen de la combinación (id_venta, id_producto). Ningún atributo depende de solo una parte de la clave.

## Tercera Forma Normal (3FN) - Eliminación de Dependencias Transitivas
Decisión: Se extrajeron los catálogos CATEGORIA, MARCA y METODO_PAGO a tablas independientes referenciadas por FKs en PRODUCTO y VENTA/COMPRA.

Justificación: Si guardáramos categoria_nombre dentro de la tabla PRODUCTO, habría una dependencia transitiva (ID_Producto -> ID_Categoria -> Categoria_Nombre). Al separarlas, se elimina la redundancia y el riesgo de anomalías de actualización.

# Puntos Complementarios de Diseño Lógico
## Estrategia para el Manejo de Stock en Tránsito y Físico
Decisión: El atributo stock en PRODUCTO representa el stock disponible real. Se contempla la futura inclusión de columnas o vistas calculadas para stock_minimo y stock_reservado.

Justificación: Asegura respuestas rápidas en consultas de disponibilidad en punto de venta sin requerir calcular la sumatoria histórica de compras y ventas en cada lectura.

## Gestión de Teléfonos Multivaluados (Vías de Contacto)
Decisión: Se resolvió crear la tabla dependiente TELEFONO_PERSONA con una clave compuesta (id_persona, telefono).

Justificación: Cumple estrictamente con la 1FN al aislar los teléfonos multivaluados de la tabla principal PERSONA, permitiendo almacenar múltiples números (celular, fijo, trabajo) por cliente o proveedor.

## Mapeo de Tipos de Datos e Integridad Dominio
Decisión: Uso estricto de tipos de datos adecuados (ej. DECIMAL(10,2) para importes/precios, DATETIME o TIMESTAMP para fechas de operaciones, INT para cantidades).

Justificación: Previene errores de redondeo financiero que ocurren con tipos flotantes (FLOAT/DOUBLE) y asegura la consistencia física de los datos desde la definición del esquema (DDL).
