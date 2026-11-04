### Decisiones de Mapeo Relacional y Estructura de Tablas
Mapeo de la Jerarquía/Especialización de PERSONA
Decisión de Mapeo: PERSONA guarda teléfono, calle, localidad y provincia. CLIENTE y PROVEEDOR conservan sus identificadores propios y tienen persona_id como clave foránea obligatoria y única. Una Persona puede ser cliente y proveedor, con un registro por cada rol. No se utilizan claves primarias compartidas.

Justificación: Centraliza domicilio y teléfono. El DNI permanece en CLIENTE; CUIT y razón social permanecen en PROVEEDOR.

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
Decisión: Todos los atributos son atómicos. La dirección se guarda en PERSONA mediante calle, localidad y provincia; el número forma parte del texto de calle.

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
Decisión: PERSONA tiene un único numero_telefono opcional. No se implementó TELEFONO_PERSONA.

Justificación: Se guarda un valor por teléfono y se comparte el contacto entre los roles de una misma Persona.

## Mapeo de Tipos de Datos e Integridad Dominio
Decisión: Uso estricto de tipos de datos adecuados (ej. DECIMAL(10,2) para importes/precios, DATETIME o TIMESTAMP para fechas de operaciones, INT para cantidades).

Justificación: Previene errores de redondeo financiero que ocurren con tipos flotantes (FLOAT/DOUBLE) y asegura la consistencia física de los datos desde la definición del esquema (DDL).
