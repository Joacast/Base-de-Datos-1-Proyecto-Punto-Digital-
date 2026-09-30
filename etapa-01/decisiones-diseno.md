# Decisiones de Diseño - Punto Digital
**Equipo:** 14  
**Proyecto:** "Punto Digital" - Tienda de electrónica  
**Etapa:** I – Definición del Caso, Alcance y Reglas de Negocio  

---

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
Decisión: Se decidió mantener categoria, marca y metodo_pago como atributos descriptivos directos en las entidades principales.

Justificación: Optimiza la lectura de datos frecuentes evitando un exceso de tablas de catálogo (JOINs innecesarios) en esta etapa del sistema, garantizando la simplicidad de las consultas directas.

### Atributo Multivaluado para Canales de Contacto:
Decisión: El atributo numero_telefono se contempló de forma flexible.

Justificación: Permite capturar las vías de contacto necesarias para la gestión comercial con clientes y proveedores.

### Control Dinámico del Stock (RN.01):
Decisión: El atributo stock se aloja de forma directa en la entidad PRODUCTO.

Justificación: Permite la actualización inmediata de existencias ante cada transacción registrada de compra o venta, asegurando el cumplimiento directo de la regla de negocio RN.01.
